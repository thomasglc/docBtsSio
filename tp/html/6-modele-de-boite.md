---
outline: deep
---

# TP 6 - Le modèle de boîte

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · CSS · Inspecteur" />

::: info Contexte
Le site a pris les couleurs de la médiathèque, mais tout est serré : les animations de l'agenda se suivent sans séparation, et les parties des pages se fondent les unes dans les autres. Aujourd'hui, vous réglez les **espaces** et les **dimensions** des éléments grâce au **modèle de boîte**.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 5. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp6-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Le modèle de boîte** | Chaque élément est une boîte : contenu, `padding`, `border` et `margin` |
| **L'inspecteur** | Voir les boîtes d'une page et mesurer leurs espaces |
| **Les dimensions** | `width`, `max-width` et `box-sizing` |
| **Bloc ou en ligne** | La propriété `display` |

Aujourd'hui, presque tout se passe dans `style.css` : le HTML ne reçoit qu'une classe.

---

## Mission 1 - Voir les boîtes

Pour le navigateur, chaque élément de la page est une **boîte** rectangulaire, faite de quatre couches :

![Le modèle de boîte : le contenu au centre, entouré du padding, puis de la bordure, puis de la margin](/tp/html/tp6-modele-boite.svg)

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

![L'agenda en cartes : chaque animation dans un cadre blanc à bordure bleue, séparé de la suivante](/tp/html/tp6-agenda.png)

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

## Mission 3 - Des pages aérées

### Tâche 3.1 - Les sections en cadres

L'accueil, les infos pratiques et votre coup de cœur sont découpés en `<section>`. Ajoutez cette règle, puis actualisez la page **Infos pratiques** :

```css
section {
    width: 800px;
    background-color: white;
    border: 1px solid #C8CCD4;
    padding: 20px;
    margin-bottom: 24px;
}
```

Inspectez une section et survolez la ligne `<section>` : l'inspecteur affiche sa taille, à côté de son nom. **Combien de pixels de large ?**

### Tâche 3.2 - Le piège de la largeur

La section ne mesure pas 800 pixels ! Par défaut, `width` ne compte que le **contenu** : le navigateur ajoute ensuite le padding et la bordure. Ajoutez cette ligne à la règle :

```css
box-sizing: border-box;
```

Avec `border-box`, `width` compte **tout** : le contenu, le padding et la bordure. Vérifiez dans l'inspecteur : la section mesure 800 pixels, pas un de plus.

::: tip Document de restitution - Question 2
Complétez la **Question 2** : pourquoi la section mesurait-elle plus de 800 pixels ?
:::

### Tâche 3.3 - Une largeur qui s'adapte

Rétrécissez la fenêtre du navigateur : les sections gardent leurs 800 pixels, et une barre de défilement apparaît en bas. Remplacez `width` par `max-width` :

```css
max-width: 800px;
```

La section mesure **au plus** 800 pixels : dans une fenêtre étroite, elle rétrécit. Voici le résultat attendu :

![Les infos pratiques : les horaires et les tarifs, chacun dans un cadre blanc à fine bordure grise](/tp/html/tp6-sections.png)

### Tâche 3.4 - Un lien en forme de bouton

Il existe deux grandes sortes de boîtes :

| | En **bloc** | En **ligne** |
|---|---|---|
| Place | Commence sur une nouvelle ligne et prend **toute la largeur** | Reste dans la ligne et prend **la place de son contenu** |
| Exemples | `<p>`, `<h1>`, `<section>`, `<article>`, `<ul>`, `<div>` | `<a>`, `<strong>`, `<em>`, `<span>`, `<img>` |

1. Dans votre page coup de cœur, donnez la classe `bouton` au lien `Retour à l'accueil` :

   ```html
   <a href="../index.html" class="bouton">Retour à l'accueil</a>
   ```

2. Ajoutez cette règle à `style.css` :

   ```css
   .bouton {
       background-color: #3748A0;
       color: white;
       padding: 12px 24px;
       margin-top: 20px;
       text-decoration: none;
   }
   ```

   `text-decoration: none;` retire le soulignement du lien.

3. Regardez bien le haut du bouton : il touche la ligne du dessus, et `margin-top` ne change rien.

   ![Le bouton Retour à l'accueil colle à la ligne Pour en savoir plus, juste au-dessus](/tp/html/tp6-bouton-en-ligne.png)

   Un `<a>` est **en ligne** : il ignore les marges du haut et du bas. Ajoutez cette ligne à la règle :

   ```css
   display: inline-block;
   ```

   Le lien reste dans la ligne, mais il respecte maintenant son padding et ses marges, comme un bloc :

   ![Le bouton Retour à l'accueil, bien détaché de la ligne du dessus](/tp/html/tp6-bouton.png)

::: tip Document de restitution - Question 3
Complétez la **Question 3** : bloc ou en ligne ?
:::

::: tip 📸 Capture 3
Faites une capture de votre page coup de cœur : les sections en cadres et le bouton.
:::

---

## Mission 4 - Zéro erreur partout

Passez `style.css` au validateur CSS du W3C, comme au TP 5, jusqu'au message **Félicitations ! Aucune erreur trouvée.** Repassez aussi votre page coup de cœur au validateur HTML, puis vérifiez les cinq pages dans le navigateur.

---

## Pour aller plus loin

### Bonus 1 - Des coins arrondis

Cherchez sur [MDN](https://developer.mozilla.org/fr/docs/Web/CSS/border-radius) la propriété `border-radius`, puis arrondissez les coins des cartes, des sections et du bouton.

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

Que désigne le sélecteur `*` ? Pourquoi cette règle évite-t-elle le piège de la Tâche 3.2 partout sur le site ?

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. Au prochain TP, vous placerez enfin les éléments **côte à côte** avec Flexbox : un menu horizontal et des cartes alignées.
:::
