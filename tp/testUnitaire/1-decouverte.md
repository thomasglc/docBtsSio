# Test unitaire en JavaScript

### Objectif
* Comprendre le principe des tests unitaires.
* Savoir écrire des fonctions basiques et des fonctions de test associées.
* Utiliser la console pour afficher les résultats des tests.

### Consignes
1. Créez deux fichiers JavaScript distincts :
    * `fonctions.js` : Ce fichier contiendra uniquement les fonctions à tester.
    * `tests.js` : Ce fichier contiendra uniquement les fonctions de test.
2. Créez une fonction pour chaque exercice en suivant les instructions, puis créez une fonction de test associée dans le fichier de tests.
3. Affichez les résultats des tests dans la console au format suivant :
    * `nomDuTest : Validé` si le test passe.
    * `nomDuTest : Refusé` si le test échoue.


## Exercice 1

### Objectif :
Créer une fonction qui additionne deux nombres et écrire un test unitaire pour vérifier son fonctionnement.

### Cas à tester :

1. Additionner deux nombres positifs (ex. 2 et 3).
2. Additionner un nombre positif et un nombre négatif (ex. 10 et -5).
3. Additionner deux nombres négatifs (ex. -3 et -7).
4. Additionner zéro avec un autre nombre (ex. 0 et 5).

### Fonctions à créer :

* `addition(a, b)` dans fonctions.js : retourne la somme de `a` et `b`.
* Créez autant de fonctions de tests que nécessaires pour couvrir les différents cas dans le fichier `tests.js`.

## Exercice 2

### Objectif :
Créer une fonction qui vérifie si une personne est majeure en fonction de son âge, avec plusieurs chemins possibles grâce à des conditions if/else.

### Cas à tester :

1. Une personne de plus de 18 ans (ex. 20).
2. Une personne de 18 ans (exactement).
3. Une personne de moins de 18 ans (ex. 16).
4. Une valeur non valide (ex. -1 ou un texte).


### Fonctions à créer :

* `estMajeur(age)` dans `fonctions.js` : retourne true si la personne est majeure, sinon false. Si l’âge est invalide, retourne une chaîne comme `"Âge invalide"`.
* Créez autant de fonctions de tests que nécessaires pour couvrir les différents cas

## Exercice 3

### Objectif :
Créer une fonction qui retourne le plus grand de deux nombres avec une structure conditionnelle.

### Cas à tester :

1. Les deux nombres sont différents (ex. 5 et 8).
2. Les deux nombres sont égaux (ex. 10 et 10).
3. Un nombre positif et un nombre négatif (ex. -3 et 7).
4. Les deux nombres sont négatifs (ex. -5 et -8).


### Fonctions à créer :

* `max(a, b)` dans `fonctions.js` : retourne le plus grand des deux nombres.
* Créez autant de fonctions de tests que nécessaires pour couvrir les différents cas dans le fichier `tests.js`.


## Exercice 4

### Objectif :
Créer une fonction qui attribue une mention en fonction de la note:

Note supérieur ou égale à 19 = Excellent

Note entre 15 et 19 = Très bien

Note entre 10 et 14 = Bien

Notre inférieur a 10 = Compétence non validé

et tester tous les chemins possibles définis par des conditions `if/else if/else`.

### Cas à tester :

1. Une note supérieur ou égal à 19 (mention "Excellent").
2. Une note entre 15 et 19 (mention "Très bien").
3. Une note entre 10 et 14 (mention "Bien").
4. Une note inférieur à 10 (mention "Compétence non validé").
5. Une valeur non valide (ex. note négatif ou supérieur à 20).

### Fonctions à créer :

* `attribuerMention(score)` dans `fonctions.js` : retourne une mention en fonction des seuils définis. Pour un score invalide, retourne `"Score invalide"`.
* Créez autant de fonctions de tests que nécessaires pour couvrir les différents cas dans le fichier `tests.js`.

## Exercice 5

### Objectif :

Créer une fonction qui vérifie si une personne a accès à un service en fonction de son rôle et de son statut d’abonnement, avec plusieurs chemins définis par des conditions if/else if/else.

### Cas à tester :

1. Une personne avec le rôle "admin" (accès toujours autorisé).
2. Une personne avec le rôle "utilisateur" et un abonnement actif (accès autorisé).
3. Une personne avec le rôle "utilisateur" sans abonnement actif (accès refusé).
4. Une personne avec un rôle inconnu (ex. "invité") ou des données invalides.

### Fonctions à créer :

* **`verifierAcces(role, abonnementActif)`** dans `fonctions.js` : retourne `true` ou `false` en fonction des conditions.
* Créez autant de fonctions de tests que nécessaires pour couvrir les différents cas dans le fichier `tests.js`.