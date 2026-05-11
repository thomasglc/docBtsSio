---
outline: deep
---

# TP 2 — Gestion d'un inventaire avec GLPI

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="GLPI + GLPI Agent + Debian" />

::: info Contexte
La société **TechServices** vient de déployer GLPI. Votre responsable vous demande maintenant de commencer à **alimenter le parc informatique** : d'abord en saisissant manuellement quelques équipements existants, puis en automatisant la collecte d'informations grâce à **GLPI Agent** installé sur les postes du réseau.
:::

::: warning Modalités
Vous avez besoin de deux VMs et de votre PC hôte pour ce TP :
- **VM-Serveur** — votre serveur Debian avec GLPI (TP 1)
- **VM-Cliente** — une VM Debian ou Windows sur laquelle vous installerez GLPI Agent
- **PC hôte** — votre poste de travail Windows physique, qui sera également inventorié

Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Qu'est-ce que l'inventaire dans GLPI ?

L'inventaire regroupe l'ensemble des **équipements matériels et logiciels** gérés par l'entreprise. Dans GLPI, on distingue deux façons d'alimenter cet inventaire :

- **La saisie manuelle** — un administrateur entre directement les informations d'un équipement dans l'interface. Utile pour les équipements qui ne peuvent pas être inventoriés automatiquement (écrans, imprimantes sans agent…).
- **L'inventaire automatique via GLPI Agent** — un petit programme installé sur chaque poste remonte automatiquement ses informations matérielles et logicielles vers GLPI (processeur, RAM, disques, logiciels installés, adresse IP…). C'est la méthode utilisée en entreprise.

---

## Mission 1 — Créer des éléments de parc manuellement

Avant d'automatiser quoi que ce soit, vous allez saisir manuellement deux équipements : un ordinateur et un écran. Cela vous permettra de vous familiariser avec la structure d'un asset dans GLPI.

### Tâche 1.1 — Créer un ordinateur

Connectez-vous à GLPI avec le compte administrateur, puis naviguez dans **Parc → Ordinateurs**.

Cliquez sur le bouton **+ Ajouter** en haut à gauche.

Renseignez les champs suivants :

| Champ | Valeur à saisir |
|---|---|
| Nom | `PC-Direction-01` |
| Type | Ordinateur |
| Fabricant | `Dell` |
| Modèle | `OptiPlex 7090` |
| Numéro de série | `SN-DELL-001` |
| Numéro d'inventaire | `INV-001` |
| Localisation | `Direction` *(à créer si absent, voir ci-dessous)* |
| État | En production |

::: info Créer une localisation
Si "Direction" n'existe pas dans la liste déroulante, cliquez sur l'icône **+** à côté du champ pour la créer à la volée. Les localisations permettent de savoir physiquement où se trouve chaque équipement.
:::

Une fois les champs remplis, cliquez sur **Ajouter** en bas du formulaire.

::: tip 📸 Capture 1
Formulaire de création de l'ordinateur `PC-Direction-01` — champs remplis avant validation.
:::

### Tâche 1.2 — Ajouter des informations matérielles à l'ordinateur

L'ordinateur vient d'être créé. Ouvrez-le en cliquant sur son nom dans la liste, puis explorez les onglets disponibles :

- **Composants** — permet d'ajouter le processeur, la RAM, les disques durs
- **Logiciels** — liste les logiciels installés sur ce poste
- **Connexions** — permet de relier l'ordinateur à d'autres équipements (écran, imprimante…)
- **Utilisateurs** — permet d'affecter un utilisateur à ce poste

Dans l'onglet **Composants**, cliquez sur **Gérer les composants** et ajoutez les éléments suivants :

| Composant | Valeur |
|---|---|
| Processeur | `Intel Core i5-10500` |
| Mémoire (RAM) | `16 Go` |
| Disque dur | `SSD 512 Go` |

::: warning RAM — créer le composant avant de l'ajouter
Pour la **Mémoire (RAM)**, GLPI ne propose pas de valeur libre : il faut d'abord créer le modèle de barrette dans le catalogue avant de pouvoir l'associer à l'ordinateur.

Naviguez dans **Configuration → Composants → Mémoire → + Ajouter**, renseignez un nom (ex : `16 Go DDR4`) et sauvegardez. Revenez ensuite dans l'onglet **Composants** de `PC-Direction-01` pour sélectionner ce composant dans la liste.
:::

::: tip 📸 Capture 2
Onglet **Composants** de `PC-Direction-01` avec les éléments matériels renseignés.
:::

### Tâche 1.3 — Créer un écran

