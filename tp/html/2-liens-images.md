---
outline: deep
---

# TP 2 - Texte, listes, liens et images

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · HTML" />

::: info Contexte
Le site de la médiathèque de Colmar s'agrandit. Il lui faut une page d'**infos pratiques**, un **menu** pour passer d'une page à l'autre, un **logo**… et une page **« Mon coup de cœur »**, où vous présentez le livre, la BD ou le manga que vous conseillez à tout le monde.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 1. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp2-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: details Je n'ai plus mon dossier du TP 1
Créez un dossier `mediatheque` sur le disque D, ouvrez-le dans VS Code et créez `index.html` avec ce contenu :

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Médiathèque de Colmar - Accueil</title>
</head>
<body>
    <h1>Médiathèque de Colmar</h1>
    <p>Livres, BD, mangas, films et jeux vidéo : la culture pour tous, au cœur de Colmar.</p>

    <h2>Bienvenue</h2>
    <p>La médiathèque vous accueille dans un espace de 2 000 m² entièrement rénové. Venez lire, travailler, jouer ou simplement vous détendre : l'entrée est libre et gratuite.</p>

    <h2>Nos collections</h2>
    <h3>Romans et documentaires</h3>
    <p>Plus de 30 000 livres pour tous les âges, des grands classiques aux dernières nouveautés.</p>
    <h3>BD et mangas</h3>
    <p>Un espace dédié avec plus de 6 000 albums, enrichi chaque mois.</p>
    <h3>Films et jeux vidéo</h3>
    <p>Des DVD, des Blu-ray et des jeux pour consoles, à emprunter ou à essayer sur place.</p>

    <h2>Horaires</h2>
    <p>Mardi, jeudi et vendredi : de 13 h à 19 h.</p>
    <p>Mercredi et samedi : de 10 h à 18 h.</p>
    <p>Fermée le dimanche et le lundi.</p>

    <h2>Nous trouver</h2>
    <p>8 place des Lettres, 68000 Colmar.</p>
</body>
</html>
```
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Mise en valeur** | `<strong>` pour un texte important, `<em>` pour une insistance |
| **Listes** | `<ul>` à puces, `<ol>` numérotée, `<li>` pour chaque élément |
| **Liens** | `<a href="…">` vers une autre page du site ou vers un autre site |
| **Chemins relatifs** | Désigner un fichier à partir de la page où l'on se trouve |
| **Images** | `<img src="…" alt="…">` |

À la fin du TP, votre dossier ressemblera à ceci :

```text
mediatheque/
├── index.html
├── infos.html
├── images/
│   ├── logo.svg
│   └── la couverture de votre coup de cœur
└── coups-de-coeur/
    └── mon-coup-de-coeur.html
```

---

## Mission 1 - Mettre le texte en valeur

Deux balises servent à mettre un mot ou un groupe de mots en valeur **à l'intérieur** d'un paragraphe :

```html
<p>L'entrée est <strong>libre et gratuite</strong>, et les albums sont <em>enrichis chaque mois</em>.</p>
```

| Balise | Sens | Affichage par défaut |
|---|---|---|
| `<strong>` | Texte **important** | Gras |
| `<em>` | Insistance, comme quand on appuie sur un mot à l'oral | Italique |

::: info Le sens, pas l'apparence
On choisit `<strong>` ou `<em>` pour ce que le texte **veut dire**. Un lecteur d'écran, utilisé par les personnes aveugles, change d'ailleurs de ton en les lisant. Pour mettre du texte en gras juste pour faire joli, on utilisera le CSS.
:::

Dans `index.html` :

- mettez `l'entrée est libre et gratuite` en `<strong>` ;
- mettez `enrichi chaque mois` en `<em>`.

---

## Mission 2 - Une page d'infos pratiques

### Tâche 2.1 - Créer la page

Créez un fichier `infos.html` à côté de `index.html`. Générez son squelette avec `!` + **Tab**, mettez `lang="fr"` et donnez-lui le titre d'onglet `Médiathèque de Colmar - Infos pratiques`.

Dans son `<body>`, ajoutez un titre principal `<h1>Infos pratiques</h1>`.

Puis **déplacez** les parties `Horaires` et `Nous trouver` de `index.html` vers `infos.html`, sous le `<h1>` : coupez-les avec **Ctrl + X** et collez-les avec **Ctrl + V**.

### Tâche 2.2 - Les horaires en liste à puces

Une **liste à puces** regroupe des éléments **sans ordre particulier** :

```html
<ul>
    <li>Premier élément</li>
    <li>Deuxième élément</li>
</ul>
```

