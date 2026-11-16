---
outline: deep
---

# TP 7 - Le modèle de boîte

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · CSS · Inspecteur" />

::: info Contexte
Le site a pris les couleurs de la médiathèque, mais tout est serré : les animations de l'agenda se suivent sans séparation, et les champs du formulaire d'inscription sont petits et mal alignés. Aujourd'hui, vous réglez les **espaces** et les **dimensions** des éléments grâce au **modèle de boîte**.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 6. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp7-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: details Je n'ai plus mon dossier du TP 6
Téléchargez le dossier de départ, décompressez-le sur le disque D, puis ouvrez le dossier `mediatheque` dans VS Code :

📥 <a href="/tp/html/mediatheque-depart-tp7.zip" download style="font-weight:600">Télécharger le dossier de départ</a>

La page `coups-de-coeur/mon-coup-de-coeur.html` contient seulement un modèle : remplacez les textes par votre œuvre, quelques lignes suffisent.
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Le modèle de boîte** | Chaque élément est une boîte : contenu, `padding`, `border` et `margin` |
| **L'inspecteur** | Voir les boîtes d'une page et mesurer leurs espaces |
| **Les dimensions** | `width`, `height`, `max-width` et `box-sizing` |
| **Bloc ou en ligne** | La propriété `display` |

Aujourd'hui, seul `style.css` change : le HTML est déjà prêt.

---

## Mission 1 - Voir les boîtes

Pour le navigateur, chaque élément de la page est une **boîte** rectangulaire, faite de quatre couches :

![Le modèle de boîte : le contenu au centre, entouré du padding, puis de la bordure, puis de la margin](/tp/html/tp7-modele-boite.svg)

| Couche | Propriété CSS | Couleur dans l'inspecteur |
|---|---|---|
| Le **contenu** : texte, image… | `width` et `height` | Bleu |
| La **marge intérieure**, entre le contenu et la bordure | `padding` | Vert |
| La **bordure** | `border` | Jaune |
| La **marge extérieure**, qui écarte la boîte de ses voisines | `margin` | Orange |

### Tâche 1.1 - Ouvrir l'inspecteur

Ouvrez `agenda.html` dans Chrome ou Edge. Faites un **clic droit** sur le titre `Club manga`, puis **Inspecter** : l'inspecteur s'ouvre, avec la ligne `<h2>` sélectionnée.

### Tâche 1.2 - Observer les boîtes

1. Dans l'inspecteur, survolez la ligne `<h2>` : dans la page, une zone **orange** apparaît au-dessus et au-dessous du titre. C'est sa `margin`, mise par le navigateur.
2. Dans la colonne de droite, ouvrez l'onglet **Calculé** : le schéma des quatre couches s'affiche, avec leurs valeurs en pixels.
3. Survolez la ligne `<body>` : une fine bande orange entoure toute la page. Combien de pixels mesure-t-elle ?
4. Survolez un `<p>`, puis le `<strong>` qu'il contient : lequel prend toute la largeur de la page ?

---

## Mission 2 - Les animations en cartes

### Tâche 2.1 - Une carte par animation

À la fin de `style.css`, ajoutez cette règle **ligne par ligne**, en actualisant la page de l'agenda à chaque fois :

```css
article {
    background-color: white;
    border: 2px solid #3748A0;
    padding: 20px;
    margin-bottom: 24px;
}
```

| Ligne | Ce qui change à l'écran |
|---|---|
| `background-color: white;` | Un fond blanc : le texte touche les bords |
| `border: 2px solid #3748A0;` | Une bordure : son **épaisseur**, son **style** et sa **couleur** |
| `padding: 20px;` | De l'espace **à l'intérieur**, entre le texte et la bordure |
| `margin-bottom: 24px;` | De l'espace **à l'extérieur**, sous chaque carte |

::: info Un côté ou les quatre
`padding: 20px;` règle les quatre côtés d'un coup. `margin-bottom` ne règle que le bas : il existe aussi `-top`, `-left` et `-right`, pour `margin` comme pour `padding`.
:::

Voici le résultat attendu :

