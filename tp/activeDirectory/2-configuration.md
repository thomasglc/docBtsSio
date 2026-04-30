---
outline: deep
---

# TP 2 — Configuration de base : utilisateurs, groupes et jonction au domaine

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="Windows Server 2022 + Active Directory" />

::: info Contexte
Le domaine `techservices.local` est opérationnel depuis le TP 1. Votre responsable vous demande maintenant de **structurer l'annuaire** en le calquant sur l'organigramme de l'entreprise, de **créer les premiers comptes utilisateurs**, puis de **joindre un poste Windows au domaine** pour valider que tout fonctionne de bout en bout.
:::

::: warning Modalités
Vous avez besoin de deux VMs pour ce TP :
- **VM-Serveur** (`SRV-AD-01`) — votre contrôleur de domaine du TP 1, démarré et connecté
- **VM-Cliente** — une VM Windows 10 ou 11 que vous préparerez durant ce TP (ISO disponible sur le NAS)

Les deux VMs doivent être sur le **même réseau** (même configuration réseau que dans le TP 1).

Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Rappel de l'architecture mise en place

Avant de commencer, voici un rappel de ce qui a été configuré au TP 1 :

| Élément | Valeur |
|---|---|
| Nom du serveur | `SRV-AD-01` |
| Nom du domaine | `techservices.local` |
| Adresse IP du serveur | `192.168.1.10` |
| Compte administrateur | `TECHSERVICES\Administrateur` |

---

## Qu'est-ce qu'une OU, un utilisateur, un groupe ?

Avant de commencer à créer des objets dans Active Directory, il est important de comprendre les trois briques fondamentales de l'annuaire.

::: info Les trois objets de base d'Active Directory

**Les Unités d'Organisation (OU)**
Une OU est un **conteneur** qui permet d'organiser les objets AD (utilisateurs, ordinateurs, groupes) en reproduisant la structure de l'entreprise. On peut créer des sous-OUs pour affiner l'organisation. Les GPO (TP suivant) s'appliquent au niveau des OUs.

**Les utilisateurs**
Un compte utilisateur AD représente **une personne de l'entreprise**. Il lui permet de s'authentifier sur n'importe quel poste joint au domaine avec un seul identifiant et mot de passe.

**Les groupes de sécurité**
Un groupe rassemble plusieurs utilisateurs pour leur attribuer des **droits communs** (accès à un dossier partagé, à une imprimante…). On gère les droits au niveau du groupe, pas de chaque utilisateur — ce qui simplifie considérablement l'administration.

:::

---

## Mission 1 — Créer la structure organisationnelle (OUs)

L'organigramme de TechServices comporte quatre services. Vous allez reproduire cette structure dans Active Directory sous forme d'Unités d'Organisation.

### Tâche 1.1 — Ouvrir la console Active Directory

Sur `SRV-AD-01`, ouvrez la console **Utilisateurs et ordinateurs Active Directory** :

**Démarrer → Outils d'administration Windows → Utilisateurs et ordinateurs Active Directory**

Ou tapez `dsa.msc` dans la barre de recherche Windows.

Dans l'arborescence de gauche, développez `techservices.local`. Vous voyez les conteneurs créés par défaut lors du TP 1 (`Builtin`, `Computers`, `Domain Controllers`, `Users`).

::: tip 📸 Capture 1
Console ADUC — arborescence de `techservices.local` dépliée, conteneurs par défaut visibles.
:::

### Tâche 1.2 — Créer les OUs de premier niveau

Vous allez d'abord créer une OU racine `TechServices` pour regrouper toute la structure de l'entreprise et la séparer des conteneurs système.

Faites un **clic droit sur `techservices.local`** → **Nouveau → Unité d'organisation**.

| Champ | Valeur |
|---|---|
| Nom | `TechServices` |
| Protéger le conteneur contre toute suppression accidentelle | ☑️ Coché |

Cliquez sur **OK**.

::: info Pourquoi cocher la protection contre la suppression ?
Cette option empêche la suppression accidentelle de l'OU (et de tous ses objets) depuis la console. Pour la supprimer intentionnellement, il faudra d'abord décocher cette protection dans les propriétés avancées. C'est une bonne pratique systématique.
:::

