# TP : Jest et tester le DOM

Après avoir découvert comment réaliser des tests unitaires grâce à `Jest`, nous allons aller un peu plus loin pour découvrir comment réaliser des tests unitaires avec le DOM.


Pour ce TP nous allons nous baser sur les fichiers suivants : 

::: code-group
```html  [index.html]
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manipulation du DOM</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Manipulation du DOM</h1>
        <button id="toggleText">Afficher/Cacher le texte</button>
        <button id="changeColor">Changer la couleur</button>
        <p id="texte" >Ceci est un texte que nous allons manipuler.</p>
    </div>
    <script src="changeTitle.js"></script>
    <script src="hidde.js"></script>
    <script src="toggle.js"></script>
</body>
</html>

```

```js [changeTitle.js] 
const titles = document.querySelectorAll('h1');
for(let i = 0; i < titles.length; i++){
    titles[i].style.backgroundColor = "purple";
}
```

```js [hidde.js]
const texte = document.getElementById("texte");

const toggleTextBtn = document.getElementById("toggleText");

toggleTextBtn.addEventListener("click", () => {
    if (texte.classList.contains("hidden")) {
        texte.classList.remove("hidden")
    } else {
        texte.classList.add("hidden");
    }
});
```

```js [toggle.js]
const changeColorBtn = document.getElementById("changeColor");
changeColorBtn.addEventListener("click", () => {
    texte.classList.toggle("red");
});

```

```css [style.css]
.container {
    text-align: center;
    margin-top: 50px;
}

.texte {
    font-size: 18px;
}

.hidden {
    display: none;
}

.red {
    color: red;
}

```
:::

Votre page doit ressembler à l'image ci-dessous : 
![image](https://github.com/user-attachments/assets/bb21398a-2fad-4775-810b-806947543891)


::: tip
Créez-vous un nouveau dossier dans lequel vous allez copier les différents fichiers. 
Cela vous permettra d'installer Jest au sein du projet.
N'oubliez pas d'initialiser `Jest` dans le dossier
```bash
npm install jest
```
:::

::: danger Attention
Pour pouvoir tester des éléments du dom avec Jest, vous devez faire quelques petites manipulations.
Dans un premier temps, il faut télécharger `jest-environment-jsdom` :
```bash
npm i jest-environment-jsdom
```

Ensuite, vous devez effectuer une petite modification dans votre fichier `package.json` :
```json
{
    "scripts": {
        "test": "jest --env=jsdom"
    }
}
```
:::

## Exercice 1 : Vérification du code `changeTitle.js`
### Objectif : 
Vérifier que l'éxecution du code écrit dans `changeTitle.js` permet d'ajouter le background color à toutes les balises `<h1>` présente dans la page html.

### Cas à tester :
- ✅ Vérifier que la balise `<h1>` n'est pas modifiée si le script js n'est pas exécuté. 
- ✅ La balise `<h1>` du titre à bien un background color à `purple` après l'éxécution du script
- ✅ Tous les `<h1>` présents dans la page ont une background color : vérifiez que chaque élément `<h1>` a bien la propriété CSS background-color définie après l'exécution du script.
- ✅ Le script ne doit affecter que les balises `<h1>` : vérifiez que d’autres balises comme `<h2>`, `<p>`, etc..., ne sont pas modifiées.

::: tip
Si vous utilisez plusieurs fois la fonction `require('');` dans vos tests, il faut intégrer le code suivant qui va permettre de remettre à zéro l'intégration du fichier js
```javascript
beforeEach(() => {
  jest.resetModules();
});
```

:::

## Exercice 2 : Vérfication du bouton "Afficher / cacher"
### Objectif : 
Créer un ensemble de tests qui permet de vérifier que le fonctionnement du bouton `"Afficher / Cacher"` est cohérent avec notre attente.

### Cas à tester : 
- ✅ Le texte est masqué après un clic sur le bouton : vérifiez que la classe hidden est ajoutée à l’élément texte
- ✅ Le texte est visible après un clic sur le bouton : vérifiez que la classe hidden est retirée si le texte possède initialement la class.
- ✅ La class est identique après deux clics supplémentaires (revenir à l’état initial).


## Exercice 3 : Changement de couleur
### Objectif : 
Créer un ensemble de tests qui permet de vérifier que le fonctionnement du bouton `"Changer la couleur"` est cohérent avec notre attente.

### Cas à tester : 
- ✅ Ajout de la classe `.red` au clic sur le bouton : vérifiez que l’élément texte contient la classe red après un clic sur le bouton changeColor.
- ✅ Suppression de la classe `.red` au second clic : vérifiez que la classe red est retirée si elle est déjà présente, retournant ainsi l’élément à son état initial.
- ✅ Aucun changement si le bouton n’est jamais cliqué : vérifiez que la classe red n’est pas présente sur l’élément texte sans interaction utilisateur.
- ✅ Le bouton fonctionne même après plusieurs clics successifs : la classe red doit apparaître et disparaître correctement à chaque clic (test de l’alternance).