Naviguez dans **Parc → Moniteurs**, puis cliquez sur **+ Ajouter**.

| Champ | Valeur à saisir |
|---|---|
| Nom | `Ecran-Direction-01` |
| Fabricant | `LG` |
| Modèle | `27UK850` |
| Numéro de série | `SN-LG-001` |
| Numéro d'inventaire | `INV-002` |
| Localisation | `Direction` |
| État | En production |

Cliquez sur **Ajouter**.

### Tâche 1.4 — Relier l'écran à l'ordinateur

Dans GLPI, le lien se crée **depuis la fiche de l'écran** vers l'ordinateur (et non l'inverse).

Naviguez dans **Parc → Moniteurs** et ouvrez `Ecran-Direction-01`. Allez dans l'onglet **Connexions** et cliquez sur **Connecter un élément**.

Dans la liste, recherchez `PC-Direction-01` et sélectionnez-le. Validez.

::: warning
Si vous essayez de faire la connexion depuis la fiche de l'ordinateur, le lien ne fonctionnera pas. Partez toujours de la fiche du moniteur.
:::

::: info Pourquoi lier les équipements ?
Relier les équipements entre eux permet de savoir instantanément, depuis la fiche d'un ordinateur, quels périphériques lui sont associés — et inversement. Cela facilite les interventions et le suivi du matériel.
:::

::: tip 📸 Capture 3
Onglet **Connexions** de `Ecran-Direction-01` montrant le lien vers `PC-Direction-01`.
:::

### Tâche 1.5 — Affecter un utilisateur au poste

Toujours dans la fiche de `PC-Direction-01`, allez dans l'onglet **Utilisateurs** (ou directement dans le champ **Utilisateur** de l'onglet principal).

Assignez l'utilisateur `normal` (ou tout autre utilisateur GLPI existant) à ce poste.

::: tip 📸 Capture 4
Fiche de `PC-Direction-01` montrant l'utilisateur affecté.
:::

---

## Mission 2 — Créer d'autres types d'assets

GLPI ne se limite pas aux ordinateurs. Vous allez créer rapidement deux autres types d'équipements pour vous familiariser avec la diversité du parc.

### Tâche 2.1 — Créer une imprimante

Naviguez dans **Parc → Imprimantes → + Ajouter** et renseignez :

| Champ | Valeur |
|---|---|
| Nom | `Imprimante-RDC-01` |
| Fabricant | `HP` |
| Modèle | `LaserJet Pro M404n` |
| Localisation | `Rez-de-chaussée` |
| État | En production |

### Tâche 2.2 — Créer un équipement réseau

Naviguez dans **Parc → Réseaux → + Ajouter** et renseignez :

| Champ | Valeur |
|---|---|
| Nom | `SW-Principal-01` |
| Type | Switch |
| Fabricant | `Cisco` |
| Modèle | `Catalyst 2960` |
| Localisation | `Salle serveur` |

::: tip 📸 Capture 5
Liste **Parc → Réseaux** affichant le switch créé.
:::

---

## Mission 3 — Préparer GLPI pour recevoir les inventaires automatiques

Avant d'installer GLPI Agent sur les postes, il faut vérifier que GLPI est bien configuré pour **recevoir et traiter les inventaires** envoyés automatiquement.

### Tâche 3.1 — Vérifier la configuration de l'inventaire

Dans GLPI, naviguez dans **Administration → Inventaire**.

Vérifiez que les options suivantes sont activées :

| Option | État attendu |
|---|---|
| Activer l'inventaire | ✅ Oui |
| Créer les équipements inconnus | ✅ Oui |
| Mettre à jour les équipements existants | ✅ Oui |

Si ce n'est pas le cas, activez ces options et cliquez sur **Sauvegarder**.

::: info Pourquoi ces options ?
- **Créer les équipements inconnus** : quand un poste envoie son inventaire pour la première fois, GLPI doit créer automatiquement sa fiche dans le parc.
- **Mettre à jour les équipements existants** : à chaque nouvel inventaire, GLPI met à jour les informations du poste (nouvelle RAM installée, logiciel ajouté…).
:::

::: tip 📸 Capture 6
Page **Administration → Inventaire** avec les options correctement configurées.
:::

### Tâche 3.2 — Noter l'adresse IP du serveur GLPI

Vous aurez besoin de l'adresse IP du serveur lors de la configuration de GLPI Agent. Relevez-la :

```bash
ip a
```

Notez l'adresse IP de votre VM-Serveur (ex : `192.168.x.x`). Vous l'utiliserez aux Missions 4 et 5.

---

## Mission 4 — Installer GLPI Agent sur la VM Cliente

