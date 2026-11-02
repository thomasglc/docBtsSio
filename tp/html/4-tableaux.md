---
outline: deep
---

# TP 4 - Les tableaux HTML

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · HTML · Validateur W3C" />

::: info Contexte
La médiathèque veut mettre son **catalogue** en ligne. Bonne nouvelle : les livres sont déjà enregistrés dans sa base de données, dans la table `Livre` étudiée en cours. Aujourd'hui, vous affichez ces données dans un **tableau HTML**, puis vous rendez les horaires et les tarifs plus lisibles, eux aussi sous forme de tableaux.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 3. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp4-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: details Je n'ai plus mon dossier du TP 3
Téléchargez le dossier de départ, décompressez-le sur le disque D, puis ouvrez le dossier `mediatheque` dans VS Code :

📥 <a href="/tp/html/mediatheque-depart-tp4.zip" download style="font-weight:600">Télécharger le dossier de départ</a>

La page `coups-de-coeur/mon-coup-de-coeur.html` contient seulement un modèle : remplacez les textes par votre œuvre, quelques lignes suffisent.
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Un tableau** | `<table>`, ses lignes `<tr>` et ses cellules `<td>` |
| **Les en-têtes** | `<th>` pour les cellules de titre, `<thead>` et `<tbody>` pour les deux parties du tableau |
| **Le titre du tableau** | `<caption>` |
| **La fusion de cellules** | `colspan` et `rowspan` : une cellule sur plusieurs colonnes ou plusieurs lignes |

À la fin du TP, votre dossier ressemblera à ceci :

```text
mediatheque/
├── index.html
├── infos.html           ← horaires et tarifs en tableaux
├── catalogue.html       ← nouveau
├── agenda.html
├── images/
│   └── …
└── coups-de-coeur/
    └── mon-coup-de-coeur.html
```

---

## Mission 1 - Le catalogue

### Tâche 1.1 - Créer la page

Dans l'Explorateur de VS Code, faites un clic droit sur `agenda.html` puis **Copier**, et un clic droit dans le dossier `mediatheque` puis **Coller**. Renommez la copie `catalogue.html` (touche **F2**).

Dans `catalogue.html` :

- changez le titre de l'onglet en `Médiathèque de Colmar - Catalogue` ;
- dans `<main>`, supprimez les animations et remplacez le `<h1>` par `Le catalogue`, suivi d'un paragraphe : `Retrouvez tous les livres de la médiathèque. Pour en réserver un, adressez-vous à l'accueil.`

Ajoutez enfin un lien `Catalogue` dans le menu de **toutes** les pages, entre `Infos pratiques` et `Agenda`. N'oubliez pas le `../` dans la page coup de cœur.

### Tâche 1.2 - Un premier tableau

Un tableau s'écrit **ligne par ligne**, de haut en bas, et chaque ligne contient ses cellules, de gauche à droite :

```html
<table>
    <tr>
        <th>Titre</th>
        <th>Auteur</th>
    </tr>
    <tr>
        <td>Dune</td>
        <td>Frank Herbert</td>
    </tr>
