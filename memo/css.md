# 📌 Mémo CSS

## Intégrer du CSS dans une page HTML

Pour intégrer du CSS dans une page HTML il faut ajouter la balise <br>`<link rel="stylesheet" href="">` 

```html
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="style.css">
    <title>Titre de la page</title>
</head>
```

## Sélection par classe

Les classes sont définies avec le sélecteur `.` :

```css
.ma-classe {
    color: blue;
}
```

```html
<p class="ma-classe">Texte en bleu</p>

```
## Sélection par ID

Les id sont définies avec le sélecteur `#` :

```css
#mon-id {
    color: red;
}
```

```html
<p id="mon-id">Texte en rouge</p>
```


## Police et taille de texte

Pour changer la police et la taille :

```css
body {
    font-family: Arial, sans-serif;
    font-size: 16px;
}
```

## Couleur du texte et du fond

- **Texte** : `color`
- **Fond** : `background-color`

```css
p {
    color: black;
    background-color: lightgray;
}
```

## Margin, Padding et Border

- **Margin** : espace autour de l'élément.
- **Padding** : espace entre le contenu et la bordure.
- **Border** : bordure autour de l'élément.

```css
div {
    margin: 20px;
    padding: 10px;
    border: 2px solid black;
}
```

## Flexbox

- **flex-direction** : disposition des éléments (row/column)
- **justify-content** : alignement horizontal

```css
.container {
    display: flex;
    flex-direction: row;
    justify-content: center;
}
```

## Grille CSS

Pour organiser des éléments en grille :

```css
.grid-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
}
```

```css
.une {
    grid-column-start: 1;
    grid-column-end: 3;
}
```