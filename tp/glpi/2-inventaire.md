---
outline: deep
---

# TP 2 — Gestion d'un inventaire avec GLPI

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="GLPI + GLPI Agent + Debian" />

::: info Contexte
La société **TechServices** vient de déployer GLPI. Votre responsable vous demande maintenant de commencer à **alimenter le parc informatique** : d'abord en saisissant manuellement quelques équipements existants, puis en automatisant la collecte d'informations grâce à **GLPI Agent** installé sur les postes du réseau.
:::

::: warning Modalités
Vous avez besoin de deux VMs pour ce TP :
- **VM-Serveur** — votre serveur Debian avec GLPI (TP 1)
- **VM-Cliente** — une VM Debian ou Windows sur laquelle vous installerez GLPI Agent

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

Ouvrez l'ordinateur `PC-Direction-01`, allez dans l'onglet **Connexions** et cliquez sur **Connecter un élément**.

Dans la liste, recherchez `Ecran-Direction-01` et sélectionnez-le. Validez.

::: info Pourquoi lier les équipements ?
Relier les équipements entre eux permet de savoir instantanément, depuis la fiche d'un ordinateur, quels périphériques lui sont associés — et inversement. Cela facilite les interventions et le suivi du matériel.
:::

::: tip 📸 Capture 3
Onglet **Connexions** de `PC-Direction-01` montrant l'écran `Ecran-Direction-01` connecté.
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

Notez l'adresse IP de votre VM-Serveur (ex : `192.168.x.x`). Vous l'utiliserez à la Mission 4.

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

## Mission 5 — Déclencher et vérifier l'inventaire automatique

### Tâche 5.1 — Forcer un inventaire immédiat

Par défaut, GLPI Agent envoie un inventaire toutes les 24 heures. Pour ne pas attendre, forcez un envoi immédiat :

```bash
glpi-agent --force
```

L'agent collecte les informations du poste et les envoie au serveur GLPI. Vous devriez voir des lignes de log confirmant l'envoi.

::: tip 📸 Capture 9
Sortie de `glpi-agent --force` montrant l'inventaire envoyé avec succès.
:::

### Tâche 5.2 — Vérifier la réception dans GLPI

Retournez sur l'interface GLPI (VM-Serveur) et naviguez dans **Parc → Ordinateurs**.

Votre VM-Cliente doit maintenant apparaître dans la liste, avec sa fiche complète générée automatiquement.

::: warning Si la VM-Cliente n'apparaît pas
- Attendez 1 à 2 minutes puis actualisez la page
- Vérifiez la connectivité réseau entre les deux VMs : `ping [IP-SERVEUR]` depuis la VM-Cliente
- Consultez les logs de l'agent : `journalctl -u glpi-agent -n 50`
:::

::: tip 📸 Capture 10
Liste **Parc → Ordinateurs** dans GLPI affichant la VM-Cliente remontée automatiquement.
:::

### Tâche 5.3 — Explorer la fiche générée automatiquement

Cliquez sur la fiche de la VM-Cliente pour l'ouvrir. Comparez son niveau de détail avec la fiche de `PC-Direction-01` créée manuellement.

Explorez les onglets :
- **Composants** — processeur, RAM, disques détectés automatiquement
- **Logiciels** — liste complète des logiciels installés
- **Réseau** — adresses IP et interfaces détectées

::: tip 📸 Capture 11
Onglet **Composants** de la VM-Cliente remontée par GLPI Agent — informations matérielles détectées automatiquement.
:::

::: tip 📸 Capture 12
Onglet **Logiciels** de la VM-Cliente — liste des logiciels installés détectée automatiquement.
:::

---

## Mission 6 — Exploiter les données du parc

Maintenant que le parc contient plusieurs éléments, vous allez apprendre à rechercher, filtrer et exporter des données.

### Tâche 6.1 — Utiliser la recherche avancée

Dans **Parc → Ordinateurs**, cliquez sur **Rechercher** pour accéder aux filtres avancés.

Ajoutez les critères suivants pour trouver uniquement les postes en production situés en salle Direction :