GLPI Agent est un programme qui s'installe sur chaque poste du parc. Il collecte automatiquement les informations matérielles et logicielles, puis les envoie au serveur GLPI.

::: info Que collecte GLPI Agent ?
- Informations matérielles : processeur, RAM, disques, carte réseau, BIOS…
- Système d'exploitation : version, langue, mises à jour…
- Logiciels installés et leurs versions
- Adresses IP et interfaces réseau
:::

### Tâche 4.1 — Télécharger GLPI Agent

Sur la **VM-Cliente**, ouvrez un terminal et téléchargez la dernière version de GLPI Agent depuis le dépôt officiel GitHub.

Rendez-vous sur `https://github.com/glpi-project/glpi-agent/releases/latest`, repérez le fichier `.deb` correspondant à votre architecture (généralement `glpi-agent_X.X_all.deb`) et copiez son lien.

Téléchargez-le :

```bash
wget [lien-copié] -O /tmp/glpi-agent.deb
```

### Tâche 4.2 — Installer le paquet

```bash
apt install /tmp/glpi-agent.deb -y
```

::: info
L'option `apt install` sur un fichier `.deb` local installe le paquet et résout automatiquement les dépendances manquantes, contrairement à `dpkg -i` qui échouerait si des dépendances sont absentes.
:::

Vérifiez que l'installation s'est bien passée :

```bash
glpi-agent --version
```

::: tip 📸 Capture 7
Sortie de `glpi-agent --version` confirmant l'installation.
:::

### Tâche 4.3 — Configurer GLPI Agent

Il faut indiquer à l'agent l'adresse du serveur GLPI vers lequel envoyer les inventaires. La configuration se fait dans un fichier dédié :

```bash
nano /etc/glpi-agent/conf.d/00-local.cfg
```

Ajoutez la ligne suivante en remplaçant `[IP-SERVEUR]` par l'adresse IP relevée à la Tâche 3.2 :

```
server = http://[IP-SERVEUR]/
```

::: warning
Respectez bien le `/` final dans l'URL. Sans lui, l'agent ne trouvera pas le point de réception de GLPI.
:::

Sauvegardez le fichier.

### Tâche 4.4 — Démarrer et activer le service

```bash
systemctl enable glpi-agent
systemctl start glpi-agent
```

Vérifiez que le service est actif :

```bash
systemctl status glpi-agent
```

::: tip 📸 Capture 8
Sortie de `systemctl status glpi-agent` — état `active (running)`.
:::

---

## Mission 5 — Installer GLPI Agent sur le PC Hôte Windows

Votre VM-Serveur GLPI est également joignable depuis votre PC physique Windows. Vous allez y installer GLPI Agent pour que **votre poste de travail réel** apparaisse lui aussi dans l'inventaire, aux côtés de la VM-Cliente.

::: warning Prérequis réseau
Votre PC hôte doit pouvoir joindre la VM-Serveur. Pour cela, la carte réseau de la VM-Serveur doit être configurée en **mode pont (Bridged)** dans VirtualBox.

Vérifiez la connectivité avant de continuer. Ouvrez un **terminal** et tapez :

```bash
ping [IP-SERVEUR]
```

Si la commande échoue (Request timed out), vérifiez le mode réseau de la VM dans ses paramètres avant de continuer.
:::

### Tâche 5.1 — Télécharger l'installeur Windows

Depuis votre **PC hôte**, ouvrez un navigateur et rendez-vous sur :

`https://github.com/glpi-project/glpi-agent/releases/latest`

Dans la liste des assets de la dernière version, repérez le fichier `.msi` correspondant à votre architecture :
- **64 bits**  : `GLPI-Agent-X.X-x64.msi`

Téléchargez-le sur votre bureau ou dans votre dossier Téléchargements.

::: tip 📸 Capture 9
Page des releases GitHub — fichier `.msi` identifié et téléchargement en cours.
:::

### Tâche 5.2 — Installer GLPI Agent

Faites un **clic droit** sur le fichier `.msi` téléchargé et choisissez **Exécuter en tant qu'administrateur**.

::: warning
L'installation nécessite obligatoirement les droits administrateur. Un double-clic simple peut échouer sans message d'erreur clair.
:::

Suivez l'assistant d'installation :

1. Cliquez sur **Next** pour passer l'écran d'accueil
2. Acceptez le contrat de licence (**I accept**) puis cliquez sur **Next**
3. Laissez le répertoire d'installation par défaut (`C:\Program Files\GLPI-Agent\`) et cliquez sur **Next**
4. Sur l'écran **GLPI Agent Configuration**, renseignez les champs suivants :

