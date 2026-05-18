---
outline: deep
---

# TP 4 — Partages réseau et permissions NTFS

<Badge type="info" text="BTS SIO SISR 2ème année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="Windows Server 2022 + Active Directory + NTFS" />

::: info Contexte
L'Active Directory est en place, les utilisateurs et les GPO sont configurés. Votre responsable souhaite maintenant **centraliser les documents de l'entreprise sur le serveur** : chaque service dispose d'un espace de stockage privé accessible uniquement à ses membres, et un dossier commun permet de partager des documents transversaux. Les lecteurs réseau doivent se mapper automatiquement à l'ouverture de session — sans aucune action de l'utilisateur.
:::

::: warning Modalités
Vous avez besoin des VMs configurées lors des TP précédents :
- **SRV-AD-01** — contrôleur de domaine avec les OUs, utilisateurs et groupes du TP 2
- **PC-CLIENT-01** — poste Windows joint au domaine `techservices.local`

Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Deux couches de sécurité : partage et NTFS

Quand on partage un dossier en réseau sous Windows, **deux niveaux de permissions coexistent** :

| Couche | Rôle | S'applique... |
|---|---|---|
| **Droits de partage** | Contrôlent l'accès à la ressource depuis le réseau | Uniquement lors d'un accès via `\\serveur\partage` |
| **Permissions NTFS** | Contrôlent l'accès au niveau du système de fichiers | En local **et** via le réseau |

Quand un utilisateur accède à un dossier **via le réseau**, les deux couches s'appliquent simultanément. En cas de conflit, c'est la **permission la plus restrictive** qui l'emporte.

::: info Exemple de conflit
- Droits de partage : `Tout le monde = Modification`
- Permissions NTFS : `GRP-Commercial = Lecture`

→ L'utilisateur n'a que la **Lecture** — la plus restrictive des deux.
:::

### La bonne pratique

Gérer deux couches de permissions est source d'erreurs et de confusion lors du diagnostic. La bonne pratique en entreprise est donc :

> **Mettre `Tout le monde = Contrôle total` sur le partage réseau, et gérer les accès exclusivement avec les permissions NTFS.**

Le partage devient une simple porte d'entrée réseau. NTFS est le seul gardien. Un seul endroit à vérifier en cas de problème.

### Niveaux de permissions NTFS

| Permission | Ce que ça permet |
|---|---|
| **Lecture** | Lire et lister le contenu du dossier |
| **Lecture et exécution** | + Exécuter des fichiers et parcourir les sous-dossiers |
| **Modification** | + Créer, modifier et supprimer des fichiers et sous-dossiers |
| **Contrôle total** | + Modifier les permissions NTFS, prendre possession |

::: warning Pourquoi ne pas donner "Contrôle total" aux utilisateurs ?
"Contrôle total" permet à un utilisateur de **modifier les permissions NTFS** des fichiers — il pourrait s'accorder des droits sur des dossiers auxquels il ne devrait pas avoir accès. "Modification" est le niveau standard pour un utilisateur qui doit lire et écrire.
:::

---

## Mission 1 — Créer la structure de dossiers sur le serveur

### Tâche 1.1 — Créer les dossiers

Sur `SRV-AD-01`, ouvrez **PowerShell en tant qu'administrateur** et exécutez :

```powershell
New-Item -ItemType Directory -Path "C:\Partages"
$services = @("Direction", "Comptabilite", "Informatique", "Commercial", "Commun")
foreach ($s in $services) {
    New-Item -ItemType Directory -Path "C:\Partages\$s"
}
```

Vérifiez le résultat dans l'Explorateur de fichiers : `C:\Partages\` doit contenir cinq sous-dossiers.

