---
outline: deep
---

# TP 3 — Stratégies de groupe (GPO)

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="Windows Server 2022 + Active Directory + GPO" />

::: info Contexte
Les utilisateurs et postes sont organisés dans l'AD depuis le TP 2. Votre responsable vous demande maintenant d'**uniformiser et sécuriser l'environnement de travail** : imposer une politique de mots de passe robuste, verrouiller automatiquement les sessions inactives, restreindre l'accès aux paramètres système et personnaliser l'environnement selon les services. Tout cela sans intervenir poste par poste — c'est précisément le rôle des **GPO**.
:::

::: warning Modalités
Vous avez besoin des deux VMs configurées au TP 2 :
- **SRV-AD-01** — contrôleur de domaine avec les OUs, utilisateurs et groupes créés
- **PC-CLIENT-01** — poste Windows joint au domaine `techservices.local`

Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Qu'est-ce qu'une GPO ?

Une **GPO** (Group Policy Object — Stratégie de groupe) est un ensemble de paramètres de configuration appliqués automatiquement aux **utilisateurs** et **ordinateurs** d'un domaine Active Directory. Elle remplace des dizaines de modifications manuelles poste par poste par une configuration centralisée sur le serveur.

::: info Ce qu'une GPO peut faire

| Catégorie | Exemples |
|---|---|
| **Sécurité** | Longueur minimale du mot de passe, verrouillage de compte, chiffrement… |
| **Environnement utilisateur** | Fond d'écran imposé, accès au Panneau de configuration restreint… |
| **Postes de travail** | Message de connexion, économiseur d'écran, désactivation de l'AutoRun USB… |
| **Réseau** | Mappage automatique de lecteurs réseau, imprimantes déployées… |
| **Logiciels** | Déploiement ou suppression d'applications à distance |

:::

### Ordre d'application des GPO (LSDOU)

Les GPO s'appliquent dans un ordre précis, de la moins prioritaire à la plus prioritaire. En cas de conflit entre deux GPO, c'est la dernière appliquée qui l'emporte.

```
Local → Site → Domaine → OU (de la racine vers la feuille)
```

| Niveau | Priorité | Description |
|---|---|---|
| **Local** | La plus faible | Paramètres locaux de chaque machine |
| **Site** | ↑ | Paramètres liés à un site réseau |
| **Domaine** | ↑ | S'applique à tous les objets du domaine |
| **OU** | La plus forte | S'applique aux objets de l'OU et de ses sous-OUs |

::: info GPO Utilisateur vs GPO Ordinateur
Chaque GPO contient deux sections indépendantes :
- **Configuration ordinateur** — appliquée au démarrage de la machine, quelle que soit la personne connectée
- **Configuration utilisateur** — appliquée à l'ouverture de session de l'utilisateur, quel que soit le poste utilisé
:::

---

## Mission 1 — Découverte de la console de gestion des GPO

### Tâche 1.1 — Ouvrir la console GPMC

Sur `SRV-AD-01`, ouvrez la **Console de gestion des stratégies de groupe** (GPMC) :

**Démarrer → Outils d'administration Windows → Gestion des stratégies de groupe**

Ou tapez `gpmc.msc` dans la barre de recherche Windows.

### Tâche 1.2 — Explorer la structure de la console

Dans l'arborescence de gauche, développez :
`Forêt : techservices.local → Domaines → techservices.local`

Vous découvrez les deux GPO créées automatiquement par Windows lors de la promotion du serveur en contrôleur de domaine :

| GPO | Rôle |
|---|---|
| **Default Domain Policy** | S'applique à tous les objets du domaine. Contient notamment la politique de mots de passe |
| **Default Domain Controllers Policy** | S'applique uniquement aux contrôleurs de domaine. Contient des paramètres d'audit et de droits d'utilisateur |

::: warning Ne jamais supprimer ces deux GPO
Ces stratégies sont fondamentales au fonctionnement d'Active Directory. Les modifier avec précaution, et ne jamais les supprimer.
:::

