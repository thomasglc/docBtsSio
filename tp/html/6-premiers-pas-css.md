---
outline: deep
---

# TP 6 - Premiers pas en CSS

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · CSS · Validateurs W3C" />

::: info Contexte
Le site de la médiathèque compte maintenant six pages, un catalogue et deux formulaires. Mais il est **noir sur blanc**, en police Times, avec des liens bleus soulignés. La médiathèque a une **charte graphique** aux couleurs de son logo : aujourd'hui, vous l'appliquez à tout le site avec le **CSS**.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 5. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp6-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: details Je n'ai plus mon dossier du TP 5
Téléchargez le dossier de départ, décompressez-le sur le disque D, puis ouvrez le dossier `mediatheque` dans VS Code :

📥 <a href="/tp/html/mediatheque-depart-tp6.zip" download style="font-weight:600">Télécharger le dossier de départ</a>

La page `coups-de-coeur/mon-coup-de-coeur.html` contient seulement un modèle : remplacez les textes par votre œuvre, quelques lignes suffisent.
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Le rôle du CSS** | Le HTML décrit le **contenu**, le CSS décrit son **apparence** |
| **Une feuille de style** | Un fichier `style.css`, relié à toutes les pages par `<link>` |
| **Une règle CSS** | `sélecteur { propriété: valeur; }` |
| **Trois sélecteurs** | Une balise `h1`, une classe `.intro`, un identifiant `#titre-oeuvre` |
| **Le texte** | Couleurs, polices, tailles et alignement |

À la fin du TP, votre dossier ressemblera à ceci :

```text
mediatheque/
├── css/
│   └── style.css        ← nouveau
├── index.html
├── infos.html
├── catalogue.html
├── agenda.html
├── inscription.html
├── images/
│   └── …
└── coups-de-coeur/
    └── mon-coup-de-coeur.html
```

---

## Mission 1 - Une feuille de style pour tout le site

### Tâche 1.1 - Créer la feuille de style

Dans VS Code, créez un dossier `css` dans `mediatheque`, puis, **dans ce dossier**, un fichier `style.css`. Écrivez-y une première règle, très visible :

```css
body {
    background-color: yellow;
}
```

| Partie | Dans l'exemple | Rôle |
|---|---|---|
| Le **sélecteur** | `body` | **Ce que** l'on met en forme : ici, toute la page |
| La **propriété** | `background-color` | **Ce que** l'on change : la couleur du fond |
| La **valeur** | `yellow` | **Comment** : en jaune |

Les accolades `{ }` entourent la règle, et chaque ligne se termine par un **point-virgule**.

### Tâche 1.2 - Relier la feuille à la page d'accueil

Dans le `<head>` de `index.html`, juste après le `<title>`, ajoutez :

```html
<link rel="stylesheet" href="css/style.css">
```

Enregistrez les deux fichiers, puis actualisez le navigateur : le fond de la page est **jaune**.

::: details Rien ne change ?
- Les deux fichiers sont-ils enregistrés ? Un point blanc sur l'onglet de VS Code signale un fichier non enregistré.
- Le chemin est-il juste ? `style.css` doit être **dans** le dossier `css`.
:::

### Tâche 1.3 - Relier toutes les pages

Ajoutez la même ligne `<link>` dans les cinq autres pages. Dans la page coup de cœur, le chemin commence par `../`, comme pour le logo.

Vérifiez : les six pages sont jaunes. Remplacez maintenant `yellow` par `lightblue` dans `style.css` et actualisez : **toutes** les pages changent d'un coup.

### Tâche 1.4 - Ranger les règles du TP 4

Au TP 4, vous avez copié deux règles CSS dans une balise `<style>`, en haut de `catalogue.html` et de `infos.html`. Leur place est maintenant dans la feuille de style :

1. Dans `catalogue.html`, coupez les deux règles (**Ctrl + X**) et collez-les dans `style.css`.
2. Supprimez la balise `<style>` restée vide, dans `catalogue.html` **et** dans `infos.html`.
3. Vérifiez : les tableaux du catalogue, des horaires et des tarifs ont toujours leurs bordures.

