---
outline: deep
---

# TP bonus - Entraînement

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Initiation C#" />  <Badge type="danger" text="Visual Studio 2022 · C#" />

::: info Contexte
Ce TP n'apporte aucune notion nouvelle. Il sert à vous entraîner sur tout ce qui a été vu depuis le début de l'année : variables, conversions, conditions, boucles et fonctions. C'est en écrivant beaucoup de petits programmes que l'on progresse.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Les exercices sont classés par niveau : faites-les dans l'ordre et avancez à votre rythme, il n'est pas obligatoire de tout terminer. **Après chaque exercice, collez une capture d'écran de votre code dans le document de restitution**, à déposer sur Moodle au format **PDF** avant la fin de la séance.

📥 <a href="/tp-bonus-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: tip Conseils
- Créez un nouveau projet par exercice ou remplacez le contenu de `Program.cs` entre deux exercices.
- Si vous bloquez, relisez le TP correspondant avant de demander de l'aide.
- Testez chaque programme avec plusieurs valeurs, pas seulement celles de l'exemple.
:::

---

## Niveau 1 - Variables et calculs

### Exercice 1 - Partage de l'addition

Écrivez un programme qui demande le montant total d'une addition au restaurant et le nombre de personnes, puis affiche la part de chacun.

```
Montant de l'addition : 90
Nombre de personnes : 4
Chacun doit payer 22,5 euros.
```

### Exercice 2 - Convertisseur de durée

Écrivez un programme qui demande une durée en secondes et l'affiche en heures, minutes et secondes.

```
Durée en secondes : 3725
3725 secondes = 1 h 2 min 5 s
```

::: tip Division entière et modulo
Dans une heure il y a 3600 secondes. La division entière donne le nombre d'heures, le modulo `%` donne les secondes qui restent à répartir.
:::

---

## Niveau 2 - Conditions

### Exercice 3 - Tarif de cinéma

Écrivez un programme qui demande l'âge du spectateur et affiche le prix de sa place :

| Âge | Tarif |
|---|---|
| Moins de 12 ans | 5 euros |
| De 12 à 17 ans | 7 euros |
| De 18 à 64 ans | 10 euros |
| 65 ans et plus | 6 euros |

Un âge négatif affiche `Âge invalide.`

```
Votre âge : 15
Tarif : 7 euros
```

### Exercice 4 - Confirmation du mot de passe

Écrivez un programme qui demande un mot de passe, puis demande de le saisir une seconde fois. Il indique si les deux saisies sont identiques.

```
Choisissez un mot de passe : Colmar68
Confirmez le mot de passe : Colmar86
Les mots de passe ne correspondent pas.
```

```
Choisissez un mot de passe : Colmar68
Confirmez le mot de passe : Colmar68
Mot de passe enregistré.
```

---

## Niveau 3 - Boucles

### Exercice 5 - Code PIN

Le code secret d'une carte est `1234`. Écrivez un programme qui demande le code à l'utilisateur et lui laisse **trois essais au maximum**. Après trois erreurs, la carte est bloquée.

```
Entrez votre code : 1111
Code incorrect. Il vous reste 2 essai(s).
Entrez votre code : 4321
Code incorrect. Il vous reste 1 essai(s).
Entrez votre code : 1234
Code correct, bienvenue !
```

```
Entrez votre code : 1
Code incorrect. Il vous reste 2 essai(s).
Entrez votre code : 2
Code incorrect. Il vous reste 1 essai(s).
Entrez votre code : 3
Carte bloquée.
```

::: tip Deux raisons de s'arrêter
La boucle continue tant que le code est faux **et** qu'il reste des essais.
:::

### Exercice 6 - Rectangle d'étoiles

Écrivez un programme qui demande une largeur et une hauteur, puis dessine un rectangle d'étoiles.

```
Largeur : 8
Hauteur : 3
********
********
********
```

### Exercice 7 - La tirelire

Écrivez un programme qui demande le prix d'un objet et la somme mise de côté chaque semaine. Il affiche le contenu de la tirelire semaine après semaine, puis le nombre de semaines nécessaires pour pouvoir acheter l'objet.

```
Prix de l'objet : 100
Épargne par semaine : 15
Semaine 1 : 15 euros
Semaine 2 : 30 euros
Semaine 3 : 45 euros
Semaine 4 : 60 euros
Semaine 5 : 75 euros
Semaine 6 : 90 euros
Semaine 7 : 105 euros
Objectif atteint en 7 semaines !
```

---

## Niveau 4 - Fonctions

### Exercice 8 - Le plus grand

Écrivez une fonction `Maximum(int a, int b)` qui renvoie le plus grand des deux nombres. Utilisez-la dans `Main` pour afficher le plus grand de **trois** nombres saisis par l'utilisateur.

```
Premier nombre : 12
Deuxième nombre : 47
Troisième nombre : 31
Le plus grand est 47.
```

::: tip Réutiliser le résultat
Le résultat d'un appel peut servir d'argument à un autre appel : `Maximum(Maximum(a, b), c)`.
:::

### Exercice 9 - Lancer de dés

Écrivez une fonction `LancerDe()` qui renvoie un nombre au hasard entre 1 et 6. Dans `Main`, lancez deux dés en boucle jusqu'à obtenir un double, puis affichez le nombre de lancers.

```
Lancer 1 : 3 et 5
Lancer 2 : 6 et 2
Lancer 3 : 4 et 4
Double obtenu en 3 lancers !
```

::: tip Rappel
```csharp
Random rnd = new Random();
int valeur = rnd.Next(1, 7); // nombre entre 1 et 6 inclus
```
:::

---

## Défi final

### Exercice 10 - Le quiz

Écrivez une fonction `PoserQuestion(string question, string bonneReponse)` qui affiche la question, lit la réponse de l'utilisateur, indique si elle est juste et renvoie `true` ou `false`.

Dans `Main`, posez au moins cinq questions de votre choix, comptez les bonnes réponses et affichez le score final avec un commentaire adapté.

```
=== Quiz BTS SIO ===
Quel mot-clé permet de répéter un bloc tant qu'une condition est vraie ? while
Bonne réponse !
Quel type permet de stocker un nombre à virgule ? int
Mauvaise réponse. Il fallait répondre : double
...

Score final : 4 / 5
Très bien !
```

Pour aller plus loin : proposez de rejouer à la fin du quiz, ou ajoutez un système de vies qui arrête la partie après trois erreurs.

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance, avec une capture du code de chaque exercice réalisé.
:::
