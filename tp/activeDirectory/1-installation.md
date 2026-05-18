---
outline: deep
---

# TP 1 — Installation et mise en place d'Active Directory

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="Windows Server 2022 + Active Directory" />

::: info Contexte
La société **TechServices** se développe et compte désormais une cinquantaine de collaborateurs. La gestion des comptes utilisateurs et des postes de travail devient difficile à maintenir poste par poste. Votre responsable vous confie la mise en place d'un **serveur Active Directory** pour centraliser l'authentification et faciliter l'administration du parc. Ce premier TP couvre l'installation de Windows Server et la création du domaine — la configuration avancée (utilisateurs, GPO…) fera l'objet du TP suivant.
:::

::: warning Modalités
Vous aurez besoin de créer une VM dans VirtualBox à partir d'un ISO :
- Fichier ISO : **Windows Server 2022** (disponible sur le serveur NAS)
- RAM recommandée : **4 Go minimum** pour la VM
- Espace disque : **60 Go minimum**

Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Qu'est-ce qu'Active Directory ?

**Active Directory** (AD) est un service d'annuaire développé par Microsoft, installé sur un **serveur Windows**. Il permet de :

- **Centraliser les comptes utilisateurs** — un seul compte par collaborateur, valable sur tous les postes de l'entreprise
- **Gérer les ordinateurs du réseau** — intégrer les postes dans le domaine pour les administrer à distance
- **Appliquer des politiques de sécurité** — via les GPO (Group Policy Objects), imposer des règles à tous les postes simultanément
- **Contrôler les accès** — définir qui peut accéder à quoi (dossiers partagés, applications, imprimantes…)

::: info Vocabulaire clé

| Terme | Définition |
|---|---|
| **Domaine** | Ensemble des ressources (utilisateurs, postes, serveurs) gérées par AD. Exemple : `techservices.local` |
| **Contrôleur de domaine (DC)** | Serveur qui héberge Active Directory et gère l'authentification de tous les utilisateurs |
| **Forêt** | Ensemble d'un ou plusieurs domaines AD partageant le même schéma. La plupart des PME n'en ont qu'une |
| **DNS** | Active Directory repose entièrement sur le DNS pour que les postes trouvent le contrôleur de domaine |
| **DSRM** | Mode de récupération d'urgence d'Active Directory, protégé par un mot de passe dédié |

:::

---

## Mission 1 — Créer la machine virtuelle

### Tâche 1.1 — Créer la VM dans VirtualBox

Dans VirtualBox, cliquez sur **Nouvelle** et renseignez :

| Paramètre | Valeur |
|---|---|
| Nom | `SRV-AD-01` |
| Type | `Microsoft Windows` |
| Version | `Windows 2022 (64-bit)` |
| RAM | `4096 Mo` minimum |
| CPU | `2` processeurs |
| Disque dur | `60 Go` (dynamiquement alloué) |
| Clé de produit | `VDYBN-27WPP-V4HQT-9VMD4-VMK7H` |

::: warning RAM minimale
Windows Server 2022 nécessite au minimum 2 Go de RAM pour démarrer, mais 4 Go sont recommandés pour un usage fluide avec Active Directory. En dessous, vous risquez des lenteurs importantes ou des blocages pendant l'installation.
:::

Cliquez sur **Finir** pour créer la VM.

### Tâche 1.2 — Monter l'ISO Windows Server

Avant de démarrer la VM, montez le fichier ISO :

1. Sélectionnez la VM `SRV-AD-01` et cliquez sur **Configuration**
2. Allez dans l'onglet **Stockage**
3. Vérifiez que le **disque dur virtuel** (60 Go) est bien rattaché au contrôleur **SATA**, et non IDE
4. Cliquez sur le **lecteur optique** (icône disque vide), puis sur l'icône de disque à droite de la fenêtre
5. Sélectionnez **Choisir un fichier de disque** et naviguez jusqu'au fichier `Windows_Server_2022.iso` disponible sur le NAS