![L'agenda en cartes : chaque animation dans un cadre blanc à bordure bleue, séparé de la suivante](/tp/html/tp7-agenda.png)

::: tip 📸 Capture 1
Faites une capture de l'agenda en cartes.
:::

### Tâche 2.2 - Vérifier avec l'inspecteur

Faites un clic droit dans une carte, puis **Inspecter**, et sélectionnez la ligne `<article>`. Dans l'onglet **Calculé**, retrouvez vos valeurs : `20` pour le padding, `2` pour la bordure, `24` pour la margin du bas.

::: tip 📸 Capture 2
Faites une capture du schéma des quatre couches d'une carte, dans l'inspecteur.
:::

::: info Relisez les règles du TP 4
Au TP 4, vous avez copié `padding: 6px 12px;` pour les cellules des tableaux. Avec **deux valeurs**, la première vaut pour le haut et le bas, la seconde pour la gauche et la droite.
:::

::: tip Document de restitution - Question 1
Complétez la **Question 1** : quelle différence entre `padding` et `margin` ?
:::

---

## Mission 3 - Un formulaire bien rangé

### Tâche 3.1 - Le cadre du formulaire

```css
form {
    max-width: 500px;
    background-color: white;
    border: 1px solid #C8CCD4;
    padding: 20px;
}
```

`max-width: 500px;` : le formulaire mesure **au plus** 500 pixels de large. Sur un écran plus étroit, il rétrécit. Regardez aussi le catalogue : le formulaire d'avis a reçu le même cadre.

### Tâche 3.2 - Les étiquettes au-dessus des champs

Il existe deux grandes sortes de boîtes :

| | En **bloc** | En **ligne** |
|---|---|---|
| Place | Commence sur une nouvelle ligne et prend **toute la largeur** | Reste dans la ligne et prend **la place de son contenu** |
| Exemples | `<p>`, `<h1>`, `<section>`, `<article>`, `<form>`, `<div>` | `<a>`, `<strong>`, `<span>`, `<img>`, `<label>`, `<input>` |

`<label>` est en ligne : son champ se place juste à côté. La propriété `display` change cela :

```css
label {
    display: block;
    margin-bottom: 6px;
}
```

Chaque étiquette passe sur sa propre ligne, au-dessus de son champ.

::: tip Document de restitution - Question 2
Complétez la **Question 2** : bloc ou en ligne ?
:::

### Tâche 3.3 - Des champs à la largeur du cadre

Ajoutez cette règle, puis actualisez la page d'inscription :

```css
input, select, textarea {
    width: 100%;
    padding: 10px;
}
```

Regardez bien le bord droit du cadre, et la case à cocher :

![Les champs dépassent du cadre du formulaire à droite, et la case à cocher se retrouve au milieu de la ligne](/tp/html/tp7-debordement.png)

Deux problèmes :

1. **Les champs dépassent du cadre.** `width: 100%` donne au **contenu** toute la largeur du cadre, puis le navigateur ajoute le padding et la bordure **en plus** : 500 + 10 + 10 + 2 + 2 = 524 pixels. Ajoutez cette ligne à la règle :

   ```css
   box-sizing: border-box;
   ```

   Avec `border-box`, `width` compte **tout** : le contenu, le padding et la bordure. Le champ mesure 500 pixels, pas un de plus.

2. **La case à cocher est partie au milieu.** C'est un `<input>` : elle aussi mesure 100 % ! Rendez-lui sa largeur normale grâce à son identifiant, qui l'emporte sur la balise, comme au TP 6 :

   ```css
   #newsletter {
       width: auto;
   }
   ```

::: tip Document de restitution - Question 3
Complétez la **Question 3** : pourquoi les champs dépassaient-ils ?
:::

### Tâche 3.4 - Le commentaire et les boutons

- Le commentaire du catalogue est trop petit : donnez à `textarea` une hauteur, `height: 120px;`.
- Mettez les boutons aux couleurs du site :

```css
button {
    background-color: #3748A0;
    color: white;
    border: none;
    padding: 12px 24px;
    font-size: 16px;
}
```

Voici le résultat attendu pour l'inscription :

![Le formulaire d'inscription mis en forme : un cadre blanc, les étiquettes au-dessus de champs larges, la case à cocher à sa place et un bouton bleu](/tp/html/tp7-formulaire.png)

::: tip 📸 Capture 3
Faites une capture de votre formulaire d'inscription mis en forme.
:::

---

## Mission 4 - Zéro erreur partout

Passez `style.css` au validateur CSS du W3C, comme au TP 6, jusqu'au message **Félicitations ! Aucune erreur trouvée.** Vérifiez enfin les six pages : l'agenda, les deux formulaires et les tableaux.

---

## Pour aller plus loin

### Bonus 1 - Des coins arrondis

Cherchez sur [MDN](https://developer.mozilla.org/fr/docs/Web/CSS/border-radius) la propriété `border-radius`, puis arrondissez les coins des cartes, des formulaires et des boutons.

### Bonus 2 - Un trait de couleur

Remplacez la bordure des cartes par un trait orange de 6 pixels, **à gauche seulement**, de la couleur `#B86E18`.

### Bonus 3 - La couverture encadrée

Dans votre page coup de cœur, donnez l'identifiant `couverture` à l'image de votre œuvre. Encadrez-la comme une photo : un fond blanc, un padding de 10 pixels et une fine bordure grise.

### Bonus 4 - La règle étoile

Beaucoup de sites commencent leur feuille de style par cette règle :

```css
* {
    box-sizing: border-box;
}
```

Que désigne le sélecteur `*` ? Pourquoi cette règle évite-t-elle le problème de la Tâche 3.3 partout sur le site ?

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. Au prochain TP, vous placerez enfin les éléments **côte à côte** avec Flexbox : un menu horizontal et des cartes alignées.
:::
