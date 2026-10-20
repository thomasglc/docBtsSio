---
outline: deep
---

# TP 1 - Découverte du web et première page HTML

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · HTML" />

::: info Contexte
La **médiathèque de Colmar**, celle dont vous étudiez la base de données en cours, veut son site web. Semaine après semaine, c'est vous qui allez le construire : d'abord le contenu en **HTML**, puis la mise en forme en **CSS**.

Aujourd'hui, première étape : la **page d'accueil**.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Complétez le **document de restitution** au fil de la séance : **2 captures** 📸 et **2 questions courtes**, rien de plus. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp1-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **VS Code** | Éditeur de code dans lequel vous écrirez vos pages |
| **Inspecteur** | Outil du navigateur (touche F12) qui montre comment il a compris votre HTML |
| **Structure d'une page** | `<!DOCTYPE html>`, `<html>`, `<head>`, `<body>` |
| **Titres et paragraphes** | `<h1>` à `<h6>`, `<p>` |

---

## Mission 1 - Préparer son espace de travail

### Tâche 1.1 - Créer le dossier du site

Dans le dossier à votre nom sur le disque **D**, créez un dossier `mediatheque`. Il contiendra **tout** le site, jusqu'à la fin de la période.

::: warning Bien nommer ses fichiers
Comme vu en semaine 1 : des noms **en minuscules**, **sans espace** et **sans accent**. Sur un serveur web, `Index.html` et `index.html` sont deux fichiers différents.
:::

### Tâche 1.2 - Ouvrir le dossier dans VS Code

Lancez **Visual Studio Code**. Attention, ce n'est pas **Visual Studio**, le logiciel utilisé en C#.

Faites **Fichier → Ouvrir le dossier** et choisissez votre dossier `mediatheque`. Si VS Code demande si vous faites confiance aux auteurs des fichiers, répondez **Oui**. Le dossier apparaît dans l'**Explorateur**, sur la gauche.

### Tâche 1.3 - Créer la page d'accueil

Dans l'Explorateur, cliquez sur l'icône **Nouveau fichier** et nommez-le `index.html`.

::: info Pourquoi index.html ?
Quand on demande un dossier à un serveur web, il renvoie par défaut le fichier `index.html`. C'est la **page d'accueil** du site.
:::

Dans le fichier vide, tapez `!` puis appuyez sur **Tab**. VS Code génère tout le squelette de la page :

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