::: tip 📸 Capture 1
Explorateur de fichiers — dossier `C:\Partages\` avec les cinq sous-dossiers (`Direction`, `Comptabilite`, `Informatique`, `Commercial`, `Commun`) visibles.
:::

---

## Mission 2 — Configurer les permissions NTFS

### Tâche 2.1 — Comprendre l'héritage NTFS

Par défaut, chaque nouveau dossier **hérite** des permissions de son dossier parent. `C:\Partages\Direction` hérite donc des permissions de `C:\Partages`, qui hérite de `C:\`. Parmi les entrées héritées figure notamment le groupe **Utilisateurs** — ce qui signifie que tous les utilisateurs du domaine pourraient lire le contenu de tous les dossiers.

Pour des dossiers confidentiels par service, il faut **désactiver l'héritage** et définir des permissions indépendantes.

### Tâche 2.2 — Configurer les permissions du dossier Direction

Dans l'Explorateur de fichiers, faites un **clic droit sur `C:\Partages\Direction`** → **Propriétés** → onglet **Sécurité** → **Avancé**.

Dans la fenêtre "Paramètres de sécurité avancés", cliquez sur **Désactiver l'héritage**.

Windows demande ce qu'il faut faire des permissions actuellement héritées. Choisissez :

> **Convertir les autorisations héritées en autorisations explicites**

Cela conserve les entrées existantes (SYSTEM, Administrateurs…) et les rend modifiables indépendamment. Cliquez sur **OK** pour fermer la fenêtre avancée.

::: tip 📸 Capture 2
Fenêtre "Paramètres de sécurité avancés" du dossier `Direction` — héritage désactivé (mention "Autorisations héritées" absente), liste des autorisations explicites visible.
:::

De retour dans l'onglet **Sécurité**, cliquez sur **Modifier**. Dans la liste des groupes et utilisateurs :

1. Sélectionnez **Utilisateurs (TECHSERVICES\Utilisateurs)** → cliquez sur **Supprimer**

   ::: warning Si "Utilisateurs" n'apparaît pas sous ce nom exact
   Cherchez `Utilisateurs authentifiés` ou `Domain Users`. Supprimez toute entrée qui donne accès à un groupe large non souhaité. L'objectif : ne laisser que SYSTEM, Administrateurs, et le groupe du service.
   :::

2. Cliquez sur **Ajouter** → tapez `GRP-Direction` → **Vérifier les noms** → **OK**
3. Avec `GRP-Direction` sélectionné, cochez **Modification** dans la colonne "Autoriser"
4. Cliquez sur **OK**

La liste finale doit contenir :

| Principal | Autorisation |
|---|---|
| SYSTEM | Contrôle total |
| Administrateurs (TECHSERVICES\Administrateurs) | Contrôle total |
| GRP-Direction | Modification |

::: tip 📸 Capture 3
Onglet **Sécurité** du dossier `Direction` — liste finale avec SYSTEM, Administrateurs et GRP-Direction uniquement.
:::

### Tâche 2.3 — Répéter pour les autres dossiers de service

Appliquez exactement la même procédure pour les trois dossiers restants :

| Dossier | Groupe à ajouter | Permission |
|---|---|---|
| `Comptabilite` | `GRP-Comptabilite` | Modification |
| `Informatique` | `GRP-Informatique` | Modification |
| `Commercial` | `GRP-Commercial` | Modification |

::: tip 📸 Capture 4
Onglet **Sécurité** du dossier `Commercial` — liste finale avec GRP-Commercial uniquement (en plus de SYSTEM et Administrateurs).
:::

### Tâche 2.4 — Configurer le dossier Commun

Le dossier `Commun` est accessible par tous les employés du domaine. Ici, pas besoin de désactiver l'héritage — on va simplement **ajouter** le droit d'écriture pour les utilisateurs du domaine.

Clic droit sur `C:\Partages\Commun` → **Propriétés** → onglet **Sécurité** → **Modifier** → **Ajouter** :

- Tapez `Utilisateurs du domaine` → **Vérifier les noms** → **OK**
- Cochez **Modification** dans la colonne "Autoriser"
- Cliquez sur **OK**

::: tip 📸 Capture 5
Onglet **Sécurité** du dossier `Commun` — `Utilisateurs du domaine` avec permission `Modification` visible.
:::

---

## Mission 3 — Partager les dossiers en réseau

### Tâche 3.1 — Partager le dossier Direction

Clic droit sur `C:\Partages\Direction` → **Propriétés** → onglet **Partage** → **Partage avancé**.

Cochez **Partager ce dossier** et renseignez :

| Champ | Valeur |
|---|---|
| Nom du partage | `Direction` |
| Commentaire | `Dossier du service Direction — accès restreint` |

Cliquez sur **Autorisations** :
- L'entrée `Tout le monde` est présente avec `Lecture` par défaut
- Cochez également **Modifier** et **Contrôle total** pour `Tout le monde`
- Cliquez sur **OK**

::: info Pourquoi "Contrôle total" sur le partage ?
Conformément à la bonne pratique vue en introduction : on laisse NTFS être l'unique point de contrôle. Si le partage restreint à "Lecture" alors que NTFS autorise "Modification", l'utilisateur ne pourra pas modifier les fichiers malgré son droit NTFS — un comportement difficile à diagnostiquer. Contrôle total sur le partage + NTFS = clarté.
:::

Cliquez sur **OK** pour fermer le partage avancé.

::: tip 📸 Capture 6
Fenêtre **Partage avancé** du dossier `Direction` — partage actif, autorisations `Tout le monde = Contrôle total`.
:::

### Tâche 3.2 — Partager les autres dossiers

Répétez la même procédure pour les quatre dossiers restants :

| Dossier | Nom du partage |
|---|---|
| `Comptabilite` | `Comptabilite` |
| `Informatique` | `Informatique` |
| `Commercial` | `Commercial` |
| `Commun` | `Commun` |

### Tâche 3.3 — Vérifier les partages depuis le réseau

Sur `SRV-AD-01`, ouvrez l'**Explorateur de fichiers** et tapez dans la barre d'adresse :

```
\\SRV-AD-01
```

Vous devez voir les cinq partages listés. Vous pouvez également les vérifier via PowerShell :

```powershell
Get-SmbShare | Where-Object { $_.Path -like "C:\Partages*" } | Select-Object Name, Path
```

::: tip 📸 Capture 7
Explorateur de fichiers — `\\SRV-AD-01` affichant les cinq partages (`Direction`, `Comptabilite`, `Informatique`, `Commercial`, `Commun`).
:::

---

## Mission 4 — Mapper automatiquement les lecteurs via GPO

Plutôt que de demander aux utilisateurs de se connecter manuellement aux partages, une GPO va **mapper les lecteurs réseau automatiquement** à l'ouverture de session. On utilisera les **Préférences de stratégies de groupe** (GPP) avec le **ciblage au niveau des éléments** — une fonctionnalité qui permet de conditionner l'application d'un paramètre à des critères précis comme l'appartenance à un groupe de sécurité.

### Tâche 4.1 — Créer la GPO de mappage

Sur `SRV-AD-01`, ouvrez la console GPMC (`gpmc.msc`).

Faites un **clic droit sur l'OU `TechServices`** → **Créer un objet GPO dans ce domaine, et le lier ici**.

| Champ | Valeur |
|---|---|
| Nom | `GPO-Lecteurs-Réseau` |

Cliquez sur **OK**, puis **clic droit sur `GPO-Lecteurs-Réseau`** → **Modifier**.

### Tâche 4.2 — Configurer le lecteur commun (Z:)

Dans l'éditeur, naviguez vers :

**Configuration utilisateur → Préférences → Paramètres Windows → Mappages de lecteurs**

Clic droit dans le panneau de droite → **Nouveau → Lecteur mappé**.

| Champ | Valeur |
|---|---|
| Action | `Créer` |
| Emplacement | `\\SRV-AD-01\Commun` |
| Étiquette | `Commun (Z:)` |
| Lettre de lecteur | `Z` |
| Reconnecter | ☑️ Coché |

Ne cochez pas de ciblage pour ce lecteur — il doit s'appliquer à **tous les utilisateurs** du domaine.

Cliquez sur **OK**.

::: tip 📸 Capture 8
Fenêtre de création du lecteur mappé `Z:` — chemin `\\SRV-AD-01\Commun`, reconnecter coché.
:::

### Tâche 4.3 — Configurer les lecteurs de service avec ciblage (P:)

Vous allez créer **quatre mappages** sur la même lettre `P:`, chacun conditionné à l'appartenance au groupe de service correspondant. Pour un utilisateur donné, **une seule des quatre règles s'appliquera** — celle dont il est membre du groupe.

**Créez le premier mappage pour le service Direction :**

Clic droit → **Nouveau → Lecteur mappé**.

| Champ | Valeur |
|---|---|
| Action | `Créer` |
| Emplacement | `\\SRV-AD-01\Direction` |
| Étiquette | `Mon service (P:)` |
| Lettre de lecteur | `P` |
| Reconnecter | ☑️ Coché |

**Avant de cliquer sur OK**, allez dans l'onglet **Commun** (en haut de la fenêtre de création) :
- Cochez **Ciblage au niveau des éléments**
- Cliquez sur **Ciblage…**

Dans l'éditeur de ciblage, cliquez sur **Nouvel élément → Groupe de sécurité**.

| Champ | Valeur |
|---|---|
| L'utilisateur est membre de | `GRP-Direction` (cliquez sur `...` pour rechercher) |

Cliquez sur **OK** pour fermer l'éditeur de ciblage, puis **OK** pour créer le mappage.

::: tip 📸 Capture 9
Éditeur de ciblage — condition `L'utilisateur est membre de GRP-Direction` configurée pour le lecteur `P:`.
:::