| Champ | Valeur |
|---|---|
| Server | `http://[IP-SERVEUR]/` |
| Local | *(laisser vide)* |
| Quicktime | *(laisser vide)* |

5. Cliquez sur **Next** puis sur **Install**
6. Une fois l'installation terminée, cliquez sur **Finish**

::: warning
Respectez bien le `/` final dans l'URL du serveur. Sans lui, l'agent ne trouvera pas le point de réception de GLPI.
:::

::: tip 📸 Capture 10
Écran de configuration de l'installeur GLPI Agent — champ **Server** renseigné avec l'URL du serveur GLPI.
:::

### Tâche 5.3 — Vérifier la configuration via l'interface locale

GLPI Agent embarque une **interface web locale** accessible directement depuis votre navigateur. Elle vous permet de vérifier la configuration et de déclencher un inventaire à la demande, sans passer par la ligne de commande.

Ouvrez votre navigateur et accédez à :

```
http://localhost:62354/
```

Vérifiez que :
- Le champ **Server** affiche bien l'URL de votre serveur GLPI
- Le statut de l'agent est **Running**

::: info Que faire si la page ne s'affiche pas ?
L'agent démarre en tant que service Windows. Si la page est inaccessible :
1. Appuyez sur `Windows + R`, tapez `services.msc` et validez
2. Recherchez le service **GLPI Agent** dans la liste
3. S'il est arrêté, faites un clic droit → **Démarrer**
4. Rafraîchissez la page dans votre navigateur
:::

::: tip 📸 Capture 11
Interface web locale de GLPI Agent (`http://localhost:62354/`) — configuration du serveur visible et statut Running.
:::

### Tâche 5.4 — Forcer un inventaire immédiat

Par défaut, GLPI Agent envoie un inventaire toutes les 24 heures. Pour ne pas attendre, vous allez déclencher un envoi immédiat.

**Via l'interface web locale**

Depuis `http://localhost:62354/`, cliquez sur le bouton **Force an inventory**. La page affiche alors une confirmation indiquant que l'inventaire a été soumis.


Attendez quelques secondes que l'agent collecte et envoie les données.

::: tip 📸 Capture 12
Résultat de l'inventaire forcé — confirmation dans l'interface web (`Inventory started`) ou sortie de PowerShell.
:::

### Tâche 5.5 — Vérifier l'apparition du PC dans GLPI

Retournez dans l'interface GLPI (depuis la VM-Serveur ou votre navigateur) et naviguez dans **Parc → Ordinateurs**.

Votre PC hôte Windows doit maintenant apparaître dans la liste.

::: warning Si le PC n'apparaît pas
- Patientez 1 à 2 minutes et actualisez la page GLPI
- Vérifiez la connectivité réseau : `ping [IP-SERVEUR]` depuis PowerShell
- Consultez les logs de l'agent dans `C:\Program Files\GLPI-Agent\var\glpi-agent.log`
- Vérifiez que le service est démarré dans `services.msc` → **GLPI Agent**
:::

::: tip 📸 Capture 13
Liste **Parc → Ordinateurs** dans GLPI affichant votre PC hôte Windows remonté automatiquement.
:::

---

## Mission 6 — Déclencher et vérifier les inventaires automatiques

### Tâche 6.1 — Forcer un inventaire immédiat sur la VM-Cliente

Sur la **VM-Cliente**, forcez un envoi immédiat :

```bash
glpi-agent --force
```

L'agent collecte les informations du poste et les envoie au serveur GLPI. Vous devriez voir des lignes de log confirmant l'envoi.

::: tip 📸 Capture 14
Sortie de `glpi-agent --force` sur la VM-Cliente montrant l'inventaire envoyé avec succès.
:::

### Tâche 6.2 — Vérifier la réception dans GLPI

Retournez sur l'interface GLPI (VM-Serveur) et naviguez dans **Parc → Ordinateurs**.

Votre **VM-Cliente** et votre **PC hôte Windows** doivent maintenant apparaître tous les deux dans la liste, avec leurs fiches complètes générées automatiquement.

::: warning Si un poste n'apparaît pas
- Attendez 1 à 2 minutes puis actualisez la page
- Vérifiez la connectivité réseau entre le poste concerné et la VM-Serveur
- **VM-Cliente** : `ping [IP-SERVEUR]` depuis le terminal Linux, logs : `journalctl -u glpi-agent -n 50`
- **PC hôte** : `ping [IP-SERVEUR]` depuis PowerShell, logs : `C:\Program Files\GLPI-Agent\var\glpi-agent.log`
:::

