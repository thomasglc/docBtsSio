---
outline: deep
---

# TP 1 — Prise en main de l'environnement

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 — Initiation C#" />  <Badge type="danger" text="Visual Studio 2022" />

::: info Contexte
Bienvenue en BTS SIO ! Ce premier TP est votre point de départ dans le développement logiciel. Vous allez découvrir **Visual Studio**, l'environnement de développement intégré que vous utiliserez toute l'année, et écrire vos **premiers programmes en C#**.

À la fin de cette séance, vous saurez créer un projet, écrire du code, l'exécuter et lire le résultat affiché dans la console.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Vous devez remplir le **document de restitution** au fur et à mesure de la séance — des questions vous sont posées à chaque étape clé. Ce document est à déposer sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp1-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>

Les captures d'écran demandées 📸 sont à coller directement dans ce document.
:::

---

## Qu'est-ce que Visual Studio ?

**Visual Studio** est un **environnement de développement intégré** (IDE — *Integrated Development Environment*). C'est un logiciel tout-en-un qui regroupe :

- un **éditeur de code** avec coloration syntaxique et autocomplétion intelligente
- un **compilateur** qui transforme votre code source en programme exécutable
- un **débogueur** pour analyser et corriger les erreurs pas à pas
- un **gestionnaire de projets** pour organiser vos fichiers et dépendances

Visual Studio est développé par **Microsoft** et est l'un des IDE les plus utilisés dans le monde professionnel, notamment pour le développement en C# et .NET.

---

## Mission 1 — Créer votre premier projet C#

### Tâche 1.1 — Lancer Visual Studio et créer un projet

Lancez **Visual Studio 2022** depuis le bureau ou le menu Démarrer. Sur l'écran d'accueil, cliquez sur **"Créer un projet"**.

La fenêtre de création de projet s'ouvre :

1. Dans la barre de recherche en haut, tapez `Console`
2. Sélectionnez **"Application console"** — vérifiez que le badge **C#** est bien visible (et non VB.NET ou F#)
3. Cliquez sur **Suivant**

<!-- 📷 IMAGE REQUISE : fenêtre "Créer un projet" avec le modèle "Application console C#" sélectionné -->

::: tip 📸 Capture 1
La fenêtre de sélection du modèle — "Application console C#" sélectionné.
:::

### Tâche 1.2 — Configurer le projet

Renseignez les informations suivantes :

| Champ | Valeur |
|---|---|
| Nom du projet | `MonPremierProgramme` |
| Emplacement | Le dossier à votre nom sur le disque D |
| Nom de la solution | `MonPremierProgramme` (identique au projet) |

Cliquez sur **Suivant**, choisissez **.NET 8.0** comme framework cible, puis cliquez sur **Créer**.