Développez ensuite l'OU `TechServices` dans l'arborescence. Pour l'instant, aucune GPO n'y est liée.

::: tip 📸 Capture 1
Console GPMC — arborescence dépliée affichant `techservices.local`, les deux GPO par défaut, et l'OU `TechServices`.
:::

### Tâche 1.3 — Comprendre les onglets d'une GPO

Cliquez sur **Default Domain Policy** dans l'arborescence. Le panneau de droite affiche plusieurs onglets :

| Onglet | Contenu |
|---|---|
| **Étendue** | OUs et groupes auxquels la GPO est liée et appliquée |
| **Détails** | Date de création, version, état de la GPO |
| **Paramètres** | Récapitulatif en lecture seule de tous les paramètres configurés |
| **Délégation** | Qui peut lire, modifier ou gérer cette GPO |

Cliquez sur l'onglet **Paramètres** et cliquez sur **Afficher tout** pour voir les paramètres actuellement configurés dans la Default Domain Policy.

---

## Mission 2 — Politique de mots de passe et verrouillage de compte

La politique de mots de passe du domaine se configure dans la **Default Domain Policy**. C'est la seule GPO dont les paramètres de mots de passe s'appliquent réellement à tous les comptes du domaine.

### Tâche 2.1 — Ouvrir l'éditeur de la Default Domain Policy

Dans la console GPMC, faites un **clic droit sur Default Domain Policy** → **Modifier**.

L'éditeur de gestion des stratégies de groupe s'ouvre.

### Tâche 2.2 — Configurer la politique de mots de passe

Dans l'arborescence de gauche de l'éditeur, naviguez vers :

**Configuration ordinateur → Stratégies → Paramètres Windows → Paramètres de sécurité → Stratégies de compte → Stratégie de mot de passe**

Configurez les paramètres suivants en double-cliquant sur chacun :

| Paramètre | Valeur à définir |
|---|---|
| Conserver l'historique des mots de passe | `5` mots de passe mémorisés |
| Durée de vie maximale du mot de passe | `90` jours |
| Durée de vie minimale du mot de passe | `1` jour |
| Longueur minimale du mot de passe | `8` caractères |
| Le mot de passe doit respecter des exigences de complexité | `Activé` |

::: info Que vérifie la complexité ?
Avec la complexité activée, Windows exige que le mot de passe contienne des caractères d'au moins **3 des 4 catégories** suivantes : majuscules, minuscules, chiffres, caractères spéciaux (`!@#$%...`). Il ne doit pas non plus contenir le nom de l'utilisateur.
:::

::: tip 📸 Capture 2
Éditeur GPO — paramètres de la **Stratégie de mot de passe** configurés dans la Default Domain Policy.
:::

### Tâche 2.3 — Configurer la stratégie de verrouillage de compte

Toujours dans l'éditeur, naviguez vers :

**Configuration ordinateur → Stratégies → Paramètres Windows → Paramètres de sécurité → Stratégies de compte → Stratégie de verrouillage du compte**

Configurez :

| Paramètre | Valeur |
|---|---|
| Seuil de verrouillage du compte | `5` tentatives d'ouverture de session non valides |
| Durée de verrouillage du compte | `30` minutes |
| Réinitialiser le compteur après | `15` minutes |

::: info Pourquoi ces paramètres ?
- **5 tentatives** : suffisant pour ne pas bloquer un utilisateur qui se trompe une ou deux fois, tout en bloquant les attaques par force brute.
- **30 minutes** : l'utilisateur se débloque automatiquement sans intervention du support. En entreprise, on préfère souvent mettre `0` (déblocage uniquement par un admin) pour plus de sécurité.
:::

Fermez l'éditeur.

::: tip 📸 Capture 3
Éditeur GPO — paramètres de la **Stratégie de verrouillage du compte** configurés.
:::

---

## Mission 3 — GPO appliquée aux utilisateurs

