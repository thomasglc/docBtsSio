---
outline: deep
---

# TP 3 - Structure sémantique et validation

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · HTML · Validateur W3C" />

::: info Contexte
Un adhérent malvoyant de la médiathèque navigue sur Internet avec un **lecteur d'écran**, un logiciel qui lit les pages à voix haute. Sur notre site, il ne peut pas sauter directement au menu ou au contenu : pour son logiciel, toutes les parties de la page se ressemblent. Pour ne rien arranger, un stagiaire a commencé une page **Agenda**… pleine d'erreurs.

Aujourd'hui, vous donnez du **sens** à la structure des pages, puis vous faites contrôler votre code par le **validateur du W3C**, jusqu'à zéro erreur.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 2. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp3-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: details Je n'ai plus mon dossier du TP 2
Téléchargez le dossier de départ, décompressez-le sur le disque D, puis ouvrez le dossier `mediatheque` dans VS Code :

📥 <a href="/tp/html/mediatheque-depart-tp3.zip" download style="font-weight:600">Télécharger le dossier de départ</a>

La page `coups-de-coeur/mon-coup-de-coeur.html` contient seulement un modèle : remplacez les textes par votre œuvre, quelques lignes suffisent.
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Balises sémantiques** | `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>` : elles disent **ce qu'est** chaque partie de la page |
| **`<div>` et `<span>`** | Des boîtes neutres, à utiliser seulement quand aucune autre balise ne convient |
| **Validation** | Faire contrôler son code par le validateur du W3C, comprendre ses messages et corriger les erreurs |

À la fin du TP, votre dossier ressemblera à ceci :

```text
mediatheque/
├── index.html
├── infos.html
├── agenda.html          ← nouveau
├── images/
│   ├── logo.svg
│   └── la couverture de votre coup de cœur
└── coups-de-coeur/
    └── mon-coup-de-coeur.html
```

---

## Mission 1 - Les grandes zones de la page d'accueil

Jusqu'ici, votre page d'accueil est une simple suite de titres, de paragraphes et de listes. Les **balises sémantiques** permettent de la découper en grandes zones, chacune avec un rôle précis :

