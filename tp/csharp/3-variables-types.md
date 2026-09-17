---
outline: deep
---

# TP 3 — Variables et types

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 — Initiation C#" />  <Badge type="danger" text="Visual Studio 2022 · C#" />

::: info Contexte
Dans le TP 2, vous avez découvert les variables `string` et appris à lire des saisies clavier. Mais que se passe-t-il quand on veut faire des **calculs** ? Une chaîne de caractères ne se multiplie pas ! Ce TP vous présente les types numériques de C# — `int` et `double` — et vous apprend à convertir les saisies utilisateur pour effectuer de vraies opérations mathématiques.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Vous devez remplir le **document de restitution** au fur et à mesure de la séance. Ce document est à déposer sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp3-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>

Les captures d'écran demandées 📸 sont à coller directement dans ce document.
:::

---

## Ce que vous allez apprendre

| Concept | Ce que c'est |
|---|---|
| **int** | Entier : `int age = 20;` — nombres sans décimales |
| **double** | Décimal : `double taille = 1.75;` — nombres avec virgule |
| **Convert.ToInt32()** | Transformer la chaîne `"42"` en entier `42` |
| **Convert.ToDouble()** | Transformer la chaîne `"3,14"` en décimal `3.14` |
| **FormatException** | L'erreur qui survient quand la conversion échoue |

---

## Mission 1 — Les types numériques

### Tâche 1.1 — Créer un nouveau projet

Créez un nouveau projet dans Visual Studio :