**Répétez pour les trois autres services :**

| Partage | Chemin UNC | Lettre | Groupe cible |
|---|---|---|---|
| Comptabilite | `\\SRV-AD-01\Comptabilite` | `P` | `GRP-Comptabilite` |
| Informatique | `\\SRV-AD-01\Informatique` | `P` | `GRP-Informatique` |
| Commercial | `\\SRV-AD-01\Commercial` | `P` | `GRP-Commercial` |

::: info Quatre mappages, une seule lettre — comment ça fonctionne ?
Chaque mappage contient une condition de ciblage différente. Lorsque la GPO s'applique à un utilisateur :
- les trois conditions qui ne le concernent pas → mappages ignorés
- la condition qui correspond à son groupe → lecteur `P:` créé avec le bon chemin

L'utilisateur voit **un seul lecteur `P:`**, qui pointe automatiquement vers le dossier de son service.
:::

::: tip 📸 Capture 10
Console de mappage des lecteurs — les cinq mappages configurés (`P:` ×4 avec ciblage + `Z:` sans ciblage) affichés dans le panneau.
:::

Fermez l'éditeur GPO.

---

## Mission 5 — Vérifier les accès depuis le poste client

### Tâche 5.1 — Forcer la mise à jour des GPO

Sur **PC-CLIENT-01**, ouvrez **PowerShell en tant qu'administrateur** et tapez :

