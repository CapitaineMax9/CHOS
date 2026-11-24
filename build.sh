#!/bin/bash
# Fabrique l'image ISO de CHOS.
#
# À lancer en root sur Debian 13 (trixie), ou dans un conteneur Docker :
#   docker run --rm --privileged -v "$PWD":/work -w /work debian:trixie ./build.sh
#
# Le résultat est placé dans le dossier « out/ ».
set -euo pipefail
cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
	echo "Ce script doit être lancé en root : sudo ./build.sh" >&2
	exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
	echo "[CHOS] Installation de live-build"
	apt-get update
	apt-get install -y live-build
fi

echo "[CHOS] Nettoyage d'une éventuelle construction précédente"
lb clean --purge || true

echo "[CHOS] Configuration"
lb config

echo "[CHOS] Construction (cela peut prendre 20 à 40 minutes)"
lb build 2>&1 | tee build.log

if [ ! -f chos-amd64.hybrid.iso ]; then
	echo "[CHOS] ERREUR : l'image ISO n'a pas été créée. Voir build.log." >&2
	exit 1
fi

mkdir -p out
ISO="out/chos-$(date +%Y%m%d)-amd64.iso"
mv chos-amd64.hybrid.iso "$ISO"
(cd out && sha256sum "$(basename "$ISO")" > "$(basename "$ISO").sha256")
echo "[CHOS] Terminé : $ISO ($(du -h "$ISO" | cut -f1))"