`<ul>` (*unordered list*) encadre la liste et chaque `<li>` (*list item*) contient un élément.

Transformez les trois paragraphes des horaires en une liste à puces. Mettez les jours en `<strong>`, et écrivez la dernière ligne ainsi : `Dimanche et lundi : fermée`.

### Tâche 2.3 - Les tarifs et l'inscription

Ajoutez ce texte entre `Horaires` et `Nous trouver`, puis balisez-le :

```text
Tarifs
La consultation sur place est gratuite. Pour emprunter, choisissez une formule :
Formule Jeune (moins de 26 ans) : 15 € par an
Formule Adulte : 25 € par an
Formule Famille : 40 € par an
Chaque carte permet d'emprunter jusqu'à 8 documents pendant 3 semaines.
Comment s'inscrire ?
Venez à l'accueil avec une pièce d'identité et un justificatif de domicile.
Remplissez la fiche d'inscription.
Choisissez votre formule : votre carte vous est remise immédiatement.
```

- Les trois formules forment une **liste à puces**.
- Les trois étapes de l'inscription se suivent dans un ordre précis : c'est une **liste numérotée**, `<ol>` (*ordered list*). Elle s'écrit comme `<ul>`, et le navigateur numérote tout seul.
- Mettez en `<strong>` les mots qui vous semblent importants.

::: tip Document de restitution - Question 1
Complétez la **Question 1** : quand choisir `<ul>`, quand choisir `<ol>` ?
:::

---

## Mission 3 - Relier les pages

### Tâche 3.1 - Un premier lien

Un lien s'écrit avec la balise `<a>` et son attribut `href`, qui indique **où aller** :

```html
<a href="infos.html">Infos pratiques</a>
```

Le texte entre les balises est ce qui s'affiche et sur quoi l'on clique.

À la fin de `index.html`, ajoutez ce paragraphe :

```html
<p>Horaires, tarifs et inscription : consultez la page <a href="infos.html">Infos pratiques</a>.</p>
```

Cliquez sur le lien dans le navigateur : vous arrivez sur `infos.html`.

### Tâche 3.2 - Le menu

Un site a besoin d'un **menu**, présent en haut de **chaque page**. C'est simplement une liste de liens. Ajoutez-le au début du `<body>` de `index.html` **et** de `infos.html` :

```html
<ul>
    <li><a href="index.html">Accueil</a></li>
    <li><a href="infos.html">Infos pratiques</a></li>
    <li><a href="coups-de-coeur/mon-coup-de-coeur.html">Mon coup de cœur</a></li>
</ul>
```

Testez le menu dans les deux sens. Le troisième lien mène vers une page qui n'existe pas encore : une erreur s'affiche, c'est normal, vous la créerez en Mission 5.

::: info Chemin relatif
`infos.html` ou `coups-de-coeur/mon-coup-de-coeur.html` sont des **chemins relatifs** : ils indiquent où trouver le fichier **à partir de la page actuelle**, comme dans le terminal en semaine 2. Le site fonctionnera donc sur n'importe quel ordinateur ou serveur.
:::

### Tâche 3.3 - Un lien vers un autre site

Pour viser un autre site, on écrit l'**adresse complète**, avec `https://`. Dans la partie `Nous trouver` de `infos.html`, ajoutez :

```html
<p><a href="https://www.openstreetmap.org/search?query=Colmar">Voir Colmar sur OpenStreetMap</a></p>
```

::: tip 📸 Capture 1
Faites une capture de votre page `infos.html` affichée dans le navigateur.
:::

---

## Mission 4 - Les images

### Tâche 4.1 - Récupérer le logo

Créez un dossier `images` dans `mediatheque`, puis enregistrez-y le logo de la médiathèque sous le nom `logo.svg` :

📥 <a href="/tp/html/logo-mediatheque.svg" download="logo.svg" style="font-weight:600">Télécharger le logo</a>

### Tâche 4.2 - Afficher le logo

Une image s'affiche avec la balise `<img>`. Elle n'a **pas de balise fermante** :

```html
<img src="images/logo.svg" alt="Logo de la médiathèque de Colmar" width="250">
```

| Attribut | Rôle |
|---|---|
| `src` | Chemin vers le fichier image (*source*) |
| `alt` | Description de l'image, en texte |
| `width` | Largeur d'affichage en pixels, en attendant le CSS |

Placez le logo tout en haut du `<body>`, au-dessus du menu, dans `index.html` et dans `infos.html`.

### Tâche 4.3 - À quoi sert alt ?