### Tâche 1.3 — Configurer le réseau de la VM

Toujours dans les paramètres de la VM, allez dans l'onglet **Réseau** :

| Paramètre | Valeur |
|---|---|
| Adaptateur 1 | Activé |
| Mode d'accès réseau | **Réseau interne** |
| Nom du réseau | `adlab` |

::: info Pourquoi le réseau interne ?
En réseau interne, la VM est complètement isolée du réseau du lycée. Seules les autres VMs configurées sur le même réseau interne (`adlab`) peuvent communiquer avec elle. C'est indispensable pour ce TP : plusieurs étudiants qui déploient chacun un contrôleur de domaine sur le réseau du lycée provoqueraient des conflits DNS et des perturbations pour toute la salle.
:::

::: tip 📸 Capture 1
Fenêtre de configuration VirtualBox de la VM `SRV-AD-01` — onglets **Système** (RAM/CPU) et **Réseau** visibles avec les valeurs renseignées.
:::

---

## Mission 2 — Installer Windows Server 2022

### Tâche 2.1 — Démarrer l'installation

Démarrez la VM. L'assistant d'installation Windows se lance automatiquement depuis l'ISO.

1. Sélectionnez **Français (France)** pour la langue, le format horaire et le clavier, puis cliquez sur **Suivant**
2. Cliquez sur **Installer maintenant**

### Tâche 2.2 — Choisir l'édition

Sur l'écran de sélection de l'édition, choisissez :

**Windows Server 2022 Standard (Expérience de bureau)**

::: warning Expérience de bureau obligatoire
Sélectionnez impérativement la version avec **Expérience de bureau**. La version **Server Core** n'a pas d'interface graphique — elle s'administre uniquement en ligne de commande et n'est pas adaptée à ce TP.
:::

::: tip 📸 Capture 2
Écran de sélection de l'édition — **Windows Server 2022 Standard (Expérience de bureau)** sélectionné.
:::

### Tâche 2.3 — Partitionnement et installation

Sur l'écran **Où installer Windows ?**, sélectionnez le disque disponible (le disque de 60 Go créé dans VirtualBox) et cliquez sur **Suivant**. Windows crée automatiquement les partitions nécessaires.

L'installation démarre et dure entre **10 et 20 minutes**. La VM redémarre plusieurs fois automatiquement — c'est normal, ne l'éteignez pas.

::: tip Profitez de cette attente — Mission 7
Pendant ces 10 à 20 minutes d'installation, lancez la création et l'installation de la **VM cliente Windows** qui sera utilisée au TP 2. Rendez-vous directement à la **Mission 7** en fin de ce TP, puis revenez ici une fois l'installation du serveur terminée.
:::

### Tâche 2.4 — Définir le mot de passe administrateur

À la fin de l'installation, Windows vous demande de définir le mot de passe du compte **Administrateur** local :

| Champ | Valeur |
|---|---|
| Mot de passe | `Admin@1234` |
| Confirmer le mot de passe | `Admin@1234` |

::: warning Politique de complexité
Windows Server impose une politique de mot de passe stricte : le mot de passe doit contenir une **majuscule**, une **minuscule**, un **chiffre** et un **caractère spécial**. Un mot de passe simple comme `admin` sera refusé.
:::

Cliquez sur **Terminer**. La session s'ouvre sur le Bureau Windows Server.

::: tip 📸 Capture 3
Bureau Windows Server 2022 après la première connexion — le Gestionnaire de serveur s'ouvre automatiquement en arrière-plan.
:::

---

## Mission 3 — Configuration initiale du serveur

Avant d'installer Active Directory, il faut préparer correctement le serveur : nom de machine cohérent, adresse IP fixe et vérifications de base. Ces étapes sont indispensables — un contrôleur de domaine dont l'IP change ou dont le nom est générique posera des problèmes en production.

### Tâche 3.1 — Renommer le serveur