</body>
</html>
```

| Ligne | Rôle |
|---|---|
| `<!DOCTYPE html>` | Indique au navigateur que la page est écrite en HTML5 |
| `<html lang="en">` | Contient toute la page et précise sa langue |
| `<head>` | Informations **pour le navigateur** : encodage, titre de l'onglet… Rien ne s'affiche dans la page |
| `<meta charset="UTF-8">` | Encodage des caractères : sans lui, les accents s'affichent mal |
| `<meta name="viewport" …>` | Adapte l'affichage aux écrans de téléphone, on y reviendra |
| `<title>` | Texte affiché dans l'**onglet** du navigateur |
| `<body>` | **Tout ce qui s'affiche** dans la page |

Faites deux modifications, puis enregistrez avec **Ctrl + S** :

- remplacez `lang="en"` par `lang="fr"`, car la page est en français ;
- remplacez `Document` par `Médiathèque de Colmar - Accueil`.

::: tip Enregistrement automatique
Activez **Fichier → Enregistrement automatique** : vous n'aurez plus à penser au Ctrl + S.
:::

::: tip Document de restitution - Question 1
Complétez la **Question 1** sur le rôle de `<head>` et de `<body>`.
:::

### Tâche 1.4 - Afficher la page

Dans l'explorateur de fichiers de Windows, double-cliquez sur `index.html` : la page s'ouvre dans le navigateur. Vous pouvez aussi faire glisser le fichier dans une fenêtre du navigateur.

La page est blanche, c'est normal : le `<body>` est vide. Regardez pourtant l'onglet, il affiche déjà votre titre.

Dans le `<body>`, écrivez `Bonjour !`, enregistrez avec **Ctrl + S**, puis actualisez le navigateur avec **F5** : le texte apparaît.

::: info Enregistrer, puis actualiser
Le navigateur affiche le fichier tel qu'il est **enregistré** sur le disque. À chaque modification : **Ctrl + S** dans VS Code, puis **F5** dans le navigateur. Un point blanc sur l'onglet de VS Code signale un fichier non enregistré.
:::

---

## Mission 2 - La page d'accueil de la médiathèque

La médiathèque vous a envoyé le texte de sa page d'accueil. Il est **brut** : aucune balise. À vous de le structurer.

### Tâche 2.1 - Coller le texte

Remplacez `Bonjour !` par le texte ci-dessous :

```text
Médiathèque de Colmar
Livres, BD, mangas, films et jeux vidéo : la culture pour tous, au cœur de Colmar.
Bienvenue
La médiathèque vous accueille dans un espace de 2 000 m² entièrement rénové. Venez lire, travailler, jouer ou simplement vous détendre : l'entrée est libre et gratuite.
Nos collections
Romans et documentaires
Plus de 30 000 livres pour tous les âges, des grands classiques aux dernières nouveautés.
BD et mangas
Un espace dédié avec plus de 6 000 albums, enrichi chaque mois.
Films et jeux vidéo
Des DVD, des Blu-ray et des jeux pour consoles, à emprunter ou à essayer sur place.
Horaires
Mardi, jeudi et vendredi : de 13 h à 19 h.
Mercredi et samedi : de 10 h à 18 h.
Fermée le dimanche et le lundi.
Nous trouver
8 place des Lettres, 68000 Colmar.
```

Enregistrez, actualisez le navigateur et observez : **tout le texte s'affiche à la suite, en un seul bloc**. Le navigateur ignore les retours à la ligne du code. Sans balises, il ne sait pas ce qui est un titre et ce qui est un paragraphe.

### Tâche 2.2 - Les titres

HTML propose six niveaux de titres, de `<h1>`, le plus important, à `<h6>` :

```html
<h1>Titre principal de la page</h1>
<h2>Titre d'une partie</h2>
<h3>Titre d'une sous-partie</h3>
```

Encadrez chaque titre du texte avec la bonne balise :

- le nom de la médiathèque est le **titre principal** ;
- `Bienvenue`, `Nos collections`, `Horaires` et `Nous trouver` sont des **parties** ;
- les trois types de collections sont des **sous-parties** de `Nos collections`.

::: warning Trois règles pour les titres
- **Un seul `<h1>`** par page : c'est le sujet de la page.
- **On ne saute pas de niveau** : pas de `<h4>` directement sous un `<h2>`.
- On choisit le niveau d'après la **place dans le plan**, pas d'après la taille du texte. L'apparence se réglera plus tard, en CSS.
:::

### Tâche 2.3 - Les paragraphes

Chaque bloc de texte qui n'est pas un titre devient un **paragraphe** :

```html
<p>Un paragraphe de texte.</p>
```

Encadrez toutes les autres lignes avec `<p>` et `</p>`. Les trois lignes des horaires forment trois paragraphes.

::: tip Un code lisible
Décalez le contenu de `<body>` d'une tabulation et laissez une ligne vide avant chaque `<h2>`. Le raccourci **Maj + Alt + F** remet en forme tout le fichier.
:::

Vérifiez le résultat dans le navigateur. Votre page doit ressembler à ceci :

![Résultat attendu : la page d'accueil de la médiathèque, sans mise en forme](/tp/html/tp1-resultat.png)

::: tip 📸 Captures 1 et 2
Collez dans le document de restitution :
- **Capture 1** : votre code dans VS Code ;
- **Capture 2** : votre page affichée dans le navigateur.
:::

---

## Mission 3 - Le navigateur est tolérant

1. Dans votre code, **supprimez la balise fermante** `</h2>` du titre `Bienvenue`, enregistrez et actualisez le navigateur.
2. Observez la page : qu'est-ce qui a changé ?
3. Ouvrez l'inspecteur (**F12**) sur votre propre page et regardez comment le navigateur a interprété votre code.
4. Remettez la balise fermante.

::: tip Document de restitution - Question 2
Décrivez ce que vous avez observé dans la **Question 2**.
:::

::: danger Ne comptez pas sur la tolérance
Le navigateur affiche quand même la page, en devinant ce que vous vouliez dire. Mais il devine parfois mal, et deux navigateurs peuvent deviner différemment. Fermez toujours vos balises.
:::

---

## Pour aller plus loin

### Bonus 1 - L'agenda

Ajoutez une partie `Agenda` entre `Nos collections` et `Horaires`, avec trois événements. Chaque événement a un titre, avec sa date et son nom, et un paragraphe de description. Par exemple :

```text
Samedi 14 novembre : tournoi Mario Kart
Quatre joueurs par équipe, inscription à l'accueil. Ouvert à tous dès 10 ans.
```

Quel niveau de titre faut-il choisir pour les événements ?

### Bonus 2 - Deux balises à découvrir

Les balises `<br>` et `<hr>` n'ont pas de balise fermante. Cherchez sur [MDN](https://developer.mozilla.org/fr/), la documentation de référence du web, à quoi elles servent. Utilisez-les ensuite dans votre page, à un endroit où elles ont du sens.

::: info Savoir chercher
Aucun développeur ne connaît toutes les balises par cœur. Savoir trouver la bonne information dans une documentation fait partie du métier.
:::

### Bonus 3 - Le code mystère

Ce code contient **quatre erreurs**. Trouvez-les en le lisant, puis vérifiez dans un fichier `mystere.html`.

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Le club manga</title>
<body>
    <h1>Le club manga</h1>
    <h3>Qui sommes-nous ?</h3>
    <p>Un club ouvert à tous, <p>chaque mercredi.</p>
    <h1>Nous rejoindre</h1>
    <p>Inscription à l'accueil de la médiathèque.</p>
</body>
</html>
```

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **2 captures** et **2 réponses**.
:::

::: info La suite
Gardez précieusement votre dossier `mediatheque`. Au prochain TP, le site s'enrichit de listes, de liens, d'images et d'une page qui vous ressemble.
:::
