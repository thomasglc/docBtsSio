# 📝 TP 3 : Mise en place de pfSense
> 🎯 Objectif : Installer et configurer pfSense dans une machine virtuelle, découvrir son interface et réaliser une configuration minimale. Vous produirez un compte rendu expliquant à quoi peut servir pfSense.

## 1. Qu'est-ce que pfSense ?

pfSense est une distribution open-source basée sur FreeBSD, utilisée comme **pare-feu** (firewall) et **routeur**. Elle s'installe sur une machine physique ou virtuelle et s'administre via une interface web.

:::info 📌 Avant de commencer
Avant de vous lancer dans l'installation, prenez 5 minutes pour répondre aux questions suivantes dans votre compte rendu :
- Qu'est-ce qu'un pare-feu ? À quoi sert-il ?
- Quelle est la différence entre un pare-feu matériel et logiciel ?
- Citez deux alternatives open-source à pfSense.
:::

## 2. Création de la machine virtuelle

Vous allez créer **deux** machines virtuelles :
- **pfSense** : le pare-feu
- **Client Debian** (ou Windows) : une machine derrière le pare-feu pour tester

### Configuration de la VM pfSense

Dans VirtualBox (ou VMware), créez une VM avec les paramètres suivants :

| Paramètre | Valeur recommandée |
|---|---|
| Nom | pfSense |
| Type | BSD |
| Version | FreeBSD (64-bit) |
| RAM | 1024 Mo minimum |
| Disque dur | 10 Go |
| Cartes réseau | **2 cartes** (voir ci-dessous) |

:::warning ⚠️ Les deux cartes réseau sont indispensables
pfSense a besoin d'au moins deux interfaces réseau :
- **Carte 1 (WAN)** : en mode `NAT` ou `Accès par pont` → simule la connexion Internet
- **Carte 2 (LAN)** : en mode `Réseau interne` → réseau local de vos clients

Sans ces deux cartes, pfSense ne peut pas jouer son rôle de routeur/pare-feu.
:::

### Configuration de la VM Client

Créez une seconde VM (Debian ou Windows) avec :
- **1 carte réseau** en mode `Réseau interne` (même nom que le LAN de pfSense)
- RAM : 512 Mo minimum

## 3. Téléchargement de pfSense

Rendez-vous sur le site officiel de pfSense et téléchargez la dernière image ISO stable.

:::tip 💡 Astuce
Choisissez l'image au format **ISO** (DVD Image), architecture **AMD64**.
La taille est d'environ 600 Mo.
:::

## 4. Installation de pfSense

Démarrez la VM pfSense avec l'ISO en lecteur optique et suivez les étapes :

**Étape 1 — Écran de démarrage**
Laissez le menu se charger. Après quelques secondes, l'installeur démarre automatiquement.

**Étape 2 — Accepter la licence**
Appuyez sur `Entrée` pour accepter et continuer.

**Étape 3 — Choisir le mode d'installation**
Sélectionnez **Install** (installation standard).

**Étape 4 — Partitionnement**
Choisissez **Auto (ZFS)** ou **Auto (UFS)** selon votre préférence. Validez avec `OK`.

:::tip 💡
Pour un TP, **Auto (UFS)** est suffisant et plus rapide à mettre en place.
:::

**Étape 5 — Sélection du disque**
Sélectionnez le disque virtuel de la VM (ex. `ada0`). Confirmez l'écriture.

**Étape 6 — Fin de l'installation**
Une fois l'installation terminée, le système vous propose de **redémarrer**. Retirez l'ISO du lecteur avant de redémarrer.

## 5. Premier démarrage et assignation des interfaces

Au premier démarrage, pfSense vous pose deux questions importantes dans la console.

### Assignation des cartes réseau

pfSense détecte les interfaces réseau (ex. `em0`, `em1`) et vous demande de les assigner :

```
Do you want to set up VLANs? → n (non pour l'instant)

Enter the WAN interface name: em0
Enter the LAN interface name: em1
```

:::warning ⚠️ Vérifiez vos interfaces
Les noms `em0`, `em1` peuvent varier (`vtnet0`, `bge0`…). pfSense liste les interfaces disponibles, basez-vous sur les adresses MAC pour identifier la bonne carte.
:::

### Menu principal de la console

Après l'assignation, vous arrivez sur ce menu :

```
*** Welcome to pfSense ***

WAN  → em0 → (adresse DHCP obtenue)
LAN  → em1 → 192.168.1.1

1) Assign Interfaces
2) Set interface(s) IP address
3) Reset webConfigurator password
...
8) Shell
```

:::tip 📌 Question
Notez l'adresse IP du WAN et du LAN dans votre compte rendu.
Quelle est la différence entre ces deux interfaces dans le contexte d'un pare-feu ?
:::

## 6. Accès à l'interface web (WebConfigurator)

Depuis votre **VM Client**, ouvrez un navigateur et accédez à :

```
http://192.168.1.1
```

Identifiants par défaut :

| Champ | Valeur |
|---|---|
| Utilisateur | `admin` |
| Mot de passe | `pfsense` |