Dans `index.html`, faites exprès une faute dans le chemin : `src="images/logoo.svg"`. Enregistrez et regardez la page. Corrigez ensuite le chemin.

::: tip Document de restitution - Question 2
Complétez la **Question 2** sur l'attribut `alt`.
:::

---

## Mission 5 - Mon coup de cœur

C'est votre page : présentez le livre, la BD ou le manga que vous recommanderiez à tout le monde.

### Tâche 5.1 - Créer la page dans son dossier

La médiathèque prévoit de publier un coup de cœur différent chaque mois. Elle les range dans un dossier à part. Créez le dossier `coups-de-coeur`, et dans ce dossier, le fichier `mon-coup-de-coeur.html`.

### Tâche 5.2 - Remonter d'un dossier avec ../

La page se trouve maintenant **dans un sous-dossier**. Depuis cette page, `index.html` n'est plus à côté : il faut d'abord **remonter d'un niveau** avec `..`, exactement comme `cd ..` dans le terminal.

| Depuis `coups-de-coeur/mon-coup-de-coeur.html`, pour atteindre… | Chemin |
|---|---|
| la page d'accueil | `../index.html` |
| le logo | `../images/logo.svg` |
| une page du même dossier | `mon-coup-de-coeur.html` |

Copiez le logo et le menu de `index.html` dans votre nouvelle page, puis **corrigez tous les chemins**. Vérifiez que le logo s'affiche et que chaque lien du menu fonctionne.

::: tip Document de restitution - Question 3
Complétez la **Question 3** sur les chemins.
:::

### Tâche 5.3 - Le contenu de votre page

Choisissez votre œuvre, trouvez une image de sa couverture sur le web, faites un clic droit puis **Enregistrer l'image sous…** et rangez-la dans le dossier `images`, avec un nom propre comme `couverture-one-piece.jpg`.

Votre page doit contenir :

| Élément attendu | Balises |
|---|---|
| Le titre de l'onglet : `Mon coup de cœur - le titre de l'œuvre` | `<title>` |
| Le logo et le menu, comme sur les autres pages | `<img>`, `<ul>`, `<a>` |
| Le titre principal : `Mon coup de cœur : le titre de l'œuvre` | `<h1>` |
| La couverture, avec une description utile | `<img>` avec `alt` |
| L'histoire en quelques lignes, **sans spoiler la fin**, avec au moins un passage important et une insistance | `<h2>`, `<p>`, `<strong>`, `<em>` |
| La fiche : auteur, genre, année de parution… | `<h2>`, `<ul>` |
| Vos trois raisons de le conseiller, **de la plus forte à la moins forte** | `<h2>`, `<ol>` |
| Un lien vers un autre site pour en savoir plus | `<a>` |
| Un lien de retour à l'accueil | `<a>` |

Voici un exemple de résultat, sur *Dune* :

![Exemple de page coup de cœur sur le roman Dune](/tp/html/tp2-exemple-coup-de-coeur.png)

::: tip 📸 Captures 2 et 3
Collez dans le document de restitution :
- **Capture 2** : votre page coup de cœur affichée dans le navigateur ;
- **Capture 3** : l'Explorateur de VS Code, avec tous les dossiers dépliés.
:::

::: info Droit d'auteur
Une couverture est protégée par le droit d'auteur. Ici, l'usage reste pédagogique et le site n'est pas publié sur Internet.
:::

---

## Pour aller plus loin

### Bonus 1 - Le logo cliquable

Sur la plupart des sites, cliquer sur le logo ramène à l'accueil. Placez la balise `<img>` du logo **à l'intérieur** d'une balise `<a>`, sur les trois pages. Attention aux chemins dans la page coup de cœur !

### Bonus 2 - Aller directement aux tarifs

Un lien peut viser un **endroit précis** d'une page. Ajoutez `id="tarifs"` à la balise `<h2>` des tarifs, puis créez dans `index.html` un lien vers `infos.html#tarifs`. Que se passe-t-il quand on clique ?

### Bonus 3 - Une liste dans une liste

Dans la fiche de votre coup de cœur, ajoutez un élément `Du même auteur` qui contient lui-même une petite liste à puces de deux ou trois autres œuvres. Une liste peut se placer **à l'intérieur** d'un `<li>`.

### Bonus 4 - Un deuxième coup de cœur

Créez une deuxième page dans le dossier `coups-de-coeur`, et reliez les deux pages entre elles par un lien `Découvrir un autre coup de cœur`.

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. La semaine prochaine, vous découvrirez les balises qui donnent du **sens** à la structure de la page : en-tête, menu de navigation, contenu principal et pied de page.
:::