::: tip 📸 Capture 15
Liste **Parc → Ordinateurs** dans GLPI affichant la VM-Cliente **et** le PC hôte Windows remontés automatiquement.
:::

### Tâche 6.3 — Explorer la fiche générée automatiquement

Cliquez sur la fiche de la VM-Cliente pour l'ouvrir. Comparez son niveau de détail avec la fiche de `PC-Direction-01` créée manuellement.

Explorez les onglets :
- **Composants** — processeur, RAM, disques détectés automatiquement
- **Logiciels** — liste complète des logiciels installés
- **Réseau** — adresses IP et interfaces détectées

::: tip 📸 Capture 16
Onglet **Composants** de la VM-Cliente remontée par GLPI Agent — informations matérielles détectées automatiquement.
:::

::: tip 📸 Capture 17
Onglet **Logiciels** de la VM-Cliente — liste des logiciels installés détectée automatiquement.
:::

---

## Mission 7 — Exploiter les données du parc

Maintenant que le parc contient plusieurs éléments, vous allez apprendre à rechercher, filtrer et exporter des données.

### Tâche 7.1 — Utiliser la recherche avancée

Dans **Parc → Ordinateurs**, cliquez sur **Rechercher** pour accéder aux filtres avancés.

Ajoutez les critères suivants pour trouver uniquement les postes en production situés en salle Direction :

| Critère | Valeur |
|---|---|
| État | En production |
| Localisation | Direction |

Cliquez sur **Rechercher** et observez les résultats filtrés.

::: tip 📸 Capture 18
Résultats de la recherche filtrée — seul `PC-Direction-01` apparaît.
:::

### Tâche 7.2 — Personnaliser les colonnes affichées

Par défaut, la liste des ordinateurs n'affiche que quelques colonnes. Vous pouvez personnaliser cet affichage.

Dans la liste **Parc → Ordinateurs**, cliquez sur l'icône de configuration des colonnes (engrenage ou flèches en haut du tableau) et ajoutez les colonnes :
- **Utilisateur**
- **Numéro de série**
- **Date de dernière mise à jour**

::: tip 📸 Capture 19
Liste des ordinateurs avec les colonnes personnalisées affichées.
:::

### Tâche 7.3 — Exporter les données

La liste des équipements peut être exportée pour être intégrée dans un rapport ou un tableur.

Depuis la liste **Parc → Ordinateurs**, cliquez sur le bouton **Exporter** (icône en bas de la liste) et choisissez le format **CSV**.

Ouvrez le fichier exporté pour vérifier son contenu.

::: tip 📸 Capture 20
Fichier CSV exporté ouvert dans un tableur — colonnes et données visibles.
:::

### Tâche 7.4 — Utiliser la recherche globale

La barre de recherche en haut de GLPI permet de retrouver n'importe quel élément du parc, tous types confondus.

Tapez `Direction` dans la barre de recherche globale. GLPI doit vous retourner tous les assets dont le nom ou la localisation contient ce mot.

::: tip 📸 Capture 21
Résultats de la recherche globale pour "Direction" — plusieurs assets retournés.
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Quelle est la différence entre un inventaire **manuel** et un inventaire **automatique** ? Dans quel cas utilise-t-on l'un ou l'autre ?
2. Quelles informations GLPI Agent remonte-t-il automatiquement qu'il aurait été fastidieux de saisir à la main ?
3. Pourquoi est-il important de relier les équipements entre eux (ordinateur ↔ écran) dans GLPI ?
4. Citez un avantage concret de la **recherche avancée** pour un administrateur gérant un parc de 500 postes.
5. Dans quel cas l'export CSV d'un inventaire serait-il utile pour l'entreprise ?
6. Quelle différence avez-vous observé entre l'installation de GLPI Agent sur Linux (VM-Cliente) et sur Windows (PC hôte) ? Laquelle vous semble la plus simple à déployer en entreprise ?

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 21 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::

---

## Annexe — Réinitialiser le mot de passe du compte GLPI

Si vous avez perdu l'accès au compte `glpi`, vous pouvez réinitialiser son mot de passe directement en base de données depuis la VM-Serveur :

```bash
mysql -u root -p
```
Branchez vous sur la base de données nommé GLPI
Puis exécutez la requête suivante (le hash correspond au mot de passe `glpi`) :

```sql
update glpi_users set password='$2y$10$p..X4No3kbL9zq3s9yyXuuNdbHN78Bd/j8aiInj5L7Fo1Hg3hJMFa' where name = 'glpi';
```

Quittez ensuite MySQL avec `exit` et reconnectez-vous à GLPI avec le mot de passe `glpi`.
