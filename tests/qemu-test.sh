#!/bin/bash
# Démarre l'ISO de CHOS dans une machine virtuelle QEMU et vérifie que
# la session (Openbox + barre + Google Chrome) et l'installateur se lancent.
# Des captures d'écran sont enregistrées dans « test-results/ ».
#
# Utilisation : tests/qemu-test.sh out/chos-AAAAMMJJ-amd64.iso
set -euo pipefail

ISO="${1:?Chemin du fichier ISO manquant}"
RES=test-results
WORK=$(mktemp -d)
mkdir -p "$RES"
SERIAL="$RES/serial.log"
: > "$SERIAL"

echo "[test] Extraction du noyau depuis l'ISO"
xorriso -osirrox on -indev "$ISO" -extract /live "$WORK/live" >/dev/null 2>&1
KERNEL=$(ls "$WORK"/live/vmlinuz* | head -n 1)
INITRD=$(ls "$WORK"/live/initrd.img* | head -n 1)
echo "[test] Noyau : $KERNEL"

if [ -w /dev/kvm ]; then
	ACCEL=(-enable-kvm -cpu host)
	FACTOR=1
else
	echo "[test] Pas de KVM : la machine virtuelle sera lente"
	ACCEL=(-accel tcg)
	FACTOR=4
fi

# Mêmes options que le menu de démarrage de l'ISO (voir auto/config),
# plus la console série et « chos.selftest ».
APPEND="boot=live components persistence username=chos user-fullname=CHOS hostname=chos locales=fr_FR.UTF-8 keyboard-layouts=fr timezone=Europe/Paris console=tty0 console=ttyS0,115200 chos.selftest"

qemu-system-x86_64 "${ACCEL[@]}" -m 4096 -smp 2 \
	-cdrom "$ISO" -kernel "$KERNEL" -initrd "$INITRD" -append "$APPEND" \
	-vga std -display none \
	-serial "file:$SERIAL" \
	-monitor "unix:$WORK/monitor.sock,server,nowait" \
	-nic user,model=virtio-net-pci &
QEMU_PID=$!
trap 'kill "$QEMU_PID" 2>/dev/null || true; chmod -R u+w "$WORK" 2>/dev/null; rm -rf "$WORK" || true' EXIT

wait_for() { # motif délai_en_secondes
	local t=0 max=$(($2 * FACTOR))
	while [ "$t" -lt "$max" ]; do
		grep -qE "$1" "$SERIAL" && return 0
		kill -0 "$QEMU_PID" 2>/dev/null || { echo "[test] QEMU s'est arrêté"; return 1; }
		sleep 5
		t=$((t + 5))
	done
	echo "[test] Délai dépassé en attendant : $1"
	return 1
}

screenshot() { # nom
	echo "screendump $WORK/$1.ppm" | socat - "UNIX-CONNECT:$WORK/monitor.sock" >/dev/null || true
	sleep 2
	if [ -f "$WORK/$1.ppm" ]; then
		convert "$WORK/$1.ppm" "$RES/$1.png" 2>/dev/null || cp "$WORK/$1.ppm" "$RES/$1.ppm"
		echo "[test] Capture d'écran : $1"
	fi
}

STATUS=0
if wait_for "CHOS-SELFTEST: CHROME-(OK|FAIL)" 900; then
	sleep 10
	screenshot 1-session-chrome
	wait_for "CHOS-SELFTEST: CALAMARES-(OK|FAIL)" 300 && { sleep 5; screenshot 2-installateur; }
	wait_for "CHOS-SELFTEST: DONE" 120 || true
else
	screenshot 0-echec
	STATUS=1
fi

echo "================ Résultats de l'autotest ================"
grep "CHOS-SELFTEST" "$SERIAL" || true
echo "========================================================="

grep -q "CHOS-SELFTEST: CHROME-OK" "$SERIAL" || STATUS=1
grep -q "CHOS-SELFTEST: CALAMARES-OK" "$SERIAL" || STATUS=1
grep -q "CHOS-SELFTEST: INSTALLER-TOOLS-FAIL" "$SERIAL" && STATUS=1

if [ "$STATUS" -eq 0 ]; then
	echo "[test] RÉUSSI"
else
	echo "[test] ÉCHEC (voir $SERIAL)"
	tail -n 200 "$SERIAL"
fi
exit "$STATUS"
