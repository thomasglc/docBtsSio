---
outline: deep
---

# TP 4 - Les conditions

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Initiation C#" />  <Badge type="danger" text="Visual Studio 2022 · C#" />

::: info Contexte
Jusqu'à présent, vos programmes s'exécutaient toujours de la même façon, ligne par ligne. Les **structures conditionnelles** permettent d'exécuter un bloc de code **seulement si une condition est vraie**. C'est ce mécanisme qui donne de l'intelligence à un programme.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Vous devez remplir le **document de restitution** au fur et à mesure de la séance. Ce document est à déposer sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp4-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Exemple |
|---|---|
| **if / else** | Exécuter du code selon une condition |
| **else if** | Enchaîner plusieurs alternatives |
| **Opérateurs de comparaison** | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| **Opérateurs logiques** | `&&` (ET), `\|\|` (OU), `!` (NON) |

---

## Mission 1 - Syntaxe et premiers tests

### Tâche 1.1 - Créer un nouveau projet

Créez un nouveau projet dans Visual Studio :

| Champ | Valeur |
|---|---|
| Type | Application console (C#) |
| Nom du projet | `Conditions` |
| Emplacement | Le dossier à votre nom sur le disque D |
| Framework | .NET 8.0 |
| Case | ✅ N'utilisez pas d'instructions de niveau supérieur |

### Tâche 1.2 - Structure d'un if / else

```csharp
if (condition)
{
    // code exécuté si la condition est vraie
}
else
{
    // code exécuté si la condition est fausse
}
```

Les **opérateurs de comparaison** disponibles :

| Opérateur | Signification | Exemple |
|---|---|---|
| `==` | Égal à | `age == 18` |
| `!=` | Différent de | `note != 0` |
| `<` | Inférieur strict | `age < 18` |
| `>` | Supérieur strict | `note > 10` |
| `<=` | Inférieur ou égal | `age <= 17` |
| `>=` | Supérieur ou égal | `note >= 10` |

::: danger Attention : `=` vs `==`
`=` est l'**affectation** : `int x = 5;` stocke la valeur 5.  
`==` est la **comparaison** : `x == 5` teste si x vaut 5.  
Écrire `if (x = 5)` est une erreur classique que le compilateur C# refuse dès la compilation.
:::

### Tâche 1.3 - Premier test : pair ou impair

Testez ce programme pour comprendre le fonctionnement avant de passer aux exercices :

```csharp
Console.Write("Entrez un nombre entier : ");
int nombre = Convert.ToInt32(Console.ReadLine());

if (nombre % 2 == 0)
{
    Console.WriteLine($"{nombre} est pair.");
}
else
{
    Console.WriteLine($"{nombre} est impair.");
}
```

L'opérateur `%` (modulo) donne le **reste de la division entière**. Si `nombre % 2 == 0`, le reste est nul : le nombre est pair.

Testez avec plusieurs valeurs : `4`, `7`, `0`, `-3`.

::: tip Document de restitution - Question 1
Complétez la **Question 1** dans votre document.
:::

### Tâche 1.4 - Enchaîner les alternatives : else if

Quand il y a plus de deux cas, on utilise `else if` :

```csharp
Console.Write("Entrez un nombre : ");
int n = Convert.ToInt32(Console.ReadLine());

if (n > 0)
{
    Console.WriteLine("Positif");
}
else if (n < 0)
{
    Console.WriteLine("Négatif");
}
else
{
    Console.WriteLine("Zéro");
}
```

C# évalue les conditions **de haut en bas** et s'arrête dès que la première condition vraie est rencontrée.

::: tip Document de restitution - Question 2
Complétez la **Question 2** dans votre document.
:::

### Tâche 1.5 - Combiner des conditions : opérateurs logiques

| Opérateur | Signification | Exemple |
|---|---|---|
| `&&` | ET : les **deux** conditions doivent être vraies | `age >= 0 && age <= 120` |
| `\|\|` | OU : **au moins une** condition doit être vraie | `note < 0 \|\| note > 20` |
| `!` | NON : inverse le résultat de la condition | `!estValide` |

```csharp
Console.Write("Entrez votre âge : ");
int age = Convert.ToInt32(Console.ReadLine());

if (age >= 0 && age <= 120)
{
    Console.WriteLine("Âge valide.");
}
else
{
    Console.WriteLine("Âge invalide.");
}
```

::: tip Document de restitution - Question 3
Complétez la **Question 3** dans votre document.
:::

---

## Mission 2 - Exercices

À partir d'ici, vous travaillez en autonomie. Chaque exercice indique ce que le programme doit faire et un exemple de résultat attendu.

::: info Conseils
- Vous pouvez créer un nouveau projet pour chaque exercice ou remplacer le contenu de `Main` entre les exercices. **Avant de passer au suivant, faites une capture d'écran de votre code et collez-la dans le document de restitution.**
- Testez toujours avec plusieurs valeurs, notamment les **cas limites** (0, valeurs négatives, valeurs exactement sur les bornes...).
:::

### Exercice 1 - Signe d'un nombre

Écrivez un programme qui demande un nombre entier et affiche s'il est positif, négatif ou nul.

```
Entrez un nombre : -7
-7 est négatif.
```

### Exercice 2 - Dans un intervalle

Écrivez un programme qui demande un nombre entier et indique s'il se trouve dans l'intervalle **[1 ; 100]** (bornes incluses).

```
Entrez un nombre : 42
42 est dans l'intervalle [1 ; 100].
```

```
Entrez un nombre : 150
150 est hors de l'intervalle [1 ; 100].
```

### Exercice 3 - Validation d'âge

Écrivez un programme qui demande un âge et affiche un message selon la catégorie :

| Condition | Message |
|---|---|
| Âge < 0 ou > 120 | `Âge invalide.` |
| Âge < 18 | `Mineur.` |
| Âge < 65 | `Majeur.` |
| Sinon | `Senior.` |

::: tip Ordre des conditions
Réfléchissez à l'ordre dans lequel vous placez vos `if / else if`. Quand une condition est atteinte, les suivantes sont ignorées, ce qui peut simplifier vos expressions.
:::

### Exercice 4 - Validation d'une note

Écrivez un programme qui demande une note entière et affiche la **mention** correspondante :

| Note | Mention |
|---|---|
| < 0 ou > 20 | `Note invalide` |
| < 10 | `Insuffisant` |
| < 12 | `Passable` |
| < 14 | `Assez bien` |
| < 16 | `Bien` |
| ≥ 16 | `Très bien` |

```
Entrez votre note : 14
Mention : Bien
```

::: tip Document de restitution - Question 4
Complétez la **Question 4** dans votre document.
:::

### Bonus - Exercice 5 - Année bissextile

Une année est **bissextile** si elle est divisible par 4 et pas par 100, **ou** si elle est divisible par 400.

Écrivez un programme qui demande une année et indique si elle est bissextile.

```
Entrez une année : 2024
2024 est une année bissextile.
```

```
Entrez une année : 1900
1900 n'est pas une année bissextile.
```

::: tip Décomposez la règle
La règle comporte deux cas reliés par `||`. Chaque cas peut lui-même nécessiter `&&`. Écrivez la condition en suivant directement la règle mathématique.
:::

### Bonus - Exercice 6 - Mini-simulateur de caisse

Écrivez un programme qui :
1. Demande le montant d'un achat (décimal)
2. Demande le montant remis par le client
3. Vérifie que le montant remis est suffisant
4. Si oui, affiche la monnaie à rendre ; si non, affiche le montant manquant

```
Montant de l'achat : 12,50
Montant remis     : 20
Monnaie à rendre  : 7,50 €
```

```
Montant de l'achat : 12,50
Montant remis     : 10
Montant insuffisant. Il manque 2,50 €.
```

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les réponses aux **4 questions** et les **6 captures de code**.
:::
