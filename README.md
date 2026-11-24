# CHOS — un système juste pour Google Chrome

CHOS est un système d'exploitation **très léger** qui ne fait qu'une chose : lancer
**Google Chrome** en plein écran. Idéal pour un PC qui rame sous Windows alors qu'on
ne fait que naviguer sur Internet.

- Base : Debian 13 (Linux), stable et gratuite.
- Interface : Google Chrome + une petite barre en bas (Wi-Fi, son, batterie, heure, bouton Éteindre).
- **Tes favoris, extensions, mots de passe et historique** reviennent en te connectant à Chrome avec ton compte Google.
- **Les raccourcis clavier de Chrome sont identiques** (Ctrl+T, Ctrl+W, Ctrl+Maj+T…).
- Clavier français (AZERTY), langue française, heure de Paris.
- Mises à jour automatiques (Chrome + sécurité), sans rien faire.
- Utilisable **sur clé USB** (sans toucher à Windows) ou **installable à côté de Windows**.

> ⚠️ Projet personnel, pas un produit officiel. Fais toujours une sauvegarde de tes fichiers
> avant d'installer quoi que ce soit sur ton disque.

---

## Sommaire

1. [Avant tout : sauvegarder ses favoris](#1-avant-tout--sauvegarder-ses-favoris)
2. [Télécharger CHOS](#2-télécharger-chos)
3. [Essayer sans clé USB (machine virtuelle)](#3-essayer-sans-clé-usb-machine-virtuelle)
4. [Utiliser CHOS sur une clé USB](#4-utiliser-chos-sur-une-clé-usb)
5. [Installer CHOS à côté de Windows](#5-installer-chos-à-côté-de-windows-double-démarrage)
6. [Raccourcis clavier](#6-raccourcis-clavier)
7. [Problèmes fréquents](#7-problèmes-fréquents)
8. [Pour les curieux : comment c'est fabriqué](#8-pour-les-curieux--comment-cest-fabriqué)

---

## 1. Avant tout : sauvegarder ses favoris

Sur **Windows**, dans Chrome :

1. Vérifie que la synchronisation est activée : clique sur ta photo de profil en haut à
   droite → **Activer la synchronisation** (ou vérifie qu'elle est déjà active), puis
   `Paramètres → Vous et Google → Synchronisation et services Google → Gérer ce que vous synchronisez`
   → choisis **Tout synchroniser**.
2. Par sécurité, exporte aussi tes favoris dans un fichier :
   tape `chrome://bookmarks` dans la barre d'adresse → menu **⋮** en haut à droite →
   **Exporter les favoris**. Garde ce fichier (sur Google Drive par exemple).

Dans CHOS, il suffira de te connecter à Chrome avec le **même compte Google** pour tout retrouver.

> ℹ️ Les raccourcis personnalisés des extensions (`chrome://extensions/shortcuts`) ne sont pas
> synchronisés par Google : note-les si tu en as.

---

## 2. Télécharger CHOS

L'image de CHOS (un fichier `.iso` d'environ 1,5 à 2 Go) est fabriquée automatiquement par GitHub.

- **Version publiée** : onglet **Releases** du dépôt (à droite sur la page GitHub) → télécharge
  le fichier `chos-AAAAMMJJ-amd64.iso`.
- **Dernière version en cours** : onglet **Actions** → clique sur la dernière exécution
  réussie (coche verte) de « Construire et tester l'ISO CHOS » → en bas, section
  **Artifacts** → **chos-iso** (il faut être connecté à GitHub). Décompresse le `.zip`
  pour obtenir le `.iso`.

---

## 3. Essayer sans clé USB (machine virtuelle)

Pour voir à quoi ressemble CHOS **sans rien toucher**, tu peux le lancer dans une fenêtre sous Windows.
Ça ne rendra pas ton PC plus rapide (Windows tourne toujours), c'est juste pour tester.

1. Installe **VirtualBox** (gratuit) : <https://www.virtualbox.org> → *Download* → *Windows hosts*.
2. Ouvre VirtualBox → **Nouvelle** :
   - Nom : `CHOS` ; Image ISO : choisis le fichier `chos-…-amd64.iso` ;
   - coche **« Passer l'installation automatique »** (*Skip Unattended Installation*) ;
   - Type : *Linux*, Version : *Debian (64-bit)* ;
   - Mémoire : **4096 Mo** ; processeurs : **2** ; coche **Activer EFI** ;
   - Disque : 20 Go (inutile pour tester, mais nécessaire si tu veux essayer l'installateur).
3. Clique sur **Démarrer**. Dans le menu, choisis la première ligne (*Live system*).
4. Après environ 1 minute, Chrome s'ouvre. 🎉

---

## 4. Utiliser CHOS sur une clé USB

Il te faut une clé USB d'**au moins 8 Go** (16 Go conseillé). **Son contenu sera effacé.**

### Créer la clé (sous Windows)

1. Télécharge **Rufus** : <https://rufus.ie> (version portable, pas besoin d'installer).
2. Branche la clé, lance Rufus :
   - **Périphérique** : ta clé USB ;
   - **Type de démarrage** : clique sur **SÉLECTION** et choisis le fichier `.iso` de CHOS ;
   - **Taille de la partition persistante** : mets le curseur sur **4 Go ou plus**.
     C'est ce qui permet à la clé de **se souvenir** de ta connexion Google, de ton Wi-Fi, etc.
     Sans ça, tout est oublié à chaque redémarrage ;
   - Schéma de partition : **GPT** ; Système de destination : **UEFI**.
3. Clique sur **DÉMARRER**. Si Rufus demande « mode ISO ou mode DD », choisis **ISO**.

### Démarrer sur la clé

1. Éteins le PC, branche la clé.
2. Allume le PC en appuyant plusieurs fois sur la touche du **menu de démarrage** :

   | Marque du portable | Touche à appuyer au démarrage |
   |---|---|
   | Acer | F12 |
   | Asus | Échap (Esc) ou F8 |
   | Dell | F12 |
   | HP | Échap puis F9 |
   | Lenovo | F12 (ou le petit bouton « Novo » à côté de l'alimentation) |
   | MSI | F11 |
   | Toshiba / Dynabook | F12 |
   | Samsung | Échap ou F2 |

3. Choisis la ligne avec le nom de ta clé USB (souvent « UEFI : … »).
4. Dans le menu de CHOS, choisis la première ligne (*Live system*).

Si le PC refuse de démarrer la clé, voir [Problèmes fréquents](#7-problèmes-fréquents).

### Premier démarrage

1. Clique sur l'**icône Wi-Fi** en bas à droite pour te connecter à ta box.
2. Dans Chrome, clique sur **Se connecter** (ou ta photo de profil) et connecte-toi avec ton compte
   Google, puis **Activer la synchronisation**. Tes favoris et extensions arrivent en quelques minutes.

---

## 5. Installer CHOS à côté de Windows (double démarrage)

Après installation, au démarrage du PC, un menu te laissera choisir **CHOS** (affiché
« Debian GNU/Linux ») ou **Windows**. CHOS démarrera bien plus vite depuis le disque que depuis la clé.

> ⚠️ Installer un système sur un disque comporte toujours un risque. **Sauvegarde tes fichiers
> personnels** (photos, documents) sur une clé, un disque externe ou dans le cloud avant de commencer.

### Étape A — Préparer Windows

1. **Clé de récupération BitLocker** : beaucoup de PC sous Windows 11 sont chiffrés.
   Va sur <https://aka.ms/myrecoverykey>, connecte-toi avec ton compte Microsoft et **note la
   clé de récupération** (sur papier). Windows peut la demander après l'installation.
2. **Désactiver le démarrage rapide** : *Panneau de configuration → Options d'alimentation →
   Choisir l'action des boutons d'alimentation → Modifier des paramètres actuellement non disponibles*
   → décoche **Activer le démarrage rapide** → Enregistrer.
3. **Faire de la place** : clic droit sur le bouton Démarrer → **Gestion du disque** →
   clic droit sur le disque `C:` → **Réduire le volume** → entre au moins **40000** Mo
   (40 Go) → **Réduire**. Un « Espace non alloué » apparaît en noir : c'est là qu'ira CHOS.

### Étape B — Installer

1. Démarre sur la clé USB CHOS (voir [section 4](#4-utiliser-chos-sur-une-clé-usb)).
2. Branche le PC sur secteur et connecte-toi au Wi-Fi.
3. Dans la barre du bas, clique sur l'icône **Installer CHOS** (entre Chrome et le bouton Éteindre).
4. Suis l'installateur :
   - **Bienvenue** : Français ;
   - **Localisation** : Europe / Paris ;
   - **Clavier** : French (AZERTY) — teste dans la zone de saisie ;
   - **Partitions** : choisis **Partitionnement manuel**, puis :
     1. clique sur la ligne **Espace libre** (environ 40 Go) → **Créer** → Taille : tout,
        Système de fichiers : **ext4**, Point de montage : **/** → OK ;
     2. clique sur la petite partition **FAT32** de 100 à 500 Mo (la partition « EFI » de Windows)
        → **Modifier** → Point de montage : **/boot/efi** → **ne coche PAS « Formater »** → OK ;
     3. **ne touche à aucune autre partition** (ce sont celles de Windows).
   - **Utilisateurs** : ton prénom, un mot de passe (à retenir !) et coche
     **« Se connecter automatiquement sans demander le mot de passe »** pour arriver directement sur Chrome ;
   - **Résumé** : vérifie que seule la ligne de l'espace libre est formatée, puis **Installer**.
5. À la fin, coche **Redémarrer maintenant**, retire la clé USB quand l'écran s'éteint.

### Au démarrage suivant

Un menu s'affiche pendant 5 secondes :
- **Debian GNU/Linux** = CHOS (choisi par défaut) ;
- **Windows Boot Manager** = Windows.

Si Windows démarre directement sans menu, voir [Problèmes fréquents](#7-problèmes-fréquents).

---

## 6. Raccourcis clavier

**Tous les raccourcis de Chrome fonctionnent exactement comme sous Windows.** Quelques rappels :

| Raccourci | Action |
|---|---|
| Ctrl+T | Nouvel onglet |
| Ctrl+W | Fermer l'onglet |
| Ctrl+Maj+T | Rouvrir l'onglet fermé |
| Ctrl+Tab / Ctrl+Maj+Tab | Onglet suivant / précédent |
| Ctrl+1 … Ctrl+9 | Aller à l'onglet n° 1…9 |
| Ctrl+L | Barre d'adresse |
| Ctrl+N / Ctrl+Maj+N | Nouvelle fenêtre / fenêtre de navigation privée |
| Ctrl+D | Ajouter aux favoris |
| Ctrl+Maj+B | Afficher la barre de favoris |
| Ctrl+H / Ctrl+J | Historique / Téléchargements |
| F11 | Plein écran |
| Ctrl + / Ctrl - / Ctrl 0 | Zoom |

Raccourcis propres à CHOS (choisis pour ressembler à Windows) :

| Raccourci | Action |
|---|---|
| Alt+Tab / Alt+Maj+Tab | Passer d'une fenêtre à l'autre |
| Alt+F4 | Fermer la fenêtre |
| Touche Windows + ↑ / ↓ | Agrandir / réduire la fenêtre |
| Touche Windows + D | Afficher le bureau |
| Touche Windows + E | Nouvelle fenêtre Chrome |
| Ctrl+Alt+Suppr | Menu Éteindre / Redémarrer / Veille |
| Ctrl+Alt+T | Terminal (utilisateurs avancés) |
| Touches volume / luminosité du portable | Fonctionnent normalement |

Autres astuces :
- **Fermer le capot** met le PC en veille.
- Si tu fermes toutes les fenêtres de Chrome, il se **rouvre tout seul**.
- **Clic droit sur le fond d'écran** (s'il est visible) : petit menu (nouvelle fenêtre Chrome, Wi-Fi, Éteindre).

---

## 7. Problèmes fréquents

**Le PC ne démarre pas sur la clé USB / message « Secure Boot violation »**
CHOS est compatible Secure Boot, mais certains PC le refusent quand même. Entre dans le BIOS
(touche F2, Suppr ou Échap au démarrage selon la marque), onglet *Security* ou *Boot* →
**Secure Boot : Disabled**, enregistre (F10). Note : modifier ce réglage peut faire demander
la clé BitLocker à Windows (d'où l'étape A.1).

**Après l'installation, Windows démarre directement sans menu**
Entre dans le BIOS → onglet *Boot* → mets **debian** en premier dans l'ordre de démarrage
(*Boot Priority / UEFI Boot Order*). Une grosse mise à jour de Windows peut parfois remettre
Windows en premier : refais la même manipulation.

**Le Wi-Fi n'apparaît pas**
La plupart des cartes Wi-Fi (Intel, Realtek, Atheros, MediaTek) sont reconnues. Certaines
cartes **Broadcom** ne le sont pas. En attendant, un câble Ethernet ou le partage de connexion
du téléphone en USB fonctionne.

**Sur la clé USB, ma connexion Google est oubliée à chaque démarrage**
La clé a été créée sans « partition persistante ». Recrée-la avec Rufus en mettant le curseur
**Taille de la partition persistante** sur 4 Go ou plus.

**Windows demande une clé de récupération BitLocker**
Entre la clé notée à l'étape A.1 (<https://aka.ms/myrecoverykey> depuis un téléphone).

**L'écran est trop petit / trop grand**
Dans Chrome : `Paramètres → Apparence → Zoom de la page`.

---

## 8. Pour les curieux : comment c'est fabriqué

CHOS est construit avec [live-build](https://live-team.pages.debian.net/live-manual/), l'outil
officiel de Debian pour fabriquer des systèmes « live ».

| Fichier / dossier | Rôle |
|---|---|
| `auto/config` | Réglages de construction (Debian 13, langue, clavier, nom de l'image) |
| `config/package-lists/chos.list.chroot` | Liste des logiciels installés |
| `config/hooks/normal/9000-chos.hook.chroot` | Installe Google Chrome et finalise les réglages |
| `config/includes.chroot/` | Fichiers copiés tels quels dans le système (session, barre, raccourcis…) |
| `config/includes.chroot/etc/chos/openbox/rc.xml` | Raccourcis clavier et souris |
| `config/includes.chroot/etc/chos/tint2rc` | Barre des tâches |
| `config/includes.chroot/usr/lib/chos/` | Démarrage de la session, relance de Chrome, autotest |
| `build.sh` | Fabrique l'ISO |
| `tests/qemu-test.sh` | Démarre l'ISO dans une machine virtuelle et vérifie que tout se lance |
| `.github/workflows/build-iso.yml` | Construction + test automatiques sur GitHub à chaque modification |

### Construire l'ISO soi-même

Sur un PC sous Debian 13 :

```bash
sudo ./build.sh
```

Ou sur n'importe quel Linux avec Docker :

```bash
sudo docker run --rm --privileged -v "$PWD":/work -w /work debian:trixie ./build.sh
```

L'ISO est créée dans le dossier `out/`.

### Publier une version (onglet Releases)

Crée une étiquette (tag) commençant par `v`, par exemple `v1.0` : GitHub construit, teste et
publie automatiquement l'ISO dans **Releases**.
