# 📝 TP 2 : Configuration WordPress
###  🎯 Objectif : Configurer WordPress et créer un portfolio professionnel.

## Configuration de Wordpress

Accédez à votre serveur web depuis un navigateur, vous devriez avoir cette page accessible.

![Installation WP1](image.png)

Ici vous pouvez renseigner les informations de votre base de données :
![Installation WP2](image-1.png)

::: tip
À cette étape, WordPress va créer l'ensemble de la base de données.

Soyez curieux ! Je vous invite **fortement** à regarder les tables créées par WordPress dans votre base de données.

❓**Question** : Quel est la particularité des tables que WordPress crée ?
:::

Renseignez les informations de votre site. Vous voulez construire un portfolio professionnel. Comme nom du site, utilisez quelque chose de parlant.
Retenez bien votre identifiant et votre mot de passe. Ils seront indispensables pour la suite.

![Installation WP3](image-2.png)

Vous pouvez à présent vous connecter à la page d'administration (back-office) WordPress

![Installation WP4](image-3.png)

::: tip Et voilà !

Et oui c'est tout ! Votre CMS est maintenant installé. 🥳

![Installation WP5](image-4.png)

:::

## Accéder à votre site
Vous l'avez constaté, vous êtes actuellement sur l'interface administrateur, vous voulez peut-être voir à quoi ressemble votre site en vrai.
Pour faire ça, vous pouvez taper l'adresse IP de votre machine virtuelle sur votre navigateur préféré.
![Accéder au site](image-7.png)

## Créer une page

Un site sans page ce n'est pas un site non ? Avec Wordpress, vous pouvez créer très simplement des pages. La création de pages est complètement graphique et vous permet **sans écrire de code** la création de pages simple :


![Création de pages](image-5.png)

L'éditeur est ce que l'on appelle un WYSIWYG, il vous permettra de rédiger visuellement votre contenu (texte, mais également intégration de contenu provenant d'autre site). Vous souhaitez ajouter une image ? Un simple Drag&Drop est suffisant.


::: tip et le responsive ?
Chez Wordpress ils ont également pensé à tout ça. Vous avez la possibilité de « Prévisualiser » votre page sous différents formats.

![Mobile First](image-6.png)
:::



## Présentation du site attendu

Votre site devra contenir au minimum les pages suivantes :
- Mes projets
- Mes certifications
- Mes expériences professionnelles
- Mon CV

Pour les pages Mes projets et Mes expériences professionnelles, le contenu devra être présenté sous forme de blog :

1 projet = 1 article

1 expérience professionnelle = 1 article

## Partie 1 – Découverte de l'interface WordPress
### Exploration du tableau de bord

Depuis le menu de gauche, repérez les sections suivantes :

- Tableau de bord
- Articles
- Pages
- Apparence
- Extensions
- Réglages

:::tip 📌 Question
Quelle est l'objectif de chacune des pages ?
:::

## Partie 2 – Création des pages principales du portfolio
### Création des pages

Créez les pages suivantes :
- Mes projets
- Mes certifications
- Mes expériences professionnelles
- Mon CV

Pour chaque page :
- Ajoutez un titre clair
- Ajoutez un texte de présentation du sujet.
- Publiez la page


📌 Vérification : Les 4 pages doivent apparaître dans la liste des pages.

## Partie 3 – Mise en place du menu de navigation
### Création du menu

Depuis Apparence → Menus :
- Créez un nouveau menu nommé : Menu principal
- Ajoutez les pages créées précédemment
- Organisez-les dans l'ordre suivant :
  - Mes projets
  - Mes certifications
  - Mes expériences professionnelles
  - Mon CV

Définissez ce menu comme menu principal du site

📌 Vérification : Le menu doit apparaître sur le site côté visiteur.

## Partie 4 – Création des articles « Mes projets »
###  Création des premiers projets

Dans Articles → Ajouter :

- Créez au minimum 2 articles, chacun correspondant à un projet.

Pour chaque article :

- Titre : nom du projet
- Contenu : Contexte du projet
- Technologies utilisées
- Votre rôle
- Publiez l'article

L'objectif de l'article de projet est de renseigner vos projets sur lesquels vous allez travailler durant les deux années de BTS. Cela peut être des projets d'écoles mais aussi des projets réalisés personnellement

::: tip 📌 Astuce
Utilisez des titres (H2 / H3) pour structurer votre contenu.
Vérifiez que les articles apparaissent automatiquement sur la page Mes projets
:::

## Partie 5 – Création des articles « Mes expériences professionnelles »
### Ajout des expériences

Créez au minimum un articles correspondant à vos expériences professionnelles. (Si vous n'avez aucune expérience professionnelle dans le domaine de l'informatique, vous pouvez initialiser la page avec votre futur stage de BTS)

Pour chaque article :

- Titre : Nom de l'entreprise / poste
- Contenu :
  - Période
  - Missions principales
  - Compétences développées

## Partie 6 – Page « Mes certifications »

Sur la page Mes certifications :

Présentez vos certifications sous forme de liste

Pour chaque certification, indiquez :
- Nom
- Organisme
- Année


## Partie 7 – Page « Mon CV »

Sur la page Mon CV :

Présentez votre profil (formation, compétences, projet professionnel)

Ajoutez :
- Une liste de compétences techniques
- Une liste de compétences transversales
- Intégrer un lien de téléchargement vers un CV PDF.

## Partie 8 – Personnalisation légère du site
### Thème

Depuis Apparence → Thèmes :

- Changez de thème
- Vérifiez que le contenu reste visible

::: tip

La sélection de thème est une étape importante, cela va former votre site dans un style particulier. Utilisez un thème simple et assez sobre pour commencer.
Plus le thème est conséquent, plus vous pouvez vous retrouver avec des lenteurs de chargement du site.
:::

::: danger Rendu sur Moodle
Vous pouvez déposer votre fichier de réponse sur Moodle.
:::