```powershell
gpupdate /force
```

::: warning Déconnecter, pas juste verrouiller
Les mappages de lecteurs GPP s'appliquent **à l'ouverture de session**, pas lors d'un simple `gpupdate`. Après la mise à jour, **déconnectez complètement la session** (bouton Démarrer → clic sur l'icône utilisateur → Se déconnecter) avant de tester.
:::

### Tâche 5.2 — Tester avec Sophie Leroy (Commercial)

Connectez-vous avec `s.leroy` / `Techservices@2024`.

Après connexion, ouvrez l'**Explorateur de fichiers**. Dans "Ce PC", vous devez voir :

- **Lecteur Z: (Commun)** — pointant vers `\\SRV-AD-01\Commun`
- **Lecteur P: (Mon service)** — pointant vers `\\SRV-AD-01\Commercial`

**Test 1 — Écriture dans son dossier :**
Ouvrez `P:` et créez un fichier texte nommé `test-sleroy.txt`. L'opération doit réussir.

**Test 2 — Accès à un dossier interdit :**
Tapez `\\SRV-AD-01\Direction` dans la barre d'adresse de l'Explorateur. Un message d'erreur **"Accès refusé"** (ou "Vous ne disposez pas des autorisations pour accéder à…") doit apparaître.

::: tip 📸 Capture 11
Explorateur de fichiers de `s.leroy` — lecteurs `P:` (Commercial) et `Z:` (Commun) mappés et visibles dans "Ce PC".
:::