Maintenant, faites un **clic droit sur la nouvelle OU `TechServices`** → **Nouveau → Unité d'organisation** et créez les quatre OUs suivantes, une par une :

| OU à créer | Représente |
|---|---|
| `Direction` | La direction générale |
| `Comptabilite` | Le service comptabilité |
| `Informatique` | Le service informatique |
| `Commercial` | L'équipe commerciale |

::: warning Évitez les accents dans les noms d'OUs
Par convention, les noms d'OUs n'utilisent pas d'accents ni d'espaces. Cela évite des problèmes de compatibilité avec certains scripts PowerShell et outils tiers.
:::

Créez également une OU `Postes` dans `TechServices` — elle accueillera les ordinateurs joints au domaine.

::: tip 📸 Capture 2
Console ADUC — OU `TechServices` dépliée avec les cinq sous-OUs (`Direction`, `Comptabilite`, `Informatique`, `Commercial`, `Postes`) visibles.
:::

---

## Mission 2 — Créer les comptes utilisateurs

Votre responsable vous a fourni la liste des premiers comptes à créer. Vous allez les placer directement dans leur OU respective.

### Tâche 2.1 — Créer le premier utilisateur

Commencez par créer le compte de Marie Dupont, directrice.

Dans la console ADUC, faites un **clic droit sur l'OU `Direction`** (dans `TechServices`) → **Nouveau → Utilisateur**.

Renseignez les champs de la première fenêtre :

| Champ | Valeur |
|---|---|
| Prénom | `Marie` |
| Nom | `Dupont` |
| Nom d'ouverture de session | `m.dupont` |

::: info Convention de nommage
La convention `prenom.nom` (initiale du prénom + point + nom) est la plus courante en entreprise. Elle produit des identifiants cohérents, faciles à mémoriser et qui évitent les doublons.
:::

Cliquez sur **Suivant**.

Sur l'écran de mot de passe, renseignez :

| Champ | Valeur |
|---|---|
| Mot de passe | `Techservices@2024` |
| Confirmer le mot de passe | `Techservices@2024` |
| L'utilisateur doit changer le mot de passe à la prochaine ouverture de session | ☐ Décoché (pour ce TP) |
| Le mot de passe n'expire jamais | ☑️ Coché (pour ce TP) |

Cliquez sur **Suivant** puis **Terminer**.

::: tip 📸 Capture 3
Formulaire de création de l'utilisateur `Marie Dupont` — champs renseignés avant validation.
:::

### Tâche 2.2 — Créer les utilisateurs restants

En suivant la même procédure, créez les trois autres comptes dans leurs OUs respectives :

| Prénom | Nom | Identifiant | OU |
|---|---|---|---|
| Jean | Martin | `j.martin` | `Comptabilite` |
| Lucas | Bernard | `l.bernard` | `Informatique` |
| Sophie | Leroy | `s.leroy` | `Commercial` |

Utilisez le même mot de passe `Techservices@2024` pour tous.

::: tip 📸 Capture 4
Console ADUC — les quatre OUs dépliées affichant chacune leur utilisateur respectif.
:::

### Tâche 2.3 — Vérifier les propriétés d'un compte

Double-cliquez sur le compte de `Marie Dupont` pour ouvrir ses propriétés. Explorez les onglets disponibles :

| Onglet | Contenu |
|---|---|
| **Général** | Informations de contact (téléphone, email, bureau…) |
| **Compte** | Identifiant, options de mot de passe, date d'expiration |
| **Membre de** | Groupes auxquels appartient l'utilisateur |
| **Profil** | Chemin du profil, script de connexion, dossier personnel |

Renseignez dans l'onglet **Général** :
- **Description** : `Directrice générale`
- **Bureau** : `Bureau 101`

Cliquez sur **OK** pour sauvegarder.

::: tip 📸 Capture 5
Propriétés du compte `Marie Dupont` — onglet **Général** avec les informations renseignées.
:::

---

## Mission 3 — Créer les groupes de sécurité

Les groupes permettent d'attribuer des droits à plusieurs utilisateurs en une seule opération. Plutôt que de gérer les autorisations utilisateur par utilisateur, on gère les droits au niveau du groupe.

### Tâche 3.1 — Créer les groupes

Dans la console ADUC, faites un **clic droit sur l'OU `Informatique`** → **Nouveau → Groupe**.

