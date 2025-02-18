# Test unitaire en JavaScript 2

## Exercice 1 : Somme des nombres dans un tableau

### Objectif :
Créer une fonction qui calcule la somme de tous les nombres dʼun tableau.

### Cas à tester :
- ✅ Tableau avec plusieurs nombres positifs (ex. `[1, 2, 3]`).
- ✅ Tableau avec des nombres négatifs (ex. `[-1, -2, -3]`).
- ✅ Tableau vide (résultat attendu : `0`).
- ✅ Tableau mixte avec positifs et négatifs (ex. `[3, -1, 4, -2]`).

### Fonction à créer :
```javascript
function sommeTableau(tableau) {
    // Implémentation ici
}
```

---

## Exercice 2 : Trouver les nombres pairs

### Objectif :
Créer une fonction qui retourne le nombre de nombres pairs dans le tableau.

### Cas à tester :
- ✅ Tableau contenant uniquement des nombres pairs (ex. `[2, 4, 6]` retourne `3`).
- ✅ Tableau contenant uniquement des nombres impairs (ex. `[1, 3, 5]` retourne `0`).
- ✅ Tableau mixte avec pairs et impairs (ex. `[1, 2, 3, 4]` retourne `2`).
- ✅ Tableau vide (résultat attendu : `[]`).

### Fonction à créer :
```javascript
function nombresPairs(tableau) {
    // Implémentation ici
}
```

---

## Exercice 3 : Compter les occurrences dʼun élément

### Objectif :
Créer une fonction qui compte le nombre dʼoccurrences dʼun élément dans un tableau.

### Cas à tester :
- ✅ Tableau contenant plusieurs occurrences de lʼélément recherché (ex. `[1, 2, 2, 3, 2]`, élément : `2`).
- ✅ Tableau où lʼélément nʼapparaît pas (ex. `[1, 3, 4]`, élément : `2`).
- ✅ Tableau vide (résultat attendu : `0`).
- ✅ Tableau contenant une seule occurrence de lʼélément recherché (ex. `[5, 6, 7]`, élément : `7`).

### Fonction à créer :
```javascript
function compterOccurrences(tableau, element) {
    // Implémentation ici
}
```

---

## Exercice 4 : Trouver le minimum et le maximum dʼun tableau

### Objectif :
Créer une fonction qui retourne un objet contenant le minimum et le maximum dʼun tableau.

### Cas à tester :
- ✅ Tableau avec des nombres positifs (ex. `[1, 3, 5, 7]`).
- ✅ Tableau avec des nombres négatifs (ex. `[-5, -3, -1]`).
- ✅ Tableau mixte avec positifs et négatifs (ex. `[3, -1, 5, -7]`).
- ✅ Tableau contenant un seul élément (résultat attendu : le minimum et le maximum sont égaux).

### Fonction à créer :
```javascript
function trouverMinMax(tab) {
    // Implémentation ici
}