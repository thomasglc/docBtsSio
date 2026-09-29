---
outline: deep
---

# TP 5 - Les boucles

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Initiation C#" />  <Badge type="danger" text="Visual Studio 2022 · C#" />

::: info Contexte
Les conditions permettent d'exécuter un bloc de code sous certaines conditions. Les **boucles** permettent de le répéter. C'est l'un des mécanismes les plus utilisés en programmation : afficher une liste, calculer une somme, parcourir des données... tout cela repose sur des boucles.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Vous devez remplir le **document de restitution** au fur et à mesure de la séance. Ce document est à déposer sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp5-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **while** | Répète un bloc tant qu'une condition est vraie |
| **for** | Répète un bloc un nombre de fois déterminé à l'avance |
| **Compteur** | Variable qui évolue à chaque itération pour contrôler la boucle |
| **Condition d'arrêt** | La condition qui met fin à la boucle |

---

## Mission 1 - Syntaxe et premiers tests

### Tâche 1.1 - Créer un nouveau projet

Créez un nouveau projet dans Visual Studio :

| Champ | Valeur |
|---|---|
| Type | Application console (C#) |
| Nom du projet | `Boucles` |
| Emplacement | Le dossier à votre nom sur le disque D |
| Framework | .NET 8.0 |
| Case | ✅ N'utilisez pas d'instructions de niveau supérieur |

### Tâche 1.2 - La boucle while

La boucle `while` répète un bloc de code **tant qu'une condition est vraie** :

```csharp
while (condition)
{
    // code répété à chaque itération
}
```

Testez ce programme qui affiche les nombres de 1 à 10 :

```csharp
int i = 1;
while (i <= 10)
{
    Console.WriteLine(i);
    i++;
}
```

`i++` est un raccourci pour `i = i + 1`. À chaque passage dans la boucle, le compteur augmente d'une unité. Quand `i` atteint 11, la condition `i <= 10` devient fausse et la boucle s'arrête.

::: danger Boucle infinie
Si vous oubliez d'incrémenter `i`, la condition ne devient jamais fausse et le programme tourne indéfiniment. Pour stopper une boucle infinie dans la console : **Ctrl + C**.
:::

::: tip Document de restitution - Question 1
Complétez la **Question 1** dans votre document.
:::

### Tâche 1.3 - La boucle for

La boucle `for` est conçue pour les cas où le nombre d'itérations est connu à l'avance. Les trois étapes (initialisation, condition, incrément) sont regroupées sur une seule ligne :

```csharp
for (initialisation; condition; incrément)
{
    // code répété à chaque itération
}
```

Le même affichage de 1 à 10 avec `for` :

```csharp
for (int i = 1; i <= 10; i++)
{
    Console.WriteLine(i);
}
```

::: info Les trois parties du for
1. `int i = 1` : exécuté **une seule fois** au démarrage
2. `i <= 10` : vérifié **avant chaque** itération, la boucle s'arrête quand c'est faux
3. `i++` : exécuté **après chaque** itération
:::

Testez maintenant une table de multiplication avec `for`. Remplacez le contenu de `Main` :

```csharp
Console.Write("Quelle table souhaitez-vous afficher ? ");
int n = Convert.ToInt32(Console.ReadLine());

Console.WriteLine($"\nTable de {n} :");
for (int i = 1; i <= 10; i++)
{
    Console.WriteLine($"{n} x {i} = {n * i}");
}
```

::: tip Document de restitution - Question 2
Complétez la **Question 2** dans votre document.
:::

### Tâche 1.4 - Accumuler une valeur

Une boucle peut aussi servir à **construire un résultat progressivement**. Voici comment calculer la somme des entiers de 1 à 10 :

```csharp
int somme = 0;
int i = 1;

while (i <= 10)
{
    somme = somme + i;
    i++;
}

Console.WriteLine($"Somme de 1 à 10 : {somme}");
```

La variable `somme` est initialisée à 0 avant la boucle, puis augmentée à chaque passage. Tracez mentalement les valeurs de `i` et `somme` itération par itération.

::: tip Document de restitution - Question 3
Complétez la **Question 3** dans votre document.
:::

---

## Mission 2 - Exercices

::: info Conseils
- Vous pouvez créer un nouveau projet pour chaque exercice ou remplacer le contenu de `Main` entre les exercices. **Avant de passer au suivant, faites une capture d'écran de votre code et collez-la dans le document de restitution.**
- Choisissez `while` ou `for` selon ce qui vous semble le plus adapté, sauf si l'énoncé précise lequel utiliser.
- Testez toujours avec plusieurs valeurs, y compris les cas limites.
:::

### Exercice 1 - Compte à rebours

Écrivez un programme qui demande un nombre entier N et affiche un compte à rebours de N jusqu'à 1, puis affiche `"Décollage !"`.

```
Entrez un nombre : 5
5
4
3
2
1
Décollage !
```

### Exercice 2 - Table de multiplication

Écrivez un programme qui demande un entier N et affiche sa table de multiplication de 1 à 10.

```
Table de 7 :
7 x 1  = 7
7 x 2  = 14
7 x 3  = 21
...
7 x 10 = 70
```

::: tip Document de restitution - Question 4
Complétez la **Question 4** dans votre document.
:::

### Exercice 3 - FizzBuzz

Affichez tous les nombres de 1 à 30, mais en remplaçant :
- les multiples de 3 par `Fizz`
- les multiples de 5 par `Buzz`
- les multiples des deux par `FizzBuzz`

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
...
```

::: tip Ordre des conditions
Pensez à tester `FizzBuzz` en premier. Si vous testez divisible par 3 en premier et que vous affichez `Fizz`, vous ne pourrez plus afficher `FizzBuzz` pour les multiples communs.
:::

### Exercice 4 - Pyramide d'étoiles

Écrivez un programme qui demande une hauteur H et affiche une pyramide d'étoiles de H lignes.

```
Hauteur : 5
*
**
***
****
*****
```

::: tip Construire une ligne avec une boucle
Pour afficher plusieurs étoiles sur une même ligne sans retour à la ligne, utilisez `Console.Write("*")` à l'intérieur d'une première boucle, puis `Console.WriteLine()` pour passer à la ligne suivante.
:::

### Exercice 5 - Calculateur de moyenne

Écrivez un programme qui demande des notes à l'utilisateur une par une, jusqu'à ce qu'il saisisse `-1` pour terminer. Le programme affiche ensuite la moyenne.

```
Entrez une note (-1 pour terminer) : 14
Entrez une note (-1 pour terminer) : 16
Entrez une note (-1 pour terminer) : 9
Entrez une note (-1 pour terminer) : 12
Entrez une note (-1 pour terminer) : -1

4 notes saisies.
Moyenne : 12,75
```

::: tip La valeur sentinelle
Le `-1` est ce qu'on appelle une **valeur sentinelle** : une valeur spéciale qui signale la fin de la saisie. Ce pattern est très courant. La boucle doit continuer `while (note != -1)` - mais attention, vous devez lire la première note *avant* d'entrer dans la boucle.
:::

### Exercice 6 - Le juste prix

Écrivez un programme qui tire un nombre secret au hasard entre 1 et 100, puis invite l'utilisateur à le deviner. Après chaque tentative, le programme indique si le nombre à trouver est plus grand ou plus petit. La boucle s'arrête quand le joueur trouve la bonne réponse.

```
=== Le Juste Prix ===
Devinez le nombre (entre 1 et 100) : 50
Trop petit !
Devinez le nombre (entre 1 et 100) : 75
Trop grand !
Devinez le nombre (entre 1 et 100) : 63
Trop petit !
Devinez le nombre (entre 1 et 100) : 70
Bravo ! Trouvé en 4 tentatives.
```

::: tip Générer un nombre aléatoire
```csharp
Random rnd = new Random();
int secret = rnd.Next(1, 101); // nombre entre 1 et 100 inclus
```
Déclarez `secret` avant la boucle. La boucle tourne `while (proposition != secret)`.
:::

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les réponses aux **4 questions** et les **6 captures de code**.
:::