Vous allez créer une GPO qui s'appliquera à tous les utilisateurs de l'OU `TechServices` : fond d'écran imposé, économiseur d'écran avec verrouillage, et restriction du Panneau de configuration.

### Tâche 3.1 — Préparer le fond d'écran sur le serveur

Pour que tous les postes puissent accéder au fond d'écran, il doit être stocké dans un dossier réseau accessible depuis toutes les machines du domaine. Le partage **NETLOGON** est créé automatiquement sur tous les contrôleurs de domaine.

Sur `SRV-AD-01`, ouvrez **l'Explorateur de fichiers** et naviguez vers :

```
C:\Windows\SYSVOL\sysvol\techservices.local\scripts\
```

::: warning NETLOGON ≠ nom du dossier sur le disque
`NETLOGON` est le **nom du partage réseau**, pas le nom du dossier physique. Sur le disque, ce partage correspond au dossier `scripts\` (et non à un dossier `NETLOGON\` qui n'existe pas). C'est une source de confusion fréquente.

| Accès | Chemin |
|---|---|
| Depuis l'Explorateur (local) | `C:\Windows\SYSVOL\sysvol\techservices.local\scripts\` |
| Depuis le réseau (UNC) | `\\techservices.local\NETLOGON\` |

Les deux pointent vers le même endroit.
:::

Créez un sous-dossier nommé `wallpapers`.

Copiez-y n'importe quelle image (`.jpg` ou `.png`). Vous pouvez utiliser un fond d'écran par défaut de Windows Server, disponible dans :

```
C:\Windows\Web\Wallpaper\
```

Renommez l'image copiée en `fond-ecran.jpg`.

::: info Pourquoi NETLOGON ?
Le partage NETLOGON (`\\techservices.local\NETLOGON`) est accessible automatiquement par tous les postes du domaine sans configuration supplémentaire. C'est l'endroit idéal pour stocker des ressources partagées légères (fond d'écran, scripts de connexion…).
:::

### Tâche 3.2 — Créer la GPO utilisateurs

Dans la console GPMC, faites un **clic droit sur l'OU `TechServices`** → **Créer un objet GPO dans ce domaine, et le lier ici**.

| Champ | Valeur |
|---|---|
| Nom | `GPO-Utilisateurs-TechServices` |

Cliquez sur **OK**. La GPO apparaît liée à l'OU `TechServices` dans la console.

::: tip 📸 Capture 4
Console GPMC — GPO `GPO-Utilisateurs-TechServices` visible et liée à l'OU `TechServices`.
:::

### Tâche 3.3 — Imposer un fond d'écran

Faites un **clic droit sur `GPO-Utilisateurs-TechServices`** → **Modifier**.

Dans l'éditeur, naviguez vers :

**Configuration utilisateur → Stratégies → Modèles d'administration → Bureau → Bureau**

Double-cliquez sur **Papier peint du Bureau**.

| Champ | Valeur |
|---|---|
| État | `Activé` |
| Nom du papier peint | `\\techservices.local\NETLOGON\wallpapers\fond-ecran.jpg` |
| Style du papier peint | `Remplissage` |

Cliquez sur **OK**.

::: warning
Le chemin du papier peint doit être un chemin réseau UNC (`\\serveur\partage\...`), pas un chemin local. Un chemin local (`C:\...`) ne fonctionnerait que sur le serveur lui-même, pas sur les postes clients.
:::

::: tip 📸 Capture 5
Éditeur GPO — paramètre **Papier peint du Bureau** activé avec le chemin UNC vers le fond d'écran.
:::

### Tâche 3.4 — Activer l'économiseur d'écran avec verrouillage

Dans le même éditeur, naviguez vers :

**Configuration utilisateur → Stratégies → Modèles d'administration → Panneau de configuration → Personnalisation**

Configurez les trois paramètres suivants :

| Paramètre | Valeur |
|---|---|
| Activer l'écran de veille | `Activé` |
| Protéger l'écran de veille par un mot de passe | `Activé` |
| Délai avant activation de l'écran de veille | `Activé` → `300` secondes (5 minutes) |

::: info Pourquoi protéger l'écran de veille ?
Sans cette option, un utilisateur peut laisser sa session ouverte en partant — n'importe qui peut s'asseoir devant le poste et accéder à ses données. Le verrouillage automatique est une mesure de sécurité physique élémentaire.
:::

### Tâche 3.5 — Interdire l'accès au Panneau de configuration

Dans l'éditeur, naviguez vers :

**Configuration utilisateur → Stratégies → Modèles d'administration → Panneau de configuration**

Double-cliquez sur **Interdire l'accès au Panneau de configuration et à l'application Paramètres du PC**.

| Champ | Valeur |
|---|---|
| État | `Activé` |

Cliquez sur **OK**.

::: info Pourquoi restreindre le Panneau de configuration ?
Le Panneau de configuration permet de modifier de nombreux paramètres système (réseau, comptes, mises à jour…). Le restreindre empêche les utilisateurs de modifier la configuration du poste, ce qui garantit la cohérence du parc et réduit les appels au support.
:::

::: tip 📸 Capture 6
Éditeur GPO — paramètres de **Personnalisation** (économiseur d'écran) et restriction du **Panneau de configuration** configurés.
:::

Fermez l'éditeur.

---

## Mission 4 — GPO appliquée aux ordinateurs

Vous allez créer une seconde GPO, cette fois appliquée à l'OU `Postes`. Elle s'appliquera aux **machines** (quel que soit l'utilisateur connecté) et affichera un message d'avertissement légal à chaque démarrage de session.

### Tâche 4.1 — Créer la GPO postes

Dans la console GPMC, faites un **clic droit sur l'OU `Postes`** (dans `TechServices`) → **Créer un objet GPO dans ce domaine, et le lier ici**.

| Champ | Valeur |
|---|---|
| Nom | `GPO-Postes-TechServices` |

Cliquez sur **OK**.

::: tip 📸 Capture 7
Console GPMC — GPO `GPO-Postes-TechServices` liée à l'OU `Postes`.
:::

### Tâche 4.2 — Configurer un message d'avertissement à la connexion

Faites un **clic droit sur `GPO-Postes-TechServices`** → **Modifier**.

Dans l'éditeur, naviguez vers :

**Configuration ordinateur → Stratégies → Paramètres Windows → Paramètres de sécurité → Stratégies locales → Options de sécurité**

Faites défiler la liste et configurez les deux paramètres suivants :

**Ouverture de session interactive : titre du message pour les utilisateurs essayant de se connecter**

| Champ | Valeur |
|---|---|
| État | `Activé` |
| Texte | `TechServices — Accès restreint` |

**Ouverture de session interactive : texte du message pour les utilisateurs essayant de se connecter**

| Champ | Valeur |
|---|---|
| État | `Activé` |
| Texte | `Cet équipement est la propriété de TechServices. Tout accès non autorisé est interdit et fera l'objet de poursuites. En vous connectant, vous acceptez la politique d'utilisation du système d'information.` |