::: tip 📸 Capture 12
Message **"Accès refusé"** lors de la tentative d'accès à `\\SRV-AD-01\Direction` depuis le compte `s.leroy`.
:::

### Tâche 5.3 — Tester avec Lucas Bernard (Informatique)

Déconnectez-vous, puis connectez-vous avec `l.bernard` / `Techservices@2024`.

Vérifiez que :
- Le lecteur `P:` pointe maintenant vers `\\SRV-AD-01\Informatique` (et non Commercial)
- Le lecteur `Z:` est toujours présent et accessible

Ouvrez `P:` et créez un fichier `test-lbernard.txt` pour confirmer les droits d'écriture.

::: tip 📸 Capture 13
Explorateur de fichiers de `l.bernard` — lecteur `P:` pointant vers `\\SRV-AD-01\Informatique`.
:::

### Tâche 5.4 — Vérifier les fichiers créés depuis le serveur

Retournez sur **SRV-AD-01**. Dans l'Explorateur de fichiers, naviguez vers :
- `C:\Partages\Commercial` → le fichier `test-sleroy.txt` doit être présent
- `C:\Partages\Informatique` → le fichier `test-lbernard.txt` doit être présent

::: tip 📸 Capture 14
Contenu du dossier `C:\Partages\Commercial` sur `SRV-AD-01` — fichier `test-sleroy.txt` créé par `s.leroy` visible.
:::

### Tâche 5.5 — Consulter les partages actifs via PowerShell

Sur `SRV-AD-01`, exécutez la commande suivante pour afficher les sessions actives sur les partages :

```powershell
Get-SmbSession | Select-Object ClientUserName, ClientComputerName, NumOpens
```

Cette commande montre quels utilisateurs sont actuellement connectés à quels partages et combien de fichiers sont ouverts.

::: tip 📸 Capture 15
Sortie de `Get-SmbSession` sur `SRV-AD-01` — sessions actives affichant `s.leroy` ou `l.bernard` connecté.
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Expliquez la règle d'application lorsque des droits de partage et des permissions NTFS sont tous les deux configurés. Prenez un exemple concret : un utilisateur a `Contrôle total` en NTFS et `Lecture` sur le partage — quel accès effectif obtient-il en passant par le réseau ?

2. Pourquoi la bonne pratique consiste-t-elle à mettre `Tout le monde = Contrôle total` sur le partage réseau et à tout gérer via les permissions NTFS ? Quels problèmes cela évite-t-il lors du diagnostic ?

3. Quelle est la différence entre la permission NTFS **Modification** et **Contrôle total** ? Pourquoi ne donne-t-on pas "Contrôle total" aux utilisateurs standard ?

4. Qu'est-ce que l'**héritage de permissions NTFS** ? Pourquoi l'a-t-on désactivé sur les dossiers de service (`Direction`, `Commercial`…), mais pas sur le dossier `Commun` ?

5. Expliquez le fonctionnement du **ciblage au niveau des éléments** dans les Préférences GPO. Quel avantage cela présente-t-il par rapport à une approche "une GPO par OU" pour gérer les mappages de lecteurs ?

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 15 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::
