---
outline: deep
---

# TP 6 - Les fonctions

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Initiation C#" />  <Badge type="danger" text="Visual Studio 2022 · C#" />

::: info Contexte
Jusqu'ici, tout votre code était écrit dans `Main`. Dès qu'un programme grossit, cela devient vite illisible et on se retrouve à copier-coller les mêmes lignes. Les **fonctions** permettent de découper un programme en petits blocs nommés, que l'on peut réutiliser autant de fois que nécessaire.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Vous devez remplir le **document de restitution** au fur et à mesure de la séance. Ce document est à déposer sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp6-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Déclarer une fonction** | Écrire le bloc de code et lui donner un nom |
| **Appeler une fonction** | Demander l'exécution de ce bloc depuis `Main` |
| **Paramètre** | Information transmise à la fonction pour qu'elle travaille |
| **Valeur de retour** | Résultat que la fonction renvoie avec `return` |
| **void** | Type d'une fonction qui ne renvoie rien |

---

## Mission 1 - Syntaxe et premiers tests

### Tâche 1.1 - Créer un nouveau projet

Créez un nouveau projet dans Visual Studio :

| Champ | Valeur |
|---|---|
| Type | Application console (C#) |
| Nom du projet | `Fonctions` |
| Emplacement | Le dossier à votre nom sur le disque D |
| Framework | .NET 8.0 |
| Case | ✅ N'utilisez pas d'instructions de niveau supérieur |

### Tâche 1.2 - Une première fonction

Une fonction se **déclare** une fois, puis s'**appelle** autant de fois que l'on veut. Remplacez le contenu de `Program.cs` par :

```csharp
namespace Fonctions
{
    internal class Program
    {
        static void AfficherBienvenue()
        {
            Console.WriteLine("==========================");
            Console.WriteLine("  Bienvenue en BTS SIO !");
            Console.WriteLine("==========================");
        }

        static void Main(string[] args)
        {
            AfficherBienvenue();
            Console.WriteLine("Début du programme...");
            AfficherBienvenue();
        }
    }
}
```

Exécutez : le cadre s'affiche deux fois alors qu'il n'est écrit qu'une seule fois dans le code.

::: warning Où écrire une fonction ?
Une fonction s'écrit **dans la classe `Program`**, mais **en dehors de `Main`** (au-dessus ou en dessous). Elle commence par le mot-clé `static`, comme `Main`.
:::

::: info Convention de nommage
Le nom d'une fonction commence par une **majuscule** et contient un **verbe** : `AfficherBienvenue`, `CalculerTotal`, `LireAge`.
:::

::: tip Document de restitution - Question 1
Complétez la **Question 1** dans votre document.
:::

### Tâche 1.3 - Les paramètres

Un **paramètre** est une variable que la fonction reçoit au moment de l'appel. Il se déclare entre les parenthèses, avec son type :

```csharp
static void Saluer(string prenom)
{
    Console.WriteLine($"Bonjour {prenom} !");
}

static void Main(string[] args)
{
    Saluer("Lucie");
    Saluer("Thomas");
}
```

Une fonction peut recevoir plusieurs paramètres, séparés par des virgules :

```csharp
static void AfficherLigne(string symbole, int longueur)
{
    for (int i = 0; i < longueur; i++)
    {
        Console.Write(symbole);
    }
    Console.WriteLine();
}

static void Main(string[] args)
{
    AfficherLigne("*", 10);
    AfficherLigne("-", 25);
}
```

L'ordre compte : la première valeur va dans `symbole`, la seconde dans `longueur`.

::: tip Document de restitution - Question 2
Complétez la **Question 2** dans votre document.
:::

### Tâche 1.4 - Renvoyer une valeur

Les fonctions précédentes affichent quelque chose mais ne renvoient rien : leur type est `void`. Une fonction peut aussi **calculer un résultat et le renvoyer** avec `return`. On remplace alors `void` par le type du résultat :

```csharp
static int Additionner(int a, int b)
{
    int resultat = a + b;
    return resultat;
}

static void Main(string[] args)
{
    int somme = Additionner(12, 30);
    Console.WriteLine($"12 + 30 = {somme}");

    Console.WriteLine($"5 + 8 = {Additionner(5, 8)}");
}
```

La valeur renvoyée peut être stockée dans une variable ou utilisée directement.

::: danger Afficher n'est pas renvoyer
`Console.WriteLine(resultat)` affiche la valeur à l'écran, mais le reste du programme ne peut pas la réutiliser. `return resultat` la transmet au code qui a appelé la fonction.
:::

::: tip Document de restitution - Question 3
Complétez la **Question 3** dans votre document.
:::

---

## Mission 2 - Exercices

::: info Conseils
- Vous pouvez créer un nouveau projet pour chaque exercice ou remplacer le contenu de `Program.cs` entre les exercices. **Avant de passer au suivant, faites une capture d'écran de votre code et collez-la dans le document de restitution.**
- Respectez le nom et les paramètres demandés pour chaque fonction.
- Dans `Main`, appelez toujours vos fonctions plusieurs fois avec des valeurs différentes pour les tester.
:::

### Exercice 1 - Titre encadré

Écrivez une fonction `AfficherTitre(string titre)` qui affiche le titre reçu entre deux lignes de séparation. Appelez-la trois fois dans `Main` avec des titres différents.

```
====================
Menu principal
====================
====================
Paramètres
====================
```

### Exercice 2 - Prix TTC

Écrivez une fonction `CalculerPrixTTC(double prixHT, double tauxTVA)` qui **renvoie** le prix TTC. Dans `Main`, demandez le prix HT et le taux à l'utilisateur, puis affichez le résultat.

```
Prix HT : 50
Taux de TVA (en %) : 20
Prix TTC : 60 euros
```

::: tip Aide au calcul
Prix TTC = prix HT + prix HT × taux ÷ 100. La fonction ne doit contenir aucun `Console.WriteLine` : c'est `Main` qui affiche.
:::

### Exercice 3 - Majeur ou mineur

Écrivez une fonction `EstMajeur(int age)` qui renvoie un `bool` : `true` si l'âge est supérieur ou égal à 18, `false` sinon. Utilisez-la dans un `if` dans `Main`.

```
Votre âge : 16
Accès refusé : vous êtes mineur.
```

```
Votre âge : 21
Accès autorisé.
```

::: tip Un bool dans une condition
Une fonction qui renvoie un `bool` s'utilise directement dans le `if` : `if (EstMajeur(age))`.
:::

::: tip Document de restitution - Question 4
Complétez la **Question 4** dans votre document.
:::

### Exercice 4 - Calculatrice à menu

Écrivez un programme qui affiche un menu, demande un choix puis deux nombres, et affiche le résultat de l'opération choisie. Le programme doit contenir au moins ces fonctions :

- `AfficherMenu()` : affiche le menu
- `Additionner`, `Soustraire`, `Multiplier` : reçoivent deux `int` et renvoient le résultat

```
=== Calculatrice ===
1 - Addition
2 - Soustraction
3 - Multiplication
Votre choix : 3
Premier nombre : 6
Deuxième nombre : 7
Résultat : 42
```

Si le choix n'est ni 1, ni 2, ni 3, le programme affiche `Choix invalide.`

### Bonus - Exercice 5 - Saisie contrôlée

Écrivez une fonction `LireNombreEntre(int min, int max)` qui demande un nombre à l'utilisateur et **recommence tant que** le nombre n'est pas compris entre `min` et `max`. Elle renvoie le nombre une fois qu'il est valide.

Utilisez-la dans `Main` pour demander une note sur 20, puis un mois de l'année.

```
Entrez un nombre entre 0 et 20 : 25
Entrez un nombre entre 0 et 20 : -3
Entrez un nombre entre 0 et 20 : 14
Note enregistrée : 14
Entrez un nombre entre 1 et 12 : 9
Mois enregistré : 9
```

::: tip Une fonction, deux usages
C'est tout l'intérêt des paramètres : la même fonction sert pour la note et pour le mois, sans rien réécrire.
:::

### Bonus - Exercice 6 - Pierre, feuille, ciseaux

Programmez une manche de pierre-feuille-ciseaux contre l'ordinateur, avec ces fonctions :

- `ChoisirOrdinateur()` : renvoie au hasard `"pierre"`, `"feuille"` ou `"ciseaux"`
- `DeterminerGagnant(string joueur, string ordinateur)` : renvoie `"joueur"`, `"ordinateur"` ou `"égalité"`

```
=== Pierre, feuille, ciseaux ===
Votre choix : feuille
L'ordinateur a choisi : pierre
Vous avez gagné !
```

::: tip Tirer un choix au hasard
```csharp
Random rnd = new Random();
int tirage = rnd.Next(1, 4); // 1, 2 ou 3
```
Il reste à transformer `tirage` en texte avec un `if / else if / else`. Pour aller plus loin, jouez la partie en trois manches gagnantes avec une boucle.
:::

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les réponses aux **4 questions** et les **6 captures de code**.
:::
