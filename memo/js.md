# 📌 Mémo JavaScript

## Les Bases

### Définition d'une variable
```javascript
let nom = "Thomas"; // Variable modifiable
const age = 25; // Constante (ne peut pas être réassignée)
```

### Condition (if / else)
```javascript
let x = 10;
if (x > 5) {
    console.log("x est supérieur à 5");
} else {
    console.log("x est inférieur ou égal à 5");
}
```

### Switch
```javascript
let jour = "lundi";
switch (jour) {
    case "lundi":
        console.log("Début de semaine !");
        break;
    case "vendredi":
        console.log("Bientôt le week-end !");
        break;
    default:
        console.log("Jour normal");
}
```

### Tableau
```javascript
let fruits = ["pomme", "banane", "cerise"];
console.log(fruits[1]); // Accède à "banane"
```

### Boucles (for / while)
```javascript{10}
// Boucle for
for (let i = 0; i < fruits.length; i++) {
    console.log(fruits[i]);
}

// Boucle while
let i = 0;
while (i < fruits.length) {
    console.log(fruits[i]);
    i++;
}
```

### Fonction
```javascript
function addition(a, b) {
    return a + b;
}
console.log(addition(5, 3)); // Retourne 8
```

---

## Manipulation du DOM

### `getElementById`
```javascript
let element = document.getElementById("monId");
console.log(element);
```

### `querySelector`
```javascript
let selectClass = document.querySelector(".maClasse");
let selectId = document.querySelector("#monId");
```

### `querySelectorAll`
```javascript
let elements = document.querySelectorAll("p");
```

### `classList.add()` / `classList.remove()`
```javascript
document.getElementById("monId").classList.add("active");
document.getElementById("monId").classList.remove("hidden");
```

### `innerText` / `innerHTML`
```javascript
document.getElementById("monId").innerText = "Texte mis à jour";
document.getElementById("monId").innerHTML = "<strong>Texte en gras</strong>";
```

---

## Interagir avec le DOM

### `addEventListener`
```javascript
document.getElementById("monBouton").addEventListener("click", function() {
    alert("Bouton cliqué !");
});
```