::: info Pourquoi un message de connexion ?
Ce message a une valeur légale : il avertit toute personne tentant de se connecter que le système est réservé aux utilisateurs autorisés. Sans ce message, il est plus difficile juridiquement de poursuivre un accès non autorisé.
:::

::: tip 📸 Capture 8
Éditeur GPO — les deux paramètres de message de connexion (**titre** et **texte**) configurés dans les Options de sécurité.
:::

### Tâche 4.3 — Désactiver l'AutoRun des périphériques USB

Toujours dans l'éditeur de `GPO-Postes-TechServices`, naviguez vers :

**Configuration ordinateur → Stratégies → Modèles d'administration → Composants Windows → Stratégies de lecture automatique**

Double-cliquez sur **Désactiver la lecture automatique**.

| Champ | Valeur |
|---|---|
| État | `Activé` |
| Désactiver la lecture automatique sur | `Tous les lecteurs` |

::: info Pourquoi désactiver l'AutoRun ?
L'AutoRun est un vecteur d'attaque classique : une clé USB malveillante branchée sur un poste peut exécuter automatiquement un programme sans aucune action de l'utilisateur. Le désactiver sur tous les lecteurs est une mesure de sécurité de base.
:::

Fermez l'éditeur.

---

## Mission 5 — Filtrer une GPO par groupe de sécurité