| Critère | Valeur |
|---|---|
| État | En production |
| Localisation | Direction |

Cliquez sur **Rechercher** et observez les résultats filtrés.

::: tip 📸 Capture 13
Résultats de la recherche filtrée — seul `PC-Direction-01` apparaît.
:::

### Tâche 6.2 — Personnaliser les colonnes affichées

Par défaut, la liste des ordinateurs n'affiche que quelques colonnes. Vous pouvez personnaliser cet affichage.

Dans la liste **Parc → Ordinateurs**, cliquez sur l'icône de configuration des colonnes (engrenage ou flèches en haut du tableau) et ajoutez les colonnes :
- **Utilisateur**
- **Numéro de série**
- **Date de dernière mise à jour**

::: tip 📸 Capture 14
Liste des ordinateurs avec les colonnes personnalisées affichées.
:::

### Tâche 6.3 — Exporter les données

La liste des équipements peut être exportée pour être intégrée dans un rapport ou un tableur.

Depuis la liste **Parc → Ordinateurs**, cliquez sur le bouton **Exporter** (icône en bas de la liste) et choisissez le format **CSV**.

Ouvrez le fichier exporté pour vérifier son contenu.

::: tip 📸 Capture 15
Fichier CSV exporté ouvert dans un tableur — colonnes et données visibles.
:::

### Tâche 6.4 — Utiliser la recherche globale

La barre de recherche en haut de GLPI permet de retrouver n'importe quel élément du parc, tous types confondus.

Tapez `Direction` dans la barre de recherche globale. GLPI doit vous retourner tous les assets dont le nom ou la localisation contient ce mot.

::: tip 📸 Capture 16
Résultats de la recherche globale pour "Direction" — plusieurs assets retournés.
:::

---

## Récapitulatif — Rapport annexe à rendre

::: danger À rendre
Votre rapport annexe doit contenir les **16 captures d'écran** listées ci-dessous, dans l'ordre, avec pour chaque capture une légende indiquant ce qu'elle montre.
:::

| N° | Contenu de la capture | Mission |
|---|---|---|
| 1 | Formulaire de création de `PC-Direction-01` rempli | 1 |
| 2 | Onglet Composants de `PC-Direction-01` avec matériel renseigné | 1 |
| 3 | Onglet Connexions de `PC-Direction-01` avec l'écran connecté | 1 |
| 4 | Fiche de `PC-Direction-01` avec utilisateur affecté | 1 |
| 5 | Liste Parc → Réseaux avec le switch créé | 2 |
| 6 | Page Administration → Inventaire configurée | 3 |
| 7 | `glpi-agent --version` — installation confirmée | 4 |
| 8 | `systemctl status glpi-agent` — service actif | 4 |
| 9 | `glpi-agent --force` — inventaire envoyé | 5 |
| 10 | Liste Parc → Ordinateurs avec la VM-Cliente remontée | 5 |
| 11 | Onglet Composants de la VM-Cliente (inventaire automatique) | 5 |
| 12 | Onglet Logiciels de la VM-Cliente | 5 |
| 13 | Résultats de la recherche filtrée | 6 |
| 14 | Liste des ordinateurs avec colonnes personnalisées | 6 |
| 15 | Fichier CSV exporté ouvert dans un tableur | 6 |
| 16 | Résultats de la recherche globale "Direction" | 6 |

::: warning
Vérifiez que chaque capture montre clairement le résultat (fenêtres non coupées, texte lisible).
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Quelle est la différence entre un inventaire **manuel** et un inventaire **automatique** ? Dans quel cas utilise-t-on l'un ou l'autre ?
2. Quelles informations GLPI Agent remonte-t-il automatiquement qu'il aurait été fastidieux de saisir à la main ?
3. Pourquoi est-il important de relier les équipements entre eux (ordinateur ↔ écran) dans GLPI ?
4. Citez un avantage concret de la **recherche avancée** pour un administrateur gérant un parc de 500 postes.
5. Dans quel cas l'export CSV d'un inventaire serait-il utile pour l'entreprise ?

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 16 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::