</table>
```

| Balise | En anglais | Rôle |
|---|---|---|
| `<table>` | *table* | Le tableau entier |
| `<tr>` | *table row* | Une ligne |
| `<th>` | *table header* | Une cellule d'**en-tête** : le titre d'une colonne ou d'une ligne |
| `<td>` | *table data* | Une cellule de **données** |

::: info Pas de colonnes à déclarer
On n'écrit jamais les colonnes : elles apparaissent d'elles-mêmes, à partir des cellules de chaque ligne. Toutes les lignes doivent donc avoir **le même nombre de cellules**.
:::

### Tâche 1.3 - Des bordures, en attendant le CSS

Sans mise en forme, un tableau n'a **aucune bordure** : difficile à lire. Ajoutez ces lignes dans le `<head>` de `catalogue.html`, juste après le `<title>` :

```html
<style>
    table { border-collapse: collapse; }
    th, td { border: 1px solid #555555; padding: 6px 12px; }
</style>
```

Ce sont des règles **CSS**, le langage de la mise en forme : vous apprendrez bientôt à les écrire vous-même. Pour l'instant, copiez-les telles quelles.

### Tâche 1.4 - La table Livre en HTML

Voici les données de la table `Livre`, telles qu'elles sont enregistrées dans la base de la médiathèque :

| id_livre | titre | auteur | genre | annee |
|---|---|---|---|---|
| 1 | Dune | Frank Herbert | Science-fiction | 1965 |
| 2 | Le Petit Prince | Antoine de Saint-Exupéry | Conte | 1943 |
| 3 | Harry Potter à l'école des sorciers | J. K. Rowling | Fantasy | 1997 |
| 4 | La Horde du Contrevent | Alain Damasio | Science-fiction | 2004 |
| 5 | L'Étranger | Albert Camus | Roman | 1942 |
| 6 | Le Problème à trois corps | Liu Cixin | Science-fiction | 2008 |
| 7 | Les Fourmis | Bernard Werber | Roman | 1991 |
| 8 | Klara et le Soleil | Kazuo Ishiguro | Roman | 2021 |

Sous le paragraphe de `catalogue.html`, construisez le tableau HTML de ces 8 livres. Les visiteurs du site ne connaissent pas les noms de la base : pour les en-têtes, écrivez `N°`, `Titre`, `Auteur`, `Genre` et `Année`.

::: tip Une astuce de VS Code : Emmet
Plutôt que de taper chaque balise, tapez une **abréviation** puis appuyez sur **Tab** :
- `tr>th*5` crée une ligne de 5 cellules d'en-tête ;
- `tr*8>td*5` crée 8 lignes de 5 cellules chacune.

Il ne reste plus qu'à remplir les cellules.
:::

### Tâche 1.5 - Le titre et les deux parties du tableau

Un tableau complet a un **titre**, une partie **en-tête** et une partie **corps** :

```html
<table>
    <caption>Les livres de la médiathèque</caption>
    <thead>
        <tr>
            <th>N°</th>
            <!-- les autres en-têtes -->
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <!-- les autres cellules -->
        </tr>
        <!-- les autres lignes -->
    </tbody>
</table>
```

| Balise | Rôle |
|---|---|
| `<caption>` | Le titre du tableau, juste après `<table>` |
| `<thead>` | La partie en-tête : la ligne des `<th>` |
| `<tbody>` | Le corps : les lignes de données |

Ajoutez-les à votre tableau. À l'écran, seul le titre apparaît en plus. Mais un lecteur d'écran annonce maintenant le titre du tableau et sait quelles cellules sont des en-têtes.

Voici le résultat attendu :

![Le tableau du catalogue : 5 colonnes N°, Titre, Auteur, Genre, Année et 8 livres, avec son titre au-dessus](/tp/html/tp4-catalogue.png)

Passez `catalogue.html` au validateur du W3C, comme au TP 3 : zéro erreur ?

::: tip 📸 Capture 1
Faites une capture de votre page `catalogue.html` affichée dans le navigateur.
:::

::: tip Document de restitution - Questions 1 et 2
Complétez la **Question 1** sur `<th>` et `<td>`, et la **Question 2** : de la table de la base au tableau HTML.
:::

---

## Mission 2 - Les horaires sur deux colonnes

Dans `infos.html`, remplacez la liste des horaires par un tableau de **3 colonnes** : `Jour`, `Matin` et `Après-midi`. N'oubliez pas les lignes `<style>` de la Tâche 1.3 dans le `<head>` de cette page.

Le jour est le titre de sa ligne : c'est donc un `<th>`, lui aussi.

Les jours où la médiathèque est fermée toute la journée, ou ouverte sans interruption, une seule cellule doit couvrir **les deux colonnes**. C'est le rôle de l'attribut `colspan` :

```html
<tr>
    <th>Lundi</th>
    <td colspan="2">Fermée</td>
</tr>
<tr>
    <th>Mardi</th>
    <td>Fermée</td>
    <td>13 h - 19 h</td>
</tr>
```

Rappel des horaires : **mardi, jeudi et vendredi** de 13 h à 19 h ; **mercredi et samedi** de 10 h à 18 h, sans interruption ; **dimanche et lundi** fermée.

![Le tableau des horaires : 7 jours, avec Fermée sur deux colonnes le lundi et le dimanche, et 10 h - 18 h sur deux colonnes le mercredi et le samedi](/tp/html/tp4-horaires.png)

::: warning Une cellule fusionnée compte double
La ligne du lundi n'a que **deux** cellules : le jour, et `Fermée` qui en vaut deux. Une cellule en trop, et le validateur le signale : `A table row was 4 columns wide and exceeded the column count established by the first row (3).`
:::

::: tip 📸 Capture 2
Faites une capture de votre tableau des horaires affiché dans le navigateur.
:::

---

## Mission 3 - Les tarifs sur trois lignes

Toujours dans `infos.html`, remplacez la liste des formules **et** la phrase `Chaque carte permet d'emprunter…` par un tableau de 4 colonnes : `Formule`, `Pour qui ?`, `Tarif annuel` et `Avec la carte`.

| Formule | Pour qui ? | Tarif annuel |
|---|---|---|
| Jeune | Moins de 26 ans | 15 € |
| Adulte | À partir de 26 ans | 25 € |
| Famille | Toutes les personnes d'un même foyer | 40 € |

Les trois formules donnent les mêmes droits : `8 documents pendant 3 semaines`. Plutôt que de répéter trois fois ce texte, une seule cellule va couvrir **les trois lignes** grâce à l'attribut `rowspan` :

```html
<tr>
    <th>Jeune</th>
    <td>Moins de 26 ans</td>
    <td>15 €</td>
    <td rowspan="3">8 documents pendant 3 semaines</td>
</tr>
<tr>
    <th>Adulte</th>
    <td>À partir de 26 ans</td>
    <td>25 €</td>
</tr>
```

La cellule fusionnée s'écrit **une seule fois**, dans la première ligne : les deux lignes suivantes n'ont que trois cellules.

![Le tableau des tarifs : la cellule 8 documents pendant 3 semaines s'étend sur les trois lignes des formules](/tp/html/tp4-tarifs.png)

::: tip 📸 Capture 3
Faites une capture de votre tableau des tarifs affiché dans le navigateur.
:::

::: tip Document de restitution - Question 3
Complétez la **Question 3** : quelle différence entre `colspan` et `rowspan` ?
:::

---

## Mission 4 - Zéro erreur partout

Passez `catalogue.html` et `infos.html` au validateur et corrigez jusqu'à zéro erreur et zéro avertissement. Vérifiez enfin que le menu fonctionne sur les **cinq** pages du site.

---

## Pour aller plus loin

### Bonus 1 - Un pied de tableau

Un tableau peut aussi avoir un **pied**, `<tfoot>`, placé après `<tbody>`. Ajoutez au catalogue une dernière ligne qui affiche `8 livres au catalogue` dans une cellule couvrant les 5 colonnes.

### Bonus 2 - Un en-tête sur deux lignes

Dans le tableau des horaires, regroupez `Matin` et `Après-midi` sous un en-tête commun `Ouverture`, comme ceci :

![Le tableau des horaires avec un en-tête sur deux lignes : Jour couvre deux lignes, Ouverture couvre les colonnes Matin et Après-midi](/tp/html/tp4-bonus-entete.png)

Il faut combiner `rowspan` et `colspan` dans `<thead>`, sur deux lignes. Le validateur vous dira si vos lignes tombent juste.

### Bonus 3 - Les emprunts en cours

Voici deux autres tables de la base :

| id_emprunt | id_livre | id_adherent | date_emprunt | date_retour |
|---|---|---|---|---|
| 1 | 1 | 3 | 15/09/2026 | 29/09/2026 |
| 2 | 3 | 1 | 02/10/2026 | *(vide)* |
| 3 | 6 | 2 | 05/10/2026 | 19/10/2026 |
| 4 | 1 | 5 | 10/10/2026 | *(vide)* |
| 5 | 4 | 4 | 12/10/2026 | *(vide)* |

| id_adherent | nom_adherent | prenom_adherent |
|---|---|---|
| 1 | Dupont | Marie |
| 2 | Martin | Lucas |
| 3 | Bernard | Inès |
| 4 | Petit | Hugo |
| 5 | Moreau | Léa |

Créez une page `emprunts.html` avec le tableau des **emprunts pas encore rendus** : le titre du livre, le nom et le prénom de l'adhérent, la date d'emprunt. Il faut chercher les informations dans les trois tables, comme en cours de bases de données.

Puis réfléchissez : pourquoi ce tableau ne doit-il **surtout pas** être publié sur le site de la médiathèque ?

### Bonus 4 - Un tableau pour la mise en page ?

Il y a vingt ans, on utilisait des tableaux pour placer les éléments d'une page : le menu dans une colonne, le contenu dans une autre. Cherchez pourquoi c'est aujourd'hui une mauvaise pratique. Pensez au lecteur d'écran, et aux écrans de téléphone.

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. Au prochain TP, vous créerez le **formulaire d'inscription** de la médiathèque, avec un champ pour chaque donnée de l'adhérent.
:::