Par défaut, Windows génère un nom aléatoire (du type `WIN-XXXXXXX`). Il faut lui donner un nom clair et identifiable.

1. Faites un clic droit sur **Démarrer → Système** (ou ouvrez **Paramètres → Système → A propos de**)
2. Cliquez sur **Renommer ce PC**
3. Entrez le nom : `SRV-AD-01`
4. Cliquez sur **Suivant** puis sur **Redémarrer maintenant**

Après le redémarrage, reconnectez-vous avec le compte **Administrateur**.

::: tip 📸 Capture 4
Fenêtre **Informations système** affichant le nom `SRV-AD-01` après le redémarrage.
:::

### Tâche 3.2 — Configurer une adresse IP statique

Un contrôleur de domaine doit **toujours avoir une adresse IP fixe**. Si l'IP change, les postes clients ne pourront plus le trouver pour s'authentifier.

1. Faites un clic droit sur l'icône réseau dans la barre des tâches → **Ouvrir les paramètres réseau et Internet**
2. Cliquez sur **Modifier les options d'adaptateur**
3. Faites un clic droit sur la carte réseau active → **Propriétés**
4. Sélectionnez **Protocole Internet version 4 (TCP/IPv4)** → cliquez sur **Propriétés**

Sélectionnez **Utiliser l'adresse IP suivante** et renseignez (adaptez à votre réseau de salle) :

| Champ | Valeur |
|---|---|
| Adresse IP | `192.168.1.10` |
| Masque de sous-réseau | `255.255.255.0` |
| Passerelle par défaut | *(laisser vide)* |
| Serveur DNS préféré | `127.0.0.1` |

::: info Pourquoi `127.0.0.1` en DNS préféré ?
Le contrôleur de domaine hébergera lui-même le serveur DNS d'Active Directory. On lui indique donc de se consulter lui-même — `127.0.0.1` est l'adresse de loopback, qui signifie "moi-même". Sans ça, le serveur chercherait son propre domaine sur un DNS externe qui ne le connaît pas.
:::

Cliquez sur **OK** pour valider, puis fermez les fenêtres.

::: tip 📸 Capture 5
Propriétés **TCP/IPv4** — adresse IP statique `192.168.1.10` et DNS `127.0.0.1` configurés.
:::

### Tâche 3.3 — Vérifier la configuration réseau

Ouvrez **PowerShell** (clic droit sur Démarrer → **Windows PowerShell**) et vérifiez la configuration :

```powershell
ipconfig /all
```

Contrôlez que l'adresse IP, le masque et l'adresse DNS correspondent bien à ce que vous avez saisi. Repérez également le nom de l'adaptateur réseau affiché — vous en aurez besoin si vous devez diagnostiquer un problème réseau plus tard.

::: tip 📸 Capture 6
Sortie de `ipconfig /all` dans PowerShell — adresse IP statique et DNS visibles.
:::

---

## Mission 4 — Installer le rôle Active Directory Domain Services

Active Directory est un **rôle Windows Server** qui s'installe depuis le Gestionnaire de serveur. Cette étape copie les binaires nécessaires — la création du domaine intervient à l'étape suivante.

### Tâche 4.1 — Ouvrir l'assistant d'ajout de rôles

Le Gestionnaire de serveur s'ouvre normalement au démarrage. Si ce n'est pas le cas : **Démarrer → Gestionnaire de serveur**.

Cliquez sur **Gérer → Ajouter des rôles et fonctionnalités**.

L'assistant s'ouvre. Cliquez sur **Suivant** sur la page d'introduction.

### Tâche 4.2 — Sélectionner le type d'installation

Sélectionnez **Installation basée sur un rôle ou une fonctionnalité** et cliquez sur **Suivant**.

Sur l'écran suivant, sélectionnez le serveur `SRV-AD-01` dans la liste du pool de serveurs et cliquez sur **Suivant**.

### Tâche 4.3 — Choisir le rôle AD DS

Sur l'écran **Rôles de serveurs**, cochez :