Par défaut, une GPO s'applique à **tous les objets** de l'OU à laquelle elle est liée. Le **filtrage de sécurité** permet de restreindre l'application d'une GPO à un groupe spécifique.

**Scénario** : la GPO `GPO-Utilisateurs-TechServices` restreint le Panneau de configuration pour tous. Mais le groupe `GRP-Informatique` a besoin d'y accéder pour administrer les postes. Vous allez créer une GPO d'exception qui annule cette restriction pour les membres de l'équipe informatique.

### Tâche 5.1 — Créer la GPO d'exception

Dans la console GPMC, faites un **clic droit sur l'OU `TechServices`** → **Créer un objet GPO dans ce domaine, et le lier ici**.

| Champ | Valeur |
|---|---|
| Nom | `GPO-Exception-Informatique` |

Ouvrez l'éditeur et naviguez vers :

**Configuration utilisateur → Stratégies → Modèles d'administration → Panneau de configuration**

Double-cliquez sur **Interdire l'accès au Panneau de configuration et à l'application Paramètres du PC**.

| Champ | Valeur |
|---|---|
| État | `Désactivé` |

::: info "Désactivé" vs "Non configuré"
- **Non configuré** : la GPO n'a pas d'effet sur ce paramètre (la valeur héritée s'applique)
- **Désactivé** : la GPO force explicitement le paramètre à `désactivé`, ce qui **écrase** la valeur héritée

En mettant `Désactivé` dans cette GPO d'exception, on annule le `Activé` venant de `GPO-Utilisateurs-TechServices`.
:::

Fermez l'éditeur.

### Tâche 5.2 — Restreindre la GPO au groupe Informatique

Dans la console GPMC, cliquez sur **`GPO-Exception-Informatique`**. Dans le panneau de droite, allez dans l'onglet **Étendue**.

Observez la section **Filtrage de sécurité** : par défaut, `Utilisateurs authentifiés` est listé, ce qui signifie que la GPO s'applique à tout le monde.

1. Sélectionnez **Utilisateurs authentifiés** et cliquez sur **Supprimer**
2. Cliquez sur **Ajouter** et tapez `GRP-Informatique`
3. Cliquez sur **Vérifier les noms** puis **OK**

::: warning Attention à l'ordre des GPO
Les GPO d'une même OU s'appliquent dans l'ordre affiché dans la console (de bas en haut — la GPO en tête de liste est appliquée en dernier et a donc la priorité). Vérifiez que `GPO-Exception-Informatique` est au-dessus de `GPO-Utilisateurs-TechServices` dans la liste, ou utilisez le bouton **Priorité** pour la remonter.
:::

::: tip 📸 Capture 9
Onglet **Étendue** de `GPO-Exception-Informatique` — filtrage de sécurité affichant uniquement `GRP-Informatique`.
:::

---

## Mission 6 — Vérifier l'application des GPO sur le poste client

Les GPO ne s'appliquent pas instantanément après leur création. Elles se propagent toutes les **90 minutes** environ par défaut. Pour ce TP, vous allez forcer la mise à jour immédiatement.

### Tâche 6.1 — Forcer la mise à jour des GPO

Sur **PC-CLIENT-01**, ouvrez **PowerShell en tant qu'administrateur** et tapez :

```powershell
gpupdate /force
```

Cette commande force la récupération et l'application de toutes les GPO en vigueur, sans attendre le délai automatique. Attendez le message de confirmation :

```
Mise à jour de la stratégie ordinateur...
Mise à jour de la stratégie utilisateur...
La mise à jour de la stratégie s'est terminée correctement.
```

::: tip 📸 Capture 10
Sortie de `gpupdate /force` sur `PC-CLIENT-01` — confirmation de mise à jour réussie.
:::

### Tâche 6.2 — Afficher les GPO appliquées

Toujours dans PowerShell, tapez :

```powershell
gpresult /r
```

Cette commande liste toutes les GPO qui se sont effectivement appliquées à la machine et à l'utilisateur courant, ainsi que celles qui ont été refusées et pourquoi.

Repérez dans la sortie :
- La section **ORDINATEUR** — doit afficher `GPO-Postes-TechServices`
- La section **UTILISATEUR** — doit afficher `GPO-Utilisateurs-TechServices`

::: info gpresult /h pour un rapport complet
La commande `gpresult /h rapport.html` génère un rapport HTML détaillé avec toutes les GPO, leurs paramètres et leur statut d'application. Très utile pour le diagnostic.
:::

::: tip 📸 Capture 11
Sortie de `gpresult /r` — sections **ORDINATEUR** et **UTILISATEUR** affichant les GPO correctement appliquées.
:::

### Tâche 6.3 — Vérifier le message de connexion

Déconnectez-vous du poste (ou verrouillez la session et reconnectez-vous). Avant l'écran de connexion, un message d'avertissement doit apparaître :

> **TechServices — Accès restreint**
> *Cet équipement est la propriété de TechServices...*

Cliquez sur **OK** pour le fermer et accéder à l'écran de connexion.

::: tip 📸 Capture 12
Message d'avertissement **TechServices — Accès restreint** affiché avant la connexion sur `PC-CLIENT-01`.
:::

### Tâche 6.4 — Vérifier le fond d'écran et les restrictions

Connectez-vous avec le compte `s.leroy` (Sophie Leroy, Commercial) :

1. **Fond d'écran** — le fond d'écran imposé par la GPO doit s'afficher automatiquement. L'utilisateur ne peut pas le changer.
2. **Panneau de configuration** — tapez `Panneau de configuration` dans la barre de recherche Windows. Un message d'erreur doit indiquer que l'accès est restreint par l'administrateur.

::: tip 📸 Capture 13
Bureau de `s.leroy` sur `PC-CLIENT-01` — fond d'écran imposé visible.
:::

::: tip 📸 Capture 14
Message de restriction lors de l'accès au **Panneau de configuration** pour l'utilisateur `s.leroy`.
:::

### Tâche 6.5 — Vérifier l'exception pour l'équipe informatique

Déconnectez-vous, puis reconnectez-vous avec le compte `l.bernard` (Lucas Bernard, Informatique — membre de `GRP-Informatique`).

Après connexion, tentez d'accéder au **Panneau de configuration**. Il doit s'ouvrir normalement, grâce à la `GPO-Exception-Informatique`.

::: tip 📸 Capture 15
**Panneau de configuration** accessible normalement pour l'utilisateur `l.bernard` (`GRP-Informatique`).
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Expliquez avec vos mots le principe **LSDOU**. Donnez un exemple concret de situation où l'ordre d'application des GPO change le résultat final.
2. Quelle est la différence entre **Configuration ordinateur** et **Configuration utilisateur** dans une GPO ? Donnez un exemple de paramètre qui appartient à chaque section.
3. Pourquoi la politique de mot de passe du domaine doit-elle être définie dans la **Default Domain Policy** et pas dans une GPO liée à une OU ?
4. Dans quel cas utilise-t-on le **filtrage de sécurité** d'une GPO plutôt que de simplement la lier à une OU différente ?
5. Un utilisateur se plaint que son fond d'écran revient toujours à celui imposé par l'administrateur. Expliquez-lui pourquoi et comment cette restriction est techniquement mise en place.

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 15 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::