::: warning Pas de balise dans un fichier .css
Un fichier `.css` ne contient **que des règles**. Les balises `<style>` et `</style>` n'y ont pas leur place.
:::

::: tip Document de restitution - Question 1
Complétez la **Question 1** : pourquoi une seule feuille de style pour tout le site ?
:::

---

## Mission 2 - La charte graphique

La charte graphique de la médiathèque reprend les couleurs de son logo :

| Élément | Sélecteur | Mise en forme |
|---|---|---|
| La page | `body` | fond `#F7F8FC`, texte `#1A1A2E`, police `Arial, Helvetica, sans-serif` |
| Tous les titres | `h1, h2, h3` | police `Georgia, "Times New Roman", serif` |
| Le titre principal | `h1` | couleur `#1E2D78`, taille `36px` |
| Les parties | `h2` | couleur `#3748A0` |
| Les sous-parties | `h3` | couleur `#B86E18` |
| Les liens | `a` | couleur `#3748A0` |
| Le pied de page | `footer` | couleur `#5A6072`, taille `14px`, texte centré |
| Les en-têtes de tableau | `th` | fond `#EEF1FB` |

Voici les propriétés dont vous avez besoin :

| Propriété | Rôle | Exemple |
|---|---|---|
| `color` | Couleur du texte | `color: #3748A0;` |
| `background-color` | Couleur du fond | `background-color: #F7F8FC;` |
| `font-family` | Police | `font-family: Georgia, serif;` |
| `font-size` | Taille du texte | `font-size: 36px;` |
| `font-style` | Italique | `font-style: italic;` |
| `text-align` | Alignement du texte | `text-align: center;` |

Remplacez votre règle `body` par celle-ci, puis écrivez les autres règles de la charte en dessous :

```css
body {
    background-color: #F7F8FC;
    color: #1A1A2E;
    font-family: Arial, Helvetica, sans-serif;
}

h1, h2, h3 {
    font-family: Georgia, "Times New Roman", serif;
}
```

::: info Trois points à connaître
- **`#3748A0` est un code couleur** : les six caractères donnent la quantité de rouge, de vert et de bleu. Dans VS Code, survolez le petit carré coloré à côté du code : un sélecteur de couleur s'ouvre.
- **Plusieurs polices** séparées par des virgules : si la première n'est pas installée sur l'ordinateur, le navigateur prend la suivante.
- **`h1, h2, h3`** : avec des virgules, la règle vaut pour les trois balises. Vous l'aviez déjà vu au TP 4, avec `th, td`.
:::

Voici le résultat attendu pour la page d'accueil :

