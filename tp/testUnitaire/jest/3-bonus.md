# TP : Tests unitaires avancés en JavaScript

## Objectif :

Développer plusieurs fonctions JavaScript et écrire des tests unitaires avec **Jest** pour valider leur bon fonctionnement.

---

## 📋 Exercice 1 : Calculer la moyenne d’un tableau

**Objectif :**

Créer une fonction `calculerMoyenne` qui retourne la moyenne des nombres dans un tableau.

**Cas à tester :**

- ✅ Tableau avec plusieurs nombres positifs (ex. `[10, 20, 30]` → 20).
- ✅ Tableau avec des nombres négatifs (ex. `[-10, -20, -30]` → -20).
- ✅ Tableau mixte avec positifs et négatifs (ex. `[10, -10, 20, -20]` → 0).
- ✅ Tableau avec un seul élément (la moyenne est l’élément lui-même).
- ✅ Tableau vide (résultat attendu : `null`).

**Fonction à créer :**

```jsx
function calculerMoyenne(tableau) {
  // Implémentation ici
}
```

---

## 📋 Exercice 2 : Trouver les mots les plus longs d’une phrase

**Objectif :**

Créer une fonction  `motLePlusLong` qui prend une chaîne de caractères (phrase) et retourne un tableau des mots les plus longs.

**Cas à tester :**

- ✅ Phrase avec des mots de différentes longueurs :  
  `"Bonjour à tous les développeurs"` → `["développeurs"]`.

- ✅ Phrase avec plusieurs mots de même longueur maximale :  
  `"Je code et je danse"` → `["code", "danse"]`.

- ✅ Phrase avec un seul mot :  
  `"AvadaKedavra"` → `["AvadaKedavra"]`.

- ✅ Phrase vide (résultat attendu : `[]`).

**Fonction à créer :**

```jsx
function motsLesPlusLongs(phrase) {
  // Implémentation ici
}
```

---

## 📋 Exercice 3 : Vérifier si un tableau est trié

**Objectif :**

Créer une fonction `estTrie` qui vérifie si un tableau est trié en ordre croissant.

**Cas à tester :**

- ✅ Tableau trié (`[1, 2, 3, 4]` → `true`).
- ✅ Tableau non trié (`[4, 2, 3, 1]` → `false`).
- ✅ Tableau avec des éléments égaux (`[1, 1, 2, 2, 3, 3]` → `true`).
- ✅ Tableau avec un seul élément (`[5]` → `true`).
- ✅ Tableau vide (résultat attendu : `true`).

**Fonction à créer :**

```jsx
function estTrie(tableau) {
  // Implémentation ici
}
```

---

## 📋 Exercice 4 : Trouver le second plus grand nombre

**Objectif :**

Créer une fonction `secondPlusGrand` qui retourne le second plus grand nombre d’un tableau.

**Cas à tester :**

- ✅ Tableau avec plusieurs nombres différents (`[1, 3, 5, 7]` → `5`).
- ✅ Tableau avec des nombres égaux (`[1, 1, 1, 1]` → `null`).
- ✅ Tableau avec un seul élément (résultat attendu : `null`).
- ✅ Tableau vide (résultat attendu : `null`).

**Fonction à créer :**

```jsx
function secondPlusGrand(tableau) {
  // Implémentation ici
}
```