☑️ **Services AD DS (Active Directory Domain Services)**

Une fenêtre contextuelle s'ouvre pour signaler les fonctionnalités supplémentaires requises (outils d'administration AD, PowerShell pour AD…). Cliquez sur **Ajouter des fonctionnalités** sans décocher quoi que ce soit.

::: tip 📸 Capture 7
Écran **Rôles de serveurs** de l'assistant — case **Services AD DS** cochée.
:::

Cliquez sur **Suivant** sur les écrans **Fonctionnalités** et **AD DS** sans modifier les options par défaut.

### Tâche 4.4 — Confirmer et installer

Sur l'écran de **Confirmation** :

- Cochez **Redémarrer automatiquement le serveur de destination si nécessaire**
- Cliquez sur **Installer**

L'installation dure 2 à 5 minutes.

::: tip 📸 Capture 8
Barre de progression de l'installation du rôle AD DS.
:::

Une fois terminée, vérifiez que le message **"L'installation a réussi"** apparaît avant de fermer l'assistant.

::: tip 📸 Capture 9
Message **"L'installation a réussi"** dans l'assistant — rôle AD DS installé avec succès.
:::

---

## Mission 5 — Promouvoir le serveur en contrôleur de domaine

Installer le rôle AD DS ne suffit pas. Il faut ensuite **promouvoir** le serveur : c'est cette étape qui crée réellement le domaine Active Directory et configure la base de données d'annuaire.

### Tâche 5.1 — Lancer l'assistant de promotion

Dans le Gestionnaire de serveur, un **bandeau jaune d'avertissement** est apparu en haut de la fenêtre :

> *"Configuration requise pour les services AD DS"*

Cliquez sur ce bandeau, puis sur **Promouvoir ce serveur en contrôleur de domaine**.

::: info Pourquoi deux étapes séparées ?
L'installation du rôle copie uniquement les programmes nécessaires. La promotion est l'opération qui **crée la base de données Active Directory**, configure le DNS, et enregistre le serveur comme autorité d'authentification du domaine. Ces deux étapes sont intentionnellement séparées pour permettre une validation avant l'engagement.
:::

### Tâche 5.2 — Définir le type de déploiement

Sur l'écran **Configuration du déploiement**, sélectionnez :

**Ajouter une nouvelle forêt**

Renseignez le nom de domaine racine :

| Champ | Valeur |
|---|---|
| Nom de domaine racine | `techservices.local` |

::: info Pourquoi `.local` ?
Le suffixe `.local` est la convention standard pour les domaines AD internes non exposés sur Internet. Il évite les conflits avec des noms de domaines publics existants. Dans un environnement de production réel, certaines entreprises utilisent un sous-domaine de leur domaine public (ex : `ad.techservices.fr`).
:::

Cliquez sur **Suivant**.

::: tip 📸 Capture 10
Écran **Configuration du déploiement** — option **Ajouter une nouvelle forêt** sélectionnée, domaine `techservices.local` renseigné.
:::

### Tâche 5.3 — Options du contrôleur de domaine

Sur l'écran **Options du contrôleur de domaine**, laissez les valeurs par défaut :

| Option | Valeur |
|---|---|
| Niveau fonctionnel de la forêt | `Windows Server 2016` |
| Niveau fonctionnel du domaine | `Windows Server 2016` |
| Serveur DNS | ☑️ Coché |
| Catalogue global (CG) | ☑️ Coché |

Définissez le **mot de passe DSRM** :

| Champ | Valeur |
|---|---|
| Mot de passe DSRM | `Admin@1234` |
| Confirmer | `Admin@1234` |

::: warning Qu'est-ce que le mot de passe DSRM ?
Le DSRM (Directory Services Restore Mode) est un mode de démarrage spécial permettant de réparer ou restaurer Active Directory en cas de panne grave. Ce mot de passe est **indépendant** du mot de passe Administrateur — notez-le précieusement, car il ne peut pas être récupéré si perdu.
:::

Cliquez sur **Suivant**.