![La page d'accueil mise en forme : fond très clair, titres bleus en police Georgia, sous-titres orange, liens bleus et pied de page centré](/tp/html/tp6-accueil.png)

::: tip 📸 Capture 1
Faites une capture de votre page d'accueil mise en forme.
:::

---

## Mission 3 - Classes et identifiant

### Tâche 3.1 - Une classe pour les phrases d'introduction

Sous leur `<h1>`, quatre pages commencent par une phrase d'introduction : l'accueil, le catalogue, l'agenda et l'inscription. Pour leur donner à toutes la même apparence, on leur attribue une **classe** :

```html
<p class="intro">Livres, BD, mangas, films et jeux vidéo : la culture pour tous, au cœur de Colmar.</p>
```

```css
.intro {
    color: #B86E18;
    font-size: 20px;
    font-style: italic;
}
```

- Dans le HTML, `class="intro"` ; dans le CSS, `.intro`, avec un **point**.
- Une classe se réutilise autant de fois que l'on veut, sur toutes les pages.

Ajoutez la classe aux quatre phrases d'introduction et la règle dans `style.css`.

### Tâche 3.2 - L'alerte de l'agenda

Au TP 3, vous avez remplacé la balise `<font color="red">` du stagiaire par `<strong>` : la couleur devait attendre le CSS. Elle revient !

Donnez la classe `alerte` au paragraphe `Attention : places limitées à 12 joueurs !`, puis écrivez la règle `.alerte`, avec la couleur `#C0392B`.

### Tâche 3.3 - Votre coup de cœur à ses couleurs

Le titre de votre page coup de cœur est **unique** sur le site : on lui donne un **identifiant**.

```html
<h1 id="titre-oeuvre">Mon coup de cœur : Dune</h1>
```

```css
#titre-oeuvre {
    color: #C8642B;
}
```

Choisissez une couleur qui rappelle votre œuvre, avec le sélecteur de couleur de VS Code.

| Sélecteur | Dans le HTML | Dans le CSS | Pour combien d'éléments ? |
|---|---|---|---|
| Balise | `<h1>` | `h1` | Toutes les balises `<h1>` |
| Classe | `class="intro"` | `.intro` | Autant que l'on veut |
| Identifiant | `id="titre-oeuvre"` | `#titre-oeuvre` | **Un seul** par page |

::: tip Document de restitution - Questions 2 et 3
Complétez la **Question 2** : classe ou identifiant ? Puis la **Question 3** : votre titre a deux couleurs possibles, celle de `h1` et celle de `#titre-oeuvre`. Laquelle gagne ?
:::

::: tip 📸 Captures 2 et 3
Collez dans le document de restitution :
- **Capture 2** : votre fichier `style.css` dans VS Code ;
- **Capture 3** : votre page coup de cœur dans le navigateur.
:::

---

## Mission 4 - Zéro erreur partout

### Tâche 4.1 - Le validateur CSS

Le W3C a aussi un validateur pour le CSS :

1. Ouvrez [jigsaw.w3.org/css-validator](https://jigsaw.w3.org/css-validator/) et choisissez l'onglet **Validation par Saisie Directe**.
2. Copiez tout le contenu de `style.css`, collez-le, puis cliquez sur **Vérifier**.

Corrigez jusqu'au message vert : **Félicitations ! Aucune erreur trouvée.**

::: info Un exemple de message
Une faute de frappe dans `color` donne : `La propriété “colr” n'existe pas. Le nom de propriété le plus proche est “color”`. Le validateur indique aussi le numéro de la ligne.
:::

### Tâche 4.2 - Et toujours le HTML

Vos pages ont reçu des `<link>`, des classes et un identifiant : repassez-les au validateur HTML, comme au TP 3. Vérifiez enfin que le menu fonctionne sur les **six** pages.

---

## Pour aller plus loin

### Bonus 1 - Le mode sombre

Une seule feuille pour tout le site, c'est aussi un seul endroit à modifier. Changez quelques couleurs de `style.css` pour obtenir une version **sombre** du site : fond très foncé, texte clair. Combien de lignes avez-vous modifiées pour changer l'apparence des six pages ?

### Bonus 2 - Des majuscules sans les taper

Cherchez sur [MDN](https://developer.mozilla.org/fr/docs/Web/CSS/text-transform) la propriété `text-transform`, puis affichez les sous-parties `<h3>` en majuscules, **sans modifier le HTML**.

### Bonus 3 - Une police venue d'Internet

Sur [Google Fonts](https://fonts.google.com/), choisissez une police pour les titres. Le site vous donne une ligne `@import`, à placer tout en haut de `style.css`, et le nom de la police, à utiliser dans `font-family`. Les six pages en profitent d'un coup.

### Bonus 4 - Le style dans la balise

Testez `<h2 style="color: green;">` sur un seul titre. Qui gagne : cet attribut `style` ou votre feuille de style ? Pourquoi est-ce une mauvaise idée d'écrire le CSS de cette façon dans tout le site ?

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. Au prochain TP, vous gérerez les **espaces** et les **dimensions** : les animations de l'agenda deviendront des cartes, et le formulaire d'inscription sera enfin bien aligné.
:::