::: info Où stocker les groupes ?
Il est courant de stocker les groupes dans l'OU du service qui les gère, ou dans une OU dédiée `Groupes`. Pour ce TP, on les place dans l'OU `Informatique` puisque c'est le service qui administre l'AD.
:::

Créez les quatre groupes suivants (répétez l'opération pour chacun) :

| Nom du groupe | Étendue | Type |
|---|---|---|
| `GRP-Direction` | Global | Sécurité |
| `GRP-Comptabilite` | Global | Sécurité |
| `GRP-Informatique` | Global | Sécurité |
| `GRP-Commercial` | Global | Sécurité |

::: info Étendue "Globale" vs autres étendues
- **Global** : peut contenir des utilisateurs du même domaine. C'est l'étendue standard pour les groupes métier dans une PME.
- **Domaine local** : utilisé pour attribuer des droits sur des ressources (dossiers partagés, imprimantes). On y ajoute des groupes Globaux.
- **Universel** : utilisé dans les environnements multi-domaines. Inutile pour une PME avec un seul domaine.
:::

::: tip 📸 Capture 6
Console ADUC — OU `Informatique` affichant les quatre groupes créés.
:::

### Tâche 3.2 — Ajouter les utilisateurs dans leurs groupes

Vous allez maintenant associer chaque utilisateur à son groupe.

Double-cliquez sur le groupe `GRP-Direction` pour ouvrir ses propriétés. Allez dans l'onglet **Membres** et cliquez sur **Ajouter**.

Dans la boîte de dialogue, tapez `m.dupont` et cliquez sur **Vérifier les noms**. AD retrouve et complète le nom `Marie Dupont`. Cliquez sur **OK**.

Répétez l'opération pour les trois autres groupes :

| Groupe | Utilisateur à ajouter |
|---|---|
| `GRP-Comptabilite` | `j.martin` (Jean Martin) |
| `GRP-Informatique` | `l.bernard` (Lucas Bernard) |
| `GRP-Commercial` | `s.leroy` (Sophie Leroy) |

::: tip 📸 Capture 7
Propriétés du groupe `GRP-Direction` — onglet **Membres** affichant `Marie Dupont`.
:::

### Tâche 3.3 — Vérifier l'appartenance depuis le compte utilisateur

Ouvrez les propriétés de `Jean Martin`, allez dans l'onglet **Membre de**.

Vous devez voir `GRP-Comptabilite` dans la liste, ce qui confirme que l'appartenance au groupe est bidirectionnelle : on peut la voir depuis le groupe ou depuis l'utilisateur.

::: tip 📸 Capture 8
Propriétés de `Jean Martin` — onglet **Membre de** affichant `GRP-Comptabilite`.
:::

---

## Mission 4 — Préparer la VM cliente Windows

Avant de joindre un poste au domaine, il faut préparer une VM Windows 10 ou 11 correctement configurée pour communiquer avec le contrôleur de domaine.

### Tâche 4.1 — Créer la VM cliente dans VirtualBox

Créez une nouvelle VM dans VirtualBox avec les paramètres suivants :

| Paramètre | Valeur |
|---|---|
| Nom | `PC-CLIENT-01` |
| Type | `Microsoft Windows` |
| Version | `Windows 10 (64-bit)` ou `Windows 11 (64-bit)` |
| RAM | `2048 Mo` minimum |
| CPU | `2` processeurs |
| Disque dur | `50 Go` (dynamiquement alloué) |

Montez l'ISO Windows 10 ou 11 (disponible sur le NAS) dans le lecteur optique, et configurez l'adaptateur réseau en **Réseau pont (Bridged)** — comme pour le serveur.

### Tâche 4.2 — Installer Windows

Démarrez la VM et installez Windows normalement. À l'étape **"Comment souhaitez-vous configurer ?"**, choisissez **Configurer pour une utilisation personnelle** (ou **Configurer pour une organisation** selon la version).

::: warning Créer un compte local, pas un compte Microsoft
Lors de l'installation, Windows peut demander de se connecter avec un compte Microsoft. Choisissez **Compte hors connexion** (ou **Options limitées** selon la version) pour créer un simple compte local. Le compte Microsoft n'est pas adapté à un poste de domaine.
:::

Créez le compte local avec :

| Champ | Valeur |
|---|---|
| Nom d'utilisateur | `LocalAdmin` |
| Mot de passe | `Admin@1234` |

### Tâche 4.3 — Renommer le poste

Une fois sur le bureau, renommez le poste pour lui donner un nom cohérent :

1. Clic droit sur **Démarrer → Système**
2. Cliquez sur **Renommer ce PC**
3. Entrez le nom : `PC-CLIENT-01`
4. Redémarrez

### Tâche 4.4 — Configurer le DNS vers le contrôleur de domaine

C'est l'étape **la plus importante** de la préparation. Pour rejoindre le domaine `techservices.local`, le poste client doit pouvoir résoudre ce nom via le DNS — et ce DNS, c'est votre serveur AD.

1. Clic droit sur l'icône réseau → **Ouvrir les paramètres réseau et Internet**
2. **Modifier les options d'adaptateur** → clic droit sur la carte active → **Propriétés**
3. Sélectionnez **Protocole Internet version 4 (TCP/IPv4)** → **Propriétés**

Configurez uniquement le DNS (l'IP peut rester en automatique si vous avez un DHCP sur le réseau) :

| Champ | Valeur |
|---|---|
| Serveur DNS préféré | `192.168.1.10` *(IP de SRV-AD-01)* |
| Serveur DNS auxiliaire | *(laisser vide)* |

Cliquez sur **OK**.

::: warning Pourquoi le DNS est crucial ?
Si le DNS n'est pas correctement configuré, la jonction au domaine échouera avec un message d'erreur du type *"Le domaine techservices.local est introuvable"*. Le poste ne peut pas trouver le contrôleur de domaine s'il ne peut pas résoudre son nom DNS.
:::

::: tip 📸 Capture 9
Propriétés TCP/IPv4 du poste `PC-CLIENT-01` — DNS préféré pointant vers `192.168.1.10`.
:::

### Tâche 4.5 — Vérifier la connectivité avec le serveur

Ouvrez **PowerShell** ou l'**Invite de commandes** et testez :

```powershell
ping 192.168.1.10
```

```powershell
ping SRV-AD-01.techservices.local
```

Les deux commandes doivent répondre. Si le deuxième `ping` fonctionne (résolution du nom DNS), votre poste est prêt à rejoindre le domaine.

::: warning Si le ping sur le nom DNS échoue
- Vérifiez que le DNS préféré est bien `192.168.1.10`
- Vérifiez que `SRV-AD-01` est démarré et que son service DNS est actif
- Vérifiez que les deux VMs sont sur le même réseau dans VirtualBox
:::

::: tip 📸 Capture 10
Sortie PowerShell sur `PC-CLIENT-01` — `ping SRV-AD-01.techservices.local` avec réponses reçues.
:::

---

## Mission 5 — Joindre le poste au domaine

C'est la mission centrale de ce TP. Une fois le poste joint au domaine, n'importe quel utilisateur AD pourra s'y connecter avec son compte du domaine.

### Tâche 5.1 — Lancer la procédure de jonction

Sur `PC-CLIENT-01`, ouvrez les propriétés système :

**Clic droit sur Démarrer → Système → Renommer ce PC (avancé)**

Ou tapez `sysdm.cpl` dans la barre de recherche Windows.

Dans l'onglet **Nom de l'ordinateur**, cliquez sur **Modifier**.

::: tip 📸 Capture 11
Fenêtre **Propriétés système** sur `PC-CLIENT-01` — onglet **Nom de l'ordinateur** affichant `WORKGROUP` comme groupe de travail actuel.
:::

### Tâche 5.2 — Rejoindre le domaine

Dans la fenêtre **Modification du nom ou du domaine de l'ordinateur** :

1. Sélectionnez **Domaine** (et non "Groupe de travail")
2. Entrez : `techservices.local`
3. Cliquez sur **OK**

Une fenêtre d'authentification apparaît. Entrez les **identifiants d'un compte administrateur du domaine** :

| Champ | Valeur |
|---|---|
| Nom d'utilisateur | `Administrateur` |
| Mot de passe | `Admin@1234` |

Cliquez sur **OK**.

::: info Pourquoi des identifiants administrateur ?
Joindre un ordinateur à un domaine est une opération sensible — elle donne au domaine le contrôle sur ce poste. Seul un compte avec les droits suffisants dans l'AD peut effectuer cette opération (par défaut, les membres du groupe `Admins du domaine`).
:::

Si tout est correctement configuré, un message de bienvenue apparaît :

> **"Bienvenue dans le domaine techservices.local"**

::: tip 📸 Capture 12
Message **"Bienvenue dans le domaine techservices.local"** après la jonction réussie.
:::

Cliquez sur **OK**, puis **OK** à nouveau, et **Redémarrer maintenant**.

### Tâche 5.3 — Vérifier depuis l'écran de connexion

Après le redémarrage, observez l'écran de connexion de Windows. Cliquez sur **Autres utilisateurs** (ou observez le champ de connexion).

Vous devez voir la mention :

```
Se connecter à : TECHSERVICES
```

Cela confirme que le poste est bien joint au domaine et prêt à accepter des connexions avec des comptes AD.

::: tip 📸 Capture 13
Écran de connexion Windows sur `PC-CLIENT-01` après jonction — mention **"Se connecter à : TECHSERVICES"** visible.
:::

---

## Mission 6 — Vérifier et tester de bout en bout

### Tâche 6.1 — Vérifier depuis la console Active Directory

Retournez sur `SRV-AD-01` et ouvrez la console **Utilisateurs et ordinateurs Active Directory**.

Naviguez dans le conteneur **Computers** (sous `techservices.local`). Votre poste `PC-CLIENT-01` doit y apparaître automatiquement.

::: tip 📸 Capture 14
Console ADUC — conteneur `Computers` affichant `PC-CLIENT-01` après la jonction.
:::

### Tâche 6.2 — Déplacer le poste dans l'OU Postes

Par défaut, les ordinateurs joints au domaine atterrissent dans le conteneur `Computers`. Il est préférable de les placer dans votre OU `Postes` pour pouvoir leur appliquer des GPO plus tard.

Dans la console ADUC, faites un **clic droit sur `PC-CLIENT-01`** → **Déplacer**.

Dans la fenêtre de sélection, naviguez vers `TechServices → Postes` et cliquez sur **OK**.

::: tip 📸 Capture 15
Console ADUC — OU `Postes` (dans `TechServices`) affichant `PC-CLIENT-01` après le déplacement.
:::

### Tâche 6.3 — Se connecter avec un compte du domaine

Sur `PC-CLIENT-01`, à l'écran de connexion, cliquez sur **Autres utilisateurs**.

Connectez-vous avec le compte de Sophie Leroy :

| Champ | Valeur |
|---|---|
| Nom d'utilisateur | `s.leroy` |
| Mot de passe | `Techservices@2024` |

Une nouvelle session s'ouvre au nom de Sophie Leroy — son profil est créé automatiquement sur ce poste.

### Tâche 6.4 — Vérifier l'identité de la session

Une fois connecté, ouvrez **PowerShell** et tapez :

```powershell
whoami
```

La commande doit retourner :

```
techservices\s.leroy
```

Vérifiez également les informations complètes :

```powershell
whoami /all
```

Cette commande affiche l'identité, les groupes d'appartenance (vous devez voir `GRP-Commercial` dans la liste) et les privilèges associés.

::: tip 📸 Capture 16
Sortie de `whoami /all` dans PowerShell — identité `techservices\s.leroy` et appartenance au groupe `GRP-Commercial` visibles.
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Quelle est la différence entre un **conteneur** (comme `Computers` ou `Users`) et une **Unité d'Organisation** (OU) dans Active Directory ? Pourquoi préfère-t-on utiliser des OUs ?
2. Pourquoi est-il conseillé de ne **pas laisser les ordinateurs dans le conteneur `Computers`** après leur jonction au domaine ?
3. Expliquez pourquoi la configuration du **DNS** sur le poste client est l'étape la plus critique avant la jonction au domaine.
4. Quelle est la différence entre un **groupe de sécurité** et un **groupe de distribution** dans Active Directory ? Dans quel cas utilise-t-on chacun ?
5. Sophie Leroy vient de rejoindre TechServices. Elle sera affectée à la fois au service Commercial **et** au service Informatique. Comment procéderiez-vous dans Active Directory pour refléter cette situation ?

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 16 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::