### Tâche 5.4 — Options DNS et chemins de stockage

Avancez dans l'assistant en laissant toutes les valeurs par défaut :

- **Options DNS** → Cliquez sur **Suivant**. Un avertissement sur la délégation DNS peut apparaître — ignorez-le, c'est normal lors de la création d'une nouvelle forêt.
- **Options supplémentaires** → Le nom NetBIOS `TECHSERVICES` est généré automatiquement → **Suivant**
- **Chemins d'accès** → Laissez les chemins par défaut (base NTDS, logs, SYSVOL) → **Suivant**

### Tâche 5.5 — Vérification et installation

Sur l'écran **Vérifier les options**, lisez attentivement le récapitulatif de votre configuration.

::: tip 📸 Capture 11
Écran **Vérifier les options** — récapitulatif avec le domaine `techservices.local` et les options choisies.
:::

Cliquez sur **Suivant** pour lancer la vérification des prérequis. Des avertissements en jaune peuvent apparaître — ils sont normaux si la vérification verte s'affiche en dessous.

Cliquez sur **Installer**. La promotion dure 5 à 10 minutes, puis le serveur **redémarre automatiquement**.

---

## Mission 6 — Vérifier l'installation d'Active Directory

Après le redémarrage, reconnectez-vous. L'écran de connexion affiche maintenant :

```
TECHSERVICES\Administrateur
```