![Les zones de la page d'accueil : header avec le logo et le menu nav, main avec le titre et trois sections, footer](/tp/html/tp3-zones-accueil.svg)

| Balise | Rôle | Combien par page ? |
|---|---|---|
| `<header>` | L'**en-tête** : logo, nom du site, souvent le menu | En général une |
| `<nav>` | Le **menu de navigation** principal | Une, parfois deux |
| `<main>` | Le **contenu principal**, propre à cette page | **Une seule** |
| `<section>` | Une **partie** de la page sur un même thème, avec son titre | Autant que nécessaire |
| `<article>` | Un contenu qui a du sens **tout seul** : une animation, un article de blog, un avis de lecteur | Autant que nécessaire |
| `<footer>` | Le **pied de page** : adresse, contact, auteur du site | En général une |

### Tâche 1.1 - L'en-tête et le menu

Dans `index.html`, englobez le logo **et** le menu dans une balise `<header>`, puis le menu seul (la liste `<ul>`) dans une balise `<nav>` :

```html
<header>
    <img src="images/logo.svg" alt="Logo de la médiathèque de Colmar" width="250">
    <nav>
        <ul>
            <li><a href="index.html">Accueil</a></li>
            <li><a href="infos.html">Infos pratiques</a></li>
            <li><a href="coups-de-coeur/mon-coup-de-coeur.html">Mon coup de cœur</a></li>
        </ul>
    </nav>
</header>
```

Ajoutez ensuite au menu un lien vers la future page **Agenda**, entre `Infos pratiques` et `Mon coup de cœur` :

```html
<li><a href="agenda.html">Agenda</a></li>
```

::: info Garder un code lisible
Quand vous ajoutez une balise autour d'un bloc, décalez le bloc vers la droite : sélectionnez les lignes et appuyez sur **Tab** (**Maj + Tab** pour revenir à gauche). Le raccourci **Maj + Alt + F** remet en forme tout le fichier d'un coup.
:::

### Tâche 1.2 - Le contenu principal et ses sections

Englobez **tout le contenu propre à la page**, du `<h1>` jusqu'au dernier paragraphe, dans une balise `<main>`.

Puis, **à l'intérieur** de `<main>`, englobez chaque partie dans une balise `<section>` : la partie `Bienvenue`, la partie `Nos collections` avec ses `<h3>`, et la partie `Nos services`. Chaque section commence par son `<h2>`.

```html
<main>
    <h1>Médiathèque de Colmar</h1>
    <p>Livres, BD, mangas, films et jeux vidéo : la culture pour tous, au cœur de Colmar.</p>

    <section>
        <h2>Bienvenue</h2>
        <p>…</p>
    </section>

    <!-- les deux autres sections -->
</main>
```

### Tâche 1.3 - Le pied de page

Après la balise `</main>`, ajoutez un pied de page, avec **votre prénom et votre nom** :

```html
<footer>
    <p>Médiathèque de Colmar · 8 place des Lettres, 68000 Colmar</p>
    <p>Site réalisé par Prénom Nom, BTS SIO</p>
</footer>
```

Enregistrez et actualisez la page dans le navigateur (**F5**). Surprise : à part le pied de page, **rien n'a changé** !

::: tip Document de restitution - Question 1
Complétez la **Question 1** : si l'affichage ne change pas, à quoi servent ces balises ?
:::

### Tâche 1.4 - Voir la structure d'un coup d'œil

Dans VS Code, passez la souris dans la marge, entre les numéros de ligne et le code : de petites flèches apparaissent en face des balises ouvrantes. Cliquez sur celles de `<header>`, `<main>` et `<footer>` pour **replier** ces blocs. Le squelette de la page apparaît. Recliquez pour déplier.

::: tip 📸 Capture 1
Faites une capture de `index.html` dans VS Code, avec les blocs `<header>`, `<main>` et `<footer>` **repliés**.
:::

---

## Mission 2 - Les autres pages

Structurez de la même façon `infos.html` et votre page `coups-de-coeur/mon-coup-de-coeur.html` :

| Page | Les sections dans `<main>` |
|---|---|
| `infos.html` | Horaires, Tarifs, Comment s'inscrire ?, Nous trouver |
| `mon-coup-de-coeur.html` | L'histoire, La fiche, Pourquoi je le recommande |

Le plus simple : copiez le `<header>` et le `<footer>` de `index.html`, collez-les dans chaque page, puis vérifiez les chemins.

::: warning Attention aux chemins
Dans `coups-de-coeur/mon-coup-de-coeur.html`, la page est dans un sous-dossier : le lien vers l'agenda s'écrit `../agenda.html`, et le logo `../images/logo.svg`.
:::

Testez le menu sur les trois pages : chaque lien doit fonctionner, sauf `Agenda`, qui n'existe pas encore.

---

## Mission 3 - La page du stagiaire

### Tâche 3.1 - Récupérer la page

Enregistrez la page commencée par le stagiaire dans votre dossier `mediatheque`, à côté de `index.html`, sous le nom `agenda.html` :

📥 <a href="/tp/html/tp3-agenda-stagiaire.html" download="agenda.html" style="font-weight:600">Télécharger agenda.html</a>

Ouvrez-la dans le navigateur, depuis le menu de votre page d'accueil. Elle s'affiche… **presque** normalement. Regardez bien l'onglet, le programme du tournoi et le menu.

::: details Le téléchargement ne fonctionne pas ?
Créez le fichier `agenda.html` dans VS Code et collez-y ce code, **sans rien corriger** :

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div>
        <img src="images/logo.svg" width="250">
        <ul>
            <li><a href="index.html">Accueil</a></li>
            <li><a href="infos.html">Infos pratiques</a></li>
            <li><a href="agenda.html">Agenda</a></li>
            <li><a href="coups-de-coeur/mon coup de coeur.html">Mon coup de cœur</a></li>
        </ul>
    </div>

    <div>
        <h1>Agenda de novembre</h1>
        <p>Toutes nos animations sont <strong>gratuites</strong>, sur inscription à l'accueil.</p>

        <div>
            <h2>Club manga</h2>
            <p><strong>Mercredi 4 novembre, 14 h</strong> · Auditorium · <em>de 11 à 15 ans</em></p>
            <p>Venez parler de vos séries préférées et découvrir les nouveautés du mois.</p>
        </div>

        <div>
            <h2>L'heure du conte</h2>
            <p><strong>Samedi 7 novembre, 10 h 30</strong> · Espace jeunesse · <em>de 4 à 7 ans</em></p>
            <p>Des histoires lues à voix haute, pour rêver <strong>les yeux <em>grands ouverts</strong></em>.</p>
        </div>

        <div>
            <h2>Tournoi de jeux vidéo</h2>
            <p><strong>Samedi 14 novembre, 14 h</strong> · Auditorium · <em>à partir de 10 ans</em></p>
            <p>Au programme :</p>
            <li>des courses de karts en équipe ;</li>
            <li>une finale sur grand écran ;</li>
            <li>un goûter pour tous les participants.</li>
        </div>

        <div>
            <h2>Atelier escape game</h2>
            <p><strong>Samedi 21 novembre, 15 h</strong> · Salle de travail · <em>ados et adultes</em></p>
            <p><font color="red">Attention : places limitées à 12 joueurs !</font></p>
            <p>Résolvez les énigmes cachées dans les rayons avant la fermeture de la médiathèque.</p>
        </div>
    </div>

    <div>
        <p>Médiathèque de Colmar · 8 place des Lettres, 68000 Colmar</p>
    </div>
</body>
</html>
```
:::

### Tâche 3.2 - Le validateur du W3C

Le **W3C** est l'organisme qui écrit les règles du HTML. Son **validateur** vérifie qu'une page les respecte.

1. Ouvrez [validator.w3.org](https://validator.w3.org/) et choisissez l'onglet **Validate by Direct Input**.
2. Dans VS Code, sélectionnez tout le code de `agenda.html` (**Ctrl + A**) et copiez-le (**Ctrl + C**).
3. Collez-le dans la zone de texte (**Ctrl + V**), puis cliquez sur **Check**.

Le validateur affiche une liste de messages :

| Type | Sens |
|---|---|
| **Error** (rouge) | Une erreur : le code ne respecte pas les règles du HTML |
| **Warning** (jaune) | Un avertissement : le code est accepté, mais il pourrait être amélioré |

Sous chaque message, le validateur indique **où** se trouve le problème (`From line 9, column 9`) et affiche un extrait du code.

::: tip 📸 Capture 2
Faites une capture de la liste des erreurs de la page du stagiaire, **avant** toute correction.
:::

### Tâche 3.3 - Corriger les erreurs

Corrigez les erreurs **une par une**, dans l'ordre :

1. Lisez le message et repérez le numéro de ligne.
2. Dans VS Code, allez à cette ligne : **Ctrl + G**, puis le numéro.
3. Corrigez, enregistrez, recopiez le code dans le validateur et relancez **Check**.

Recommencez jusqu'au message vert : **Document checking completed. No errors or warnings to show.**

::: info Un petit lexique pour lire les messages
| Dans le message | En français |
|---|---|
| *element* | élément, c'est-à-dire une balise |
| *attribute* | attribut |
| *missing*, *required* | manquant, obligatoire |
| *not allowed* | interdit |
| *end tag* | balise fermante |
| *nesting rules* | règles d'emboîtement |
| *obsolete* | obsolète, qui n'existe plus |
| *consider adding* | pensez à ajouter |
:::

::: warning Toujours commencer par la première erreur
Une seule faute peut produire **plusieurs** messages. En corrigeant la première, plusieurs messages disparaissent parfois d'un coup.
:::

::: details Un indice si vous bloquez
- Les balises s'emboîtent comme des poupées russes : la **dernière ouverte** est la **première fermée**.
- Une balise `<li>` vit toujours dans une liste.
- Le nom exact de votre page coup de cœur ne contient pas d'espace.
- Pour mettre en valeur un avertissement, vous connaissez une balise depuis le TP 2. Les couleurs, ce sera le travail du CSS.
:::

::: tip Document de restitution - Question 2
Complétez la **Question 2** : deux erreurs du stagiaire, expliquées en français.
:::

### Tâche 3.4 - Donner du sens à la page

La page est valide, mais elle ne contient que des `<div>`. Une `<div>` est une **boîte neutre** : elle regroupe des éléments sans rien dire de leur rôle. Remplacez-les :

| La `<div>` qui contient… | devient |
|---|---|
| le logo et le menu | `<header>`, avec le menu dans un `<nav>` |
| tout le contenu de l'agenda | `<main>` |
| chaque animation | `<article>` |
| l'adresse | `<footer>` : reprenez celui de vos autres pages |

![Les zones de la page Agenda : header avec le logo et le menu, main avec le titre et quatre articles, footer](/tp/html/tp3-zones-agenda.svg)

::: info Pourquoi article et pas section ?
Chaque animation a du sens **toute seule** : on pourrait la copier telle quelle dans la lettre d'information de la médiathèque ou la partager sur un réseau social. C'est le test de l'`<article>`. Une `<section>`, elle, n'est qu'une partie d'un ensemble, comme les horaires dans la page Infos pratiques.
:::

Pour finir, **escape game** est une expression anglaise. Indiquez-le pour qu'un lecteur d'écran la prononce à l'anglaise :

```html
<h2>Atelier <span lang="en">escape game</span></h2>
```

::: info Et quand utiliser div et span ?
`<div>` et `<span>` sont des boîtes **neutres** : `<div>` pour un bloc, `<span>` pour quelques mots à l'intérieur d'une ligne. On ne les utilise que quand **aucune balise ne convient**. Ici, `<span>` porte une information utile, la langue. Avec le CSS, elles serviront surtout à regrouper des éléments pour les mettre en forme.
:::

Validez une dernière fois `agenda.html` : toujours zéro erreur ?

::: tip 📸 Capture 3
Faites une capture du message vert du validateur pour votre page `agenda.html` structurée.
:::

::: tip Document de restitution - Question 3
Complétez la **Question 3** : quelle balise pour quel contenu ?
:::

---

## Mission 4 - Zéro erreur partout

Passez **toutes** vos pages au validateur : `index.html`, `infos.html` et `mon-coup-de-coeur.html`. Corrigez jusqu'à obtenir zéro erreur et zéro avertissement sur chacune.

Vérifiez enfin que le menu fonctionne sur les **quatre** pages, dans tous les sens.

---

## Pour aller plus loin

### Bonus 1 - Des dates que les machines comprennent

La balise `<time>` donne une date dans un format qu'un ordinateur sait lire, par exemple pour l'ajouter à un agenda :

```html
<time datetime="2026-11-04T14:00">Mercredi 4 novembre, 14 h</time>
```

Utilisez-la pour la date de chaque animation, puis validez la page.

### Bonus 2 - Un encadré « À savoir »

Il existe une autre balise sémantique : `<aside>`. Cherchez à quoi elle sert sur le site [MDN](https://developer.mozilla.org/fr/docs/Web/HTML/Element/aside), puis ajoutez dans l'agenda un encadré `À savoir` qui rappelle comment s'inscrire aux animations.

### Bonus 3 - Votre coup de cœur dans la lettre d'information

La médiathèque veut reprendre votre coup de cœur tel quel dans sa lettre d'information. Quelle balise devrait englober toute votre critique, du `<h1>` à la dernière raison ? Modifiez votre page en conséquence.

### Bonus 4 - Les grands sites sont-ils valides ?

Dans le validateur, l'onglet **Validate by URI** vérifie un site en ligne à partir de son adresse. Testez deux ou trois sites que vous utilisez souvent. Combien d'erreurs trouvez-vous ? Comment le navigateur arrive-t-il quand même à les afficher ?

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. Au prochain TP, vous afficherez le **catalogue** de la médiathèque sous forme de tableau, avec les livres de la base de données.
:::