::: info Qu'est-ce que .NET ?
**.NET** est la plateforme logicielle développée par Microsoft sur laquelle s'exécutent les programmes C#. C'est elle qui fournit toutes les bibliothèques (fonctions prêtes à l'emploi) que vous utiliserez, comme `Console.WriteLine`. La version 8.0 est la version stable recommandée.
:::

### Tâche 1.3 — Explorer la structure générée

Visual Studio a automatiquement créé plusieurs fichiers. Observez l'**Explorateur de solutions** :

```
MonPremierProgramme/
├── MonPremierProgramme.sln        ← Fichier Solution (.sln)
└── MonPremierProgramme/
    ├── MonPremierProgramme.csproj ← Fichier Projet (.csproj)
    └── Program.cs                 ← Votre code source
```

- Le **`.sln`** (Solution) est le conteneur de plus haut niveau. Une solution peut regrouper plusieurs projets liés entre eux.
- Le **`.csproj`** (C# Project) décrit votre projet : ses dépendances, la version de .NET utilisée, les options de compilation.
- **`Program.cs`** est le fichier où vous écrirez votre code.

::: tip 📸 Capture 2
L'Explorateur de solutions montrant les fichiers générés.
:::

::: tip Document de restitution — Question 1
Complétez la **Question 1** dans votre document.
:::

---

## Mission 2 — Découverte de l'interface

Maintenant que votre projet est ouvert, l'IDE est entièrement chargé. Profitez-en pour faire le tour des différentes zones de Visual Studio.

<!-- 📷 IMAGE REQUISE : capture annotée de l'interface VS avec zones A-E indiquées -->

L'interface est découpée en plusieurs **zones**, chacune ayant un rôle précis :

---

**Zone A — La barre de menus** *(en haut)*

C'est la bande tout en haut de la fenêtre : **Fichier, Édition, Affichage, Projet…** Elle donne accès à **toutes** les fonctionnalités de Visual Studio. Vous l'utiliserez notamment pour créer un projet (**Fichier → Nouveau**), ouvrir un fichier existant, ou accéder aux paramètres.

---

**Zone B — La barre d'outils** *(juste en dessous de la barre de menus)*

Une rangée de boutons et menus déroulants pour les actions **les plus courantes**, sans passer par les menus. Le plus important est le bouton **▶ (Démarrer)** qui lance votre programme. À sa gauche, un menu déroulant indique la configuration de build (`Debug` ou `Release`) — laissez-le sur `Debug` pour l'instant.

---

**Zone C — L'Explorateur de solutions** *(panneau latéral, généralement à droite)*

C'est votre **arborescence de fichiers**. Il affiche la structure de votre projet : la solution, le projet, et tous les fichiers `.cs` qui le composent. Double-cliquer sur un fichier l'ouvre dans l'éditeur. C'est ici que vous naviguerez entre vos différents fichiers de code au quotidien.

::: info Si l'Explorateur de solutions n'est pas visible
Allez dans **Affichage → Explorateur de solutions** (ou `Ctrl + Alt + L`).
:::

---

**Zone D — L'éditeur de code** *(zone centrale, la plus grande)*

C'est ici que vous **écrivez votre code**. Visual Studio vous assiste en temps réel :
- **Coloration syntaxique** — les mots-clés, chaînes, commentaires ont chacun leur couleur
- **IntelliSense** — une liste de suggestions s'affiche pendant que vous tapez
- **Soulignement rouge** — signale une erreur dans le code avant même que vous tentiez de l'exécuter
- **Numéros de ligne** — à gauche, ils facilitent la lecture et la correction d'erreurs

---

**Zone E — Les fenêtres du bas** *(panneau inférieur)*

Plusieurs onglets importants s'y trouvent :

| Onglet | Rôle |
|---|---|
| **Output (Sortie)** | Affiche les messages de compilation — succès ou liste des erreurs |
| **Liste d'erreurs** | Récapitule toutes les erreurs et avertissements avec leur numéro de ligne |
| **Terminal** | Un terminal intégré pour exécuter des commandes (nous l'utiliserons plus tard) |

::: info Si la fenêtre Output n'est pas visible
Allez dans **Affichage → Sortie** (ou `Ctrl + Alt + O`).
:::

---

::: tip 📸 Capture 3
Vue d'ensemble de l'interface Visual Studio avec votre projet ouvert — repérez les 5 zones sur votre capture.
:::

::: tip Document de restitution — Question 2
Complétez la **Question 2** dans votre document.
:::

---

## Mission 3 — Premier programme : "Bonjour le monde !"

### Tâche 3.1 — Lire le code généré

Double-cliquez sur **`Program.cs`** dans l'Explorateur de solutions. Visual Studio a déjà généré du code :

```csharp
// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");
```

Décortiquons chaque élément :

| Élément | Rôle |
|---|---|
| `//` | Début d'un **commentaire** — cette ligne est ignorée par le programme |
| `Console` | La console (fenêtre noire) de votre programme |
| `.WriteLine(...)` | **Méthode** qui affiche du texte et passe à la ligne suivante |
| `"Hello, World!"` | Une **chaîne de caractères** — du texte entouré de guillemets doubles |
| `;` | **Point-virgule** — termine chaque instruction, **obligatoire** en C# |

### Tâche 3.2 — Exécuter le programme

Lancez le programme avec **`Ctrl + F5`** (exécution sans débogage), ou cliquez sur le bouton **▶ MonPremierProgramme** dans la barre d'outils.

Une fenêtre console s'ouvre et affiche :
```
Hello, World!
```

::: tip 📸 Capture 4
La fenêtre console affichant "Hello, World!".
:::

::: tip Document de restitution — Question 3
Complétez la **Question 3** dans votre document.
:::

### Tâche 3.3 — Personnaliser le message

Modifiez le code pour afficher un message de votre choix. Par exemple :

```csharp
Console.WriteLine("Bonjour, je m'appelle Lucie !");
```

Remplacez par votre prénom. Exécutez avec **Ctrl + F5**.

::: tip 📸 Capture 5
La console affichant votre message personnalisé.
:::

---

## Mission 4 — Explorer Console.WriteLine

### Tâche 4.1 — Afficher plusieurs lignes

`Console.WriteLine` affiche une ligne puis passe à la suivante. Vous pouvez l'appeler autant de fois que nécessaire :

```csharp
Console.WriteLine("Première ligne");
Console.WriteLine("Deuxième ligne");
Console.WriteLine("Troisième ligne");
```

Remplacez le contenu de `Program.cs` par ce code et exécutez. Les instructions s'exécutent **dans l'ordre**, de haut en bas.

### Tâche 4.2 — Write vs. WriteLine

Il existe deux variantes de la méthode d'affichage :

| Méthode | Comportement |
|---|---|
| `Console.WriteLine("texte")` | Affiche le texte **et** passe à la ligne suivante (↵) |
| `Console.Write("texte")` | Affiche le texte **sans** passer à la ligne |

Testez ce code :

```csharp
Console.Write("Je m'appelle ");
Console.Write("Thomas");
Console.WriteLine(" et je suis en BTS SIO.");
Console.WriteLine("Bonne journée !");
```

::: tip Document de restitution — Question 4
Complétez la **Question 4** dans votre document.
:::

### Tâche 4.3 — Les séquences d'échappement

À l'intérieur d'une chaîne de caractères, certaines combinaisons avec le `\` ont un effet spécial :

| Séquence | Effet |
|---|---|
| `\n` | Retour à la ligne (comme appuyer sur Entrée) |
| `\t` | Tabulation horizontale (décalage vers la droite) |
| `\"` | Affiche un guillemet `"` (sinon il fermerait la chaîne) |
| `\\` | Affiche un antislash `\` |

Testez ce code pour simuler un tableau formaté :

```csharp
Console.WriteLine("Nom\t\tPrénom\t\tÂge");
Console.WriteLine("--------\t--------\t----");
Console.WriteLine("MARTIN\t\tLucie\t\t17");
Console.WriteLine("DUPONT\t\tThomas\t\t18");
```

::: tip Document de restitution — Question 5
Complétez la **Question 5** dans votre document.
:::

### Tâche 4.4 — Afficher des nombres et des calculs

`Console.WriteLine` peut aussi afficher des **nombres** et le résultat de **calculs** directement — sans guillemets :

```csharp
Console.WriteLine(42);
Console.WriteLine(3.14);
Console.WriteLine(10 + 5);
Console.WriteLine(100 - 37);
Console.WriteLine(6 * 7);
Console.WriteLine(20 / 4);
Console.WriteLine(10 % 3);
```

::: info Les opérateurs arithmétiques en C#
| Symbole | Opération | Exemple | Résultat |
|---|---|---|---|
| `+` | Addition | `10 + 5` | `15` |
| `-` | Soustraction | `100 - 37` | `63` |
| `*` | Multiplication | `6 * 7` | `42` |
| `/` | Division | `20 / 4` | `5` |
| `%` | Modulo (reste) | `10 % 3` | `1` |
:::

Exécutez ce code et observez chaque résultat.

::: tip Document de restitution — Question 6
Complétez la **Question 6** dans votre document.
:::

---

## Mission 5 — Exercices de consolidation

### Exercice 1 — Ma carte de visite

Créez un programme qui affiche une **carte de visite** dans la console en utilisant `Console.WriteLine` et `Console.Write`. Elle doit contenir :

- Votre nom et prénom
- Votre classe : BTS SIO 1
- L'établissement : Lycée Camille Sée — Colmar
- L'année scolaire : 2026-2027

Voici un exemple de mise en forme à reproduire (adaptez avec vos informations) :

```
╔══════════════════════════════════╗
║         CARTE DE VISITE          ║
╠══════════════════════════════════╣
║  Nom    : MARTIN Lucie           ║
║  Classe : BTS SIO 1              ║
║  École  : Lycée Camille Sée      ║
║           Colmar                 ║
║  Année  : 2026-2027              ║
╚══════════════════════════════════╝
```

::: tip Caractères de bordure
Copiez-collez ces caractères directement dans votre code : `╔ ╗ ║ ╠ ╣ ╚ ╝ ═`
:::

::: tip 📸 Capture 6
Votre carte de visite affichée dans la console.
:::

### Exercice 2 — Table de calculs

Créez un programme qui affiche la **table des opérations** pour le nombre **8** avec le nombre **3** :

```
=== Table de calculs ===
8 + 3  =  11
8 - 3  =   5
8 * 3  =  24
8 / 3  =   2   <- division entière
8 % 3  =   2   <- reste de la division
```

::: warning
Utilisez les calculs directement dans `Console.WriteLine` — ne tapez pas les résultats à la main. Visual Studio doit les calculer pour vous.
:::

::: tip 📸 Capture 7
La table de calculs affichée dans la console avec les résultats calculés par le programme.
:::

### Exercice 3 — Changer de nombre

Modifiez votre table de calculs pour qu'elle affiche les opérations avec **17** et **5** à la place de **8** et **3**. Combien de modifications avez-vous dû faire dans le code ?

Recommencez ensuite avec **100** et **7**.

::: tip Document de restitution — Question 7
Complétez la **Question 7** dans votre document.
:::

---

## Bilan et questions de synthèse

::: tip Document de restitution — Question 8
Complétez la **Question 8** dans votre document pour conclure ce TP.
:::

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les réponses aux 8 questions et les 7 captures d'écran demandées.
:::