:::danger 🔒 Sécurité
Changez le mot de passe par défaut dès votre première connexion. Un pare-feu avec des identifiants par défaut est une faille de sécurité majeure.
:::

## 7. Assistant de configuration initiale

Au premier accès, pfSense lance un **assistant de configuration** (Setup Wizard). Suivez les étapes :

**Étape 1 — Informations générales**
- Hostname : `pfsense` (ou un nom de votre choix)
- Domain : `local.lan`
- DNS primaire : `8.8.8.8`
- DNS secondaire : `8.8.4.4`

**Étape 2 — Serveur de temps (NTP)**
Laissez la valeur par défaut (`0.pfsense.pool.ntp.org`) et choisissez votre fuseau horaire (`Europe/Paris`).

**Étape 3 — Interface WAN**
Laissez en DHCP si votre carte est connectée en NAT — pfSense récupère automatiquement une adresse.

**Étape 4 — Interface LAN**
Conservez `192.168.1.1 / 24` ou modifiez selon vos besoins.

**Étape 5 — Mot de passe admin**
Choisissez un nouveau mot de passe sécurisé.

**Étape 6 — Terminer**
Cliquez sur **Finish**. pfSense applique la configuration et recharge l'interface.

## 8. Découverte de l'interface

Prenez le temps d'explorer les menus principaux avant de continuer.

### Menu System

| Sous-menu | Rôle |
|---|---|
| General Setup | Paramètres généraux (hostname, DNS…) |
| User Manager | Gestion des utilisateurs |
| Updates | Mise à jour de pfSense |
| Packages | Installation de modules supplémentaires |

### Menu Interfaces

Permet de configurer chaque interface réseau (WAN, LAN, et toute interface supplémentaire).

### Menu Firewall

| Sous-menu | Rôle |
|---|---|
| Rules | Règles de filtrage du trafic |
| NAT | Traduction d'adresses réseau |
| Aliases | Regroupement d'IPs/ports pour simplifier les règles |

### Menu Services

Contient les services activables : DHCP, DNS Resolver, NTP, OpenVPN, etc.

### Menu Status

Supervision en temps réel : tableau de bord, logs, interfaces, routage.

:::tip 📌 Questions — Découverte de l'interface
Dans votre compte rendu, répondez aux questions suivantes :
1. Où se trouvent les logs du pare-feu ? Que contiennent-ils ?
2. Quel service distribue automatiquement des adresses IP aux clients du LAN ?
3. À quoi sert la section **NAT** dans le menu Firewall ?
:::

## 9. Configuration minimale

### Vérification du DHCP sur le LAN

Depuis **Services → DHCP Server**, vérifiez que le serveur DHCP est actif sur l'interface LAN.

La plage par défaut est `192.168.1.100` à `192.168.1.199`.

Depuis votre VM Client, vérifiez que vous avez bien reçu une adresse IP dans cette plage :

```bash
ip a        # Linux
ipconfig    # Windows
```

### Test de connectivité

Depuis la VM Client, testez la connectivité :

```bash
# Ping vers la passerelle pfSense
ping 192.168.1.1

# Ping vers Internet (si WAN connecté)
ping 8.8.8.8

# Résolution DNS
ping google.com
```

:::tip 📌 Question
Que se passe-t-il si vous supprimez la règle qui autorise le trafic LAN vers WAN ? Testez et observez.
Pensez à remettre la règle ensuite.
:::

### Changement du mot de passe admin

Depuis **System → User Manager → Users**, cliquez sur l'icône d'édition du compte `admin` et définissez un nouveau mot de passe robuste.

### Activation des mises à jour

Depuis **System → Update**, vérifiez si une mise à jour est disponible et appliquez-la si c'est le cas.

:::warning ⚠️
N'appliquez une mise à jour que si vous avez du temps devant vous — pfSense redémarre après la mise à jour.
:::

## 10. Compte rendu attendu

Votre compte rendu doit répondre aux questions posées tout au long du TP et inclure les sections suivantes :

### Section 1 — Présentation de pfSense
- Qu'est-ce que pfSense et sur quelle base est-il construit ?
- Citez **5 fonctionnalités** que pfSense peut offrir (avec une phrase d'explication pour chacune).
- Dans quel type d'environnement pfSense est-il utilisé ? (PME, école, domicile…)
- Quelle est la différence entre pfSense **Community Edition** et **pfSense Plus** ?

### Section 2 — Architecture mise en place
- Schéma de votre infrastructure (VM pfSense + VM Client)
- Adresses IP de chaque interface (WAN, LAN)
- Captures d'écran : tableau de bord pfSense, règles de pare-feu, serveur DHCP

### Section 3 — Tests et observations
- Résultats des commandes `ping` depuis le client
- Que se passe-t-il quand vous bloquez une règle ?
- Où peut-on voir le trafic bloqué dans l'interface ?

### Section 4 — Conclusion
- Selon vous, pourquoi utiliser pfSense plutôt qu'un pare-feu intégré à un routeur grand public ?
- Dans quel cas une entreprise aurait-elle intérêt à déployer pfSense ?

::: danger Rendu sur Moodle
Déposez votre compte rendu (PDF) accompagné de vos captures d'écran sur Moodle.
:::