La présence du préfixe `TECHSERVICES\` confirme que le serveur est bien contrôleur de domaine et que vous vous connectez avec un compte du domaine.

### Tâche 6.1 — Vérifier depuis le Gestionnaire de serveur

Ouvrez le **Gestionnaire de serveur**. Dans le panneau de gauche, vérifiez que les rôles **AD DS** et **DNS** sont présents avec un indicateur vert.

::: tip 📸 Capture 12
Gestionnaire de serveur — rôles **AD DS** et **DNS** affichés dans le panneau gauche avec un statut sain.
:::

### Tâche 6.2 — Explorer la console Active Directory

Naviguez dans **Démarrer → Outils d'administration Windows → Utilisateurs et ordinateurs Active Directory** (ou cherchez `dsa.msc` dans la barre de recherche).

La console s'ouvre et affiche la structure de votre domaine `techservices.local`. Explorez les conteneurs créés automatiquement :

| Conteneur | Contenu |
|---|---|
| `Builtin` | Groupes locaux intégrés de Windows (Administrateurs, Utilisateurs…) |
| `Computers` | Postes clients joints au domaine — vide pour l'instant |
| `Domain Controllers` | Votre serveur `SRV-AD-01` est listé ici |
| `Users` | Comptes et groupes créés par défaut (Administrateur, Invité, Krbtgt…) |

::: tip 📸 Capture 13
Console **Utilisateurs et ordinateurs Active Directory** — arborescence du domaine `techservices.local` dépliée avec les conteneurs visibles.
:::

### Tâche 6.3 — Vérifier la zone DNS Active Directory

Naviguez dans **Démarrer → Outils d'administration Windows → DNS**.

Dans le **Gestionnaire DNS**, développez `SRV-AD-01 → Zones de recherche directes`. Vous devez voir la zone `techservices.local` avec plusieurs enregistrements créés automatiquement par la promotion.

::: info Pourquoi vérifier le DNS ?
Active Directory ne peut pas fonctionner sans DNS. La zone `techservices.local` contient les enregistrements SRV qui permettent aux postes clients de localiser le contrôleur de domaine. Si cette zone est absente ou incorrecte, aucun poste ne pourra rejoindre le domaine.
:::

::: tip 📸 Capture 14
Gestionnaire DNS — zone `techservices.local` dépliée, enregistrements automatiques visibles.
:::

### Tâche 6.4 — Vérifier depuis PowerShell

Ouvrez **PowerShell** et exécutez les commandes suivantes :

```powershell
Get-ADDomain
```

Cette commande affiche les propriétés du domaine Active Directory : nom, niveau fonctionnel, contrôleurs de domaine listés…

```powershell
Get-ADDomainController
```

Cette commande confirme que votre serveur `SRV-AD-01` est bien enregistré comme contrôleur de domaine, avec son adresse IP et son rôle.

::: tip 📸 Capture 15
Sorties de `Get-ADDomain` et `Get-ADDomainController` dans PowerShell — domaine `techservices.local` et serveur `SRV-AD-01` confirmés.
:::

---

## Mission 7 — Préparer la VM cliente Windows (en parallèle)

::: info Pourquoi maintenant ?
L'installation de Windows sur une VM prend entre 15 et 30 minutes. En lançant cette mission pendant l'installation du serveur (Tâche 2.3) ou pendant les redémarrages, vous évitez une longue attente au début du TP 2. La VM sera prête à configurer dès que le domaine sera opérationnel.
:::

### Tâche 7.1 — Créer la VM cliente dans VirtualBox

Créez une nouvelle VM dans VirtualBox avec les paramètres suivants :

| Paramètre | Valeur |
|---|---|
| Nom | `PC-CLIENT-01` |
| Type | `Microsoft Windows` |
| Version | `Windows 10 (64-bit)` ou `Windows 11 (64-bit)` |
| RAM | `2048 Mo` minimum |
| CPU | `2` processeurs |
| Disque dur | `50 Go` (dynamiquement alloué) |

Montez l'ISO Windows 10 ou 11 (disponible sur le NAS) dans le lecteur optique, et configurez l'adaptateur réseau en **Réseau interne** avec le nom `adlab` — comme pour le serveur.

::: danger Windows 11 — Sélectionnez impérativement l'édition **Pro**
Lors de l'installation de Windows 11, un écran vous demande de choisir l'édition. Sélectionnez **Windows 11 Professionnel** (Pro), jamais **Famille** (Home).

L'édition Home ne permet pas de joindre un domaine Active Directory : l'option est tout simplement absente de l'interface. Si vous installez la mauvaise édition, vous devrez tout recommencer depuis le début.
:::

### Tâche 7.2 — Installer Windows

Démarrez la VM et installez Windows normalement. À l'étape **"Comment souhaitez-vous configurer ?"**, choisissez **Configurer pour une utilisation personnelle** (ou **Configurer pour une organisation** selon la version).



::: warning Créer un compte local, pas un compte Microsoft
Lors de l'installation, Windows peut demander de se connecter avec un compte Microsoft. Choisissez **Compte hors connexion** (ou **Options limitées** selon la version) pour créer un simple compte local.
:::

Créez le compte local avec :

| Champ | Valeur par défaut VirtualBox |
|---|---|
| Nom d'utilisateur | `LocalAdmin` (`vboxuser`) |
| Mot de passe | `Admin@1234` (`changeme`) |

::: tip L'installation peut tourner en arrière-plan
Une fois l'installation lancée, vous pouvez réduire la fenêtre VirtualBox et continuer à travailler sur la configuration du serveur. Revenez vérifier l'avancement de temps en temps. La configuration réseau et la jonction au domaine se feront au TP 2.
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Quelle est la différence entre un **groupe de travail** (Workgroup) et un **domaine Active Directory** ? Dans quel contexte utilise-t-on l'un plutôt que l'autre ?
2. Pourquoi est-il indispensable de configurer une **adresse IP statique** sur le contrôleur de domaine *avant* d'installer AD DS ?
3. Quel rôle joue le **DNS** dans Active Directory ? Que se passerait-il si le service DNS s'arrêtait sur le contrôleur de domaine ?
4. Quelle est la différence entre **installer le rôle AD DS** et **promouvoir le serveur** ? Pourquoi ces deux étapes sont-elles distinctes ?
5. Dans quel conteneur de la console Active Directory se trouve votre serveur `SRV-AD-01` ? Expliquez pourquoi il s'y trouve et non dans `Computers`.

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 15 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::