| Champ | Valeur |
|---|---|
| Type | Application console (C#) |
| Nom du projet | `VariablesEtTypes` |
| Emplacement | Le dossier à votre nom sur le disque D |
| Framework | .NET 8.0 |

### Tâche 1.2 — Le type int

**`int`** (abréviation de *integer*, entier en anglais) stocke des **nombres entiers**, c'est-à-dire sans décimales :

```csharp
int age = 20;
int annee = 2026;
int nombreEleves = 28;

Console.WriteLine(age);
Console.WriteLine(annee);
Console.WriteLine(nombreEleves);
```

Les opérateurs arithmétiques s'appliquent directement aux variables `int` :

```csharp
int a = 10;
int b = 3;

Console.WriteLine(a + b);   // 13
Console.WriteLine(a - b);   // 7
Console.WriteLine(a * b);   // 30
Console.WriteLine(a / b);   // 3  ← division entière, pas 3,33 !
Console.WriteLine(a % b);   // 1  ← reste de la division (modulo)
```

::: warning La division entière
Avec `int`, `10 / 3` donne `3` — **pas** `3,33`. C# conserve uniquement la partie entière. C'est une source fréquente d'erreurs : si vous attendez un résultat décimal, il faut utiliser `double`.
:::

### Tâche 1.3 — Le type double

**`double`** stocke des **nombres à virgule** :

```csharp
double taille = 1.75;
double prixUnitaire = 9.99;
double pi = 3.14159;

Console.WriteLine(taille);
Console.WriteLine(prixUnitaire);
```

::: info Virgule ou point dans le code ?
Dans le code source C#, le séparateur décimal est toujours le **point** (`.`). Écrivez `1.75` dans votre code, pas `1,75`. La virgule est réservée pour séparer les paramètres d'une fonction.
:::

Testez maintenant la différence entre division entière et division décimale :

```csharp
int a = 10;
int b = 3;

double da = 10.0;
double db = 3.0;

Console.WriteLine(a / b);     // 3       ← division entière
Console.WriteLine(da / db);   // 3,3333... ← division décimale
```

::: tip 📸 Capture 1
La console affichant les résultats des deux types de division (entière et décimale).
:::

::: tip Document de restitution — Question 1
Complétez la **Question 1** dans votre document.
:::

---

## Mission 2 — Convertir une saisie en nombre

### Tâche 2.1 — Le problème avec Console.ReadLine()

`Console.ReadLine()` renvoie **toujours un `string`**. Si l'utilisateur tape `25`, le programme reçoit la chaîne de caractères `"25"` — pas le nombre `25`. Et vous ne pouvez pas faire de calcul avec une chaîne !

Essayez ce code — Visual Studio refusera de compiler :

```csharp
Console.Write("Entrez un nombre : ");
string saisie = Console.ReadLine();

int resultat = saisie * 2;  // ❌ Erreur de compilation !
Console.WriteLine(resultat);
```

Visual Studio souligne `saisie * 2` en rouge. Il ne sait pas multiplier du texte par un nombre — ce n'est pas logique pour le compilateur.

### Tâche 2.2 — La solution : la classe Convert

La classe `Convert` fournie par .NET permet de transformer un type en un autre :

| Méthode | Transformation |
|---|---|
| `Convert.ToInt32("42")` | `string` → `int` |
| `Convert.ToDouble("3,14")` | `string` → `double` |
| `Convert.ToString(42)` | `int` → `string` |

Voici le programme corrigé :

```csharp
Console.Write("Entrez un nombre : ");
string saisie = Console.ReadLine();
int nombre = Convert.ToInt32(saisie);

int resultat = nombre * 2;
Console.WriteLine($"{nombre} × 2 = {resultat}");
```

::: info Raccourci courant
On peut combiner les deux opérations en une seule ligne :
```csharp
int nombre = Convert.ToInt32(Console.ReadLine());
```
La saisie est convertie directement, sans variable intermédiaire. C'est la forme la plus utilisée en pratique.
:::

Remplacez maintenant le contenu de `Program.cs` par un programme plus utile — calculer l'âge approximatif d'une personne :

```csharp
Console.Write("Entrez votre année de naissance : ");
int anneeNaissance = Convert.ToInt32(Console.ReadLine());

int age = 2026 - anneeNaissance;
Console.WriteLine($"Vous avez environ {age} ans.");
```

Exécutez, entrez votre année de naissance, observez le résultat.

::: tip 📸 Capture 2
La console affichant votre âge calculé à partir de l'année de naissance saisie.
:::

::: tip Document de restitution — Question 2
Complétez la **Question 2** dans votre document.
:::

---

## Mission 3 — Quand la conversion échoue

### Tâche 3.1 — Provoquer volontairement une erreur

Relancez le programme de calcul d'âge. Cette fois, au lieu d'une année, tapez **des lettres** — par exemple `bonjour` — et appuyez sur Entrée.

Le programme s'arrête brutalement avec un message d'erreur :

```
Unhandled exception. System.FormatException: Input string was not in a correct format.
   at System.Number.ThrowFormatException[TChar](...)
   at System.Convert.ToInt32(String value)
   ...
```

::: tip 📸 Capture 3
Le message d'erreur `FormatException` affiché dans la console après avoir saisi du texte à la place d'un nombre.
:::

### Tâche 3.2 — Comprendre l'erreur

Ce type d'erreur s'appelle une **exception** — une erreur qui survient pendant l'**exécution** du programme (et non à la compilation, comme dans la tâche 2.1).

| Élément | Signification |
|---|---|
| `System.FormatException` | Le type de l'erreur : format de données incorrect |
| `Input string was not in a correct format` | Cause : `"bonjour"` ne peut pas être converti en entier |
| `at System.Convert.ToInt32` | L'endroit dans le code où l'erreur s'est produite |

::: warning La gestion des exceptions
Dans les programmes professionnels, on protège les conversions avec un bloc `try / catch` pour éviter que le programme plante. Vous apprendrez cette technique dans les prochains mois. Pour l'instant, **on suppose que l'utilisateur saisit toujours des données valides**.
:::

::: tip Document de restitution — Question 3
Complétez la **Question 3** dans votre document.
:::

---

## Mission 4 — Calculs avec des variables

### Tâche 4.1 — Calculer une surface

Construisez un programme qui calcule la **surface d'une pièce** rectangulaire. Ici on va utiliser `int` pour simplifier — les dimensions sont des nombres entiers de mètres :

```csharp
Console.WriteLine("=== Calculateur de surface ===");
Console.WriteLine();

Console.Write("Largeur de la pièce (en mètres entiers) : ");
int largeur = Convert.ToInt32(Console.ReadLine());

Console.Write("Longueur de la pièce (en mètres entiers) : ");
int longueur = Convert.ToInt32(Console.ReadLine());

int surface = largeur * longueur;

Console.WriteLine();
Console.WriteLine($"Surface de la pièce : {surface} m²");
```

::: info Console.WriteLine() sans argument
`Console.WriteLine()` sans texte affiche une **ligne vide** — utile pour aérer l'affichage dans la console.
:::

Testez avec la largeur `5` et la longueur `4` : vous devriez obtenir `20 m²`.

### Tâche 4.2 — Calculer avec double

Certains calculs donnent des résultats décimaux. Voici un convertisseur de température qui nécessite `double` :

```
Formule : °F = °C × 1,8 + 32
```

```csharp
Console.Write("Température en °C (entier) : ");
int celsius = Convert.ToInt32(Console.ReadLine());

double fahrenheit = celsius * 1.8 + 32;

Console.WriteLine($"{celsius}°C = {fahrenheit}°F");
```

Vérifiez avec des valeurs connues : `0°C = 32°F`, `100°C = 212°F`.

::: info Mélanger int et double
Quand C# calcule `celsius * 1.8`, il convertit automatiquement `celsius` (int) en double pour effectuer la multiplication. Le résultat est un `double`. Stocker ce résultat dans une variable `int` provoquerait une erreur — il faut bien déclarer `fahrenheit` en `double`.
:::

::: tip 📸 Capture 4
La console affichant le résultat du calculateur de surface **ou** du convertisseur de température — votre choix.
:::

::: tip Document de restitution — Question 4
Complétez la **Question 4** dans votre document.
:::

---

## Mission 5 — Exercices de consolidation

### Exercice 1 — Mini-calculatrice

Créez un programme qui :
1. Demande deux **nombres entiers** à l'utilisateur
2. Affiche le résultat de leurs cinq opérations arithmétiques

Exemple de résultat attendu (avec les nombres 15 et 4) :

```
=== Mini-calculatrice ===
Premier nombre  : 15
Deuxième nombre : 4

15 + 4  = 19
15 - 4  = 11
15 * 4  = 60
15 / 4  = 3   ← division entière
15 % 4  = 3   ← reste de la division
```

::: tip 📸 Capture 5
Votre mini-calculatrice en fonctionnement avec les nombres de votre choix.
:::

### Exercice 2 — Convertisseur km/miles

La formule de conversion est : `1 kilomètre = 0,621371 miles`

Créez un programme qui :
1. Demande une distance en **kilomètres** (nombre entier)
2. Calcule et affiche la distance équivalente en miles

Exemple de résultat attendu (avec 42 km) :

```
Distance en km    : 42
Distance en miles : 26,097582
```

::: tip 📸 Capture 6
Votre convertisseur km/miles en fonctionnement.
:::

### Exercice 3 — Calculateur d'IMC

L'**Indice de Masse Corporelle** se calcule avec la formule suivante :

```
IMC = poids (kg) ÷ taille² (m)
```

Créez un programme qui demande le poids en kg et la taille en **centimètres** (nombres entiers), puis calcule et affiche l'IMC.

Exemple de résultat attendu (avec 70 kg et 175 cm) :

```
Votre poids en kg : 70
Votre taille en cm : 175

Poids  : 70 kg
Taille : 1,75 m
IMC    : 22,857142857142858
```

::: info Attention à la conversion cm → m
Vous allez devoir diviser la taille en cm par 100 pour obtenir la taille en mètres. Pensez à ce que vous avez vu sur la division entière : `175 / 100` donne `1`, pas `1.75`. Réfléchissez à comment forcer un résultat décimal.
:::

::: tip 📸 Capture 7
Votre calculateur d'IMC avec vos propres valeurs.
:::

### Exercice 4 — Moyenne pondérée

En BTS, les notes sont souvent affectées d'un **coefficient**. Créez un programme qui calcule la moyenne pondérée entre une note de TP et une note d'examen.

Exemple de résultat attendu (TP : 16/20 coef 1 — Examen : 13/20 coef 2) :

```
=== Calculateur de moyenne pondérée ===

Note TP     : 16/20  (coefficient 1)
Note examen : 13/20  (coefficient 2)

Moyenne pondérée : 14/20
```

::: tip Aide au calcul
La formule est : `(noteTP × coefTP + noteExamen × coefExamen) ÷ (coefTP + coefExamen)`

Pour obtenir un résultat décimal, déclarez le résultat en `double` — C# se chargera de la conversion automatiquement.
:::

::: tip 📸 Capture 8
Votre calculateur de moyenne pondérée avec vos propres notes et coefficients.
:::

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les réponses aux 4 questions et les 8 captures d'écran demandées.
:::
