---
outline: deep
---

# TP 5 - Les formulaires HTML

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Développement web" />  <Badge type="danger" text="VS Code · HTML · Validateur W3C" />

::: info Contexte
Pour s'inscrire à la médiathèque, il faut remplir à l'accueil la **fiche papier** dont vous avez établi le dictionnaire des données en cours. La médiathèque veut cette fiche **en ligne**, sur son site. Elle veut aussi que les adhérents puissent **donner leur avis** sur les livres du catalogue.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre dossier `mediatheque` du TP 4. Complétez le **document de restitution** au fil de la séance : **3 captures** 📸 et **3 questions courtes**. Déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp5-html-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

::: details Je n'ai plus mon dossier du TP 4
Téléchargez le dossier de départ, décompressez-le sur le disque D, puis ouvrez le dossier `mediatheque` dans VS Code :

📥 <a href="/tp/html/mediatheque-depart-tp5.zip" download style="font-weight:600">Télécharger le dossier de départ</a>

La page `coups-de-coeur/mon-coup-de-coeur.html` contient seulement un modèle : remplacez les textes par votre œuvre, quelques lignes suffisent.
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Un formulaire** | `<form>` regroupe les champs, `<button>` les envoie |
| **Les champs** | `<input>` et son attribut `type` : texte, date, e-mail, mot de passe, nombre… |
| **Les étiquettes** | `<label>`, relié à son champ par `for` et `id` |
| **Le nom des données** | L'attribut `name`, comme dans le dictionnaire des données |
| **Listes et zones de texte** | `<select>` et `<option>`, `<textarea>` |
| **Les contrôles du navigateur** | `required`, `min` et `max`, `placeholder` |

À la fin du TP, votre dossier ressemblera à ceci :

```text
mediatheque/
├── index.html
├── infos.html
├── catalogue.html       ← formulaire d'avis
├── agenda.html
├── inscription.html     ← nouveau
├── images/
│   └── …
└── coups-de-coeur/
    └── mon-coup-de-coeur.html
```

---

## Mission 1 - La page d'inscription

### Tâche 1.1 - Créer la page

Comme au TP 4, copiez `agenda.html` et renommez la copie `inscription.html`. Dans cette nouvelle page :

- changez le titre de l'onglet en `Médiathèque de Colmar - Inscription` ;
- dans `<main>`, supprimez les animations et remplacez le `<h1>` et le paragraphe par :

```html
<h1>Fiche d'inscription</h1>
<p>Remplissez votre fiche en ligne, puis passez à l'accueil avec une pièce d'identité : votre carte vous sera remise.</p>
```

Ajoutez un lien `Inscription` dans le menu de **toutes** les pages, entre `Agenda` et `Mon coup de cœur`. N'oubliez pas le `../` dans la page coup de cœur.

Dans `infos.html`, modifiez enfin la deuxième étape de `Comment s'inscrire ?` :

```html
<li>Remplissez la fiche d'inscription, sur place ou <a href="inscription.html">en ligne</a>.</li>
```

### Tâche 1.2 - Un premier champ

Sous le paragraphe, ajoutez ce formulaire :

```html
<form>
    <p>
        <label for="nom_adherent">Nom</label>
        <input type="text" id="nom_adherent" name="nom_adherent">
    </p>
    <p>
        <button type="submit">Envoyer mon inscription</button>
    </p>
</form>
```

| Balise ou attribut | Rôle |
|---|---|
| `<form>` | Le formulaire : il regroupe tous les champs à envoyer |
| `<label>` | L'**étiquette** : le texte qui dit quoi écrire |
| `<input type="text">` | Un champ de saisie sur une ligne |
| `for` et `id` | Relient l'étiquette à son champ : même valeur des deux côtés |
| `name` | Le **nom de la donnée** envoyée |
| `<button type="submit">` | Le bouton qui envoie le formulaire |

Chaque champ et son étiquette sont rangés dans un paragraphe `<p>` : sans lui, tous les champs se suivraient sur la même ligne.

Dans le navigateur, cliquez sur le mot **Nom** : le curseur saute dans le champ.

::: tip Document de restitution - Question 1
Complétez la **Question 1** : à quoi sert `<label>` ?
:::

### Tâche 1.3 - Le prénom

Ajoutez le champ `Prénom` sous le nom, sur le même modèle. Dans le dictionnaire des données, il s'appelle `prenom_adherent`.

::: tip Une astuce de VS Code
Sélectionnez les lignes du paragraphe `Nom` et appuyez sur **Maj + Alt + flèche du bas** : elles sont dupliquées. Il ne reste qu'à modifier le texte et les trois attributs.
:::

---

## Mission 2 - Toutes les données de la fiche

### Tâche 2.1 - De la fiche papier aux champs

Voici la fiche papier, et le type de champ qui correspond à chaque donnée du dictionnaire :

![La fiche d'inscription papier de la médiathèque, remplie par Marie Dupont](/tp/html/tp5-fiche-papier.png)

| Donnée du dictionnaire | Étiquette | Champ |
|---|---|---|
| `nom_adherent` | Nom | `<input type="text">` |
| `prenom_adherent` | Prénom | `<input type="text">` |
| `date_naissance` | Date de naissance | `<input type="date">` |
| `rue` | Rue | `<input type="text">` |
| `code_postal` | Code postal | `<input type="text">` |
| `ville` | Ville | `<input type="text">` |
| `telephone` | Téléphone | `<input type="tel">` |
| `email` | E-mail | `<input type="email">` |

Ajoutez les champs qui manquent, avant le bouton, un paragraphe par champ. Pour chacun, `id` et `name` prennent le **nom de la donnée**.

::: warning Le piège du code postal
`68000` ne contient que des chiffres, mais ce n'est pas un nombre : on ne fait aucun calcul avec. Comme dans le dictionnaire, c'est du texte.
:::

::: tip Document de restitution - Question 2
Complétez la **Question 2** : les informations de la fiche qui ne sont pas dans le formulaire.
:::

### Tâche 2.2 - Le mot de passe

Nouveauté du site : chaque adhérent aura un **espace en ligne** pour réserver ses livres. Après l'e-mail, ajoutez un champ `Mot de passe` : `type="password"`, `id` et `name` à `mot_de_passe`.

Tapez quelque chose dedans : que voit-on ?

### Tâche 2.3 - La formule : une liste déroulante

```html
<p>
    <label for="formule">Formule</label>
    <select id="formule" name="formule">
        <option value="Jeune">Jeune (moins de 26 ans) : 15 €</option>
        <option value="Adulte">Adulte : 25 €</option>
        <option value="Famille">Famille : 40 €</option>
    </select>
</p>
```

| Balise ou attribut | Rôle |
|---|---|
| `<select>` | La liste déroulante |
| `<option>` | Un choix de la liste |
| `value` | Ce qui est **envoyé** : `Jeune` |
| Le texte entre les balises | Ce qui est **affiché** : `Jeune (moins de 26 ans) : 15 €` |

### Tâche 2.4 - La lettre d'information : une case à cocher

```html
<p>
    <label for="newsletter"><input type="checkbox" id="newsletter" name="newsletter"> J'accepte de recevoir la lettre d'information</label>
</p>
```

Comme sur la fiche papier, la case se place au début de la phrase : on la range donc **dans** son étiquette.

### Tâche 2.5 - Aider et obliger

| Attribut | Rôle | Exemple |
|---|---|---|
| `placeholder` | Un exemple grisé dans le champ vide | `placeholder="0612345678"` |
| `required` | Champ **obligatoire** : le formulaire ne part pas s'il est vide | `required` |

- Ajoutez un `placeholder` au code postal (`68000`), au téléphone et à l'e-mail (`prenom.nom@exemple.fr`).
- Rendez **obligatoires** le nom, le prénom, la date de naissance, l'e-mail et le mot de passe.

`required` s'écrit seul, sans valeur :

```html
<input type="email" id="email" name="email" placeholder="prenom.nom@exemple.fr" required>
```

Voici le résultat attendu :

![Le formulaire d'inscription attendu, sans mise en forme : onze champs et le bouton d'envoi](/tp/html/tp5-inscription.png)

::: tip 📸 Capture 1
Faites une capture de votre formulaire d'inscription complet.
:::

---

## Mission 3 - Tester le formulaire

Faites ces tests dans l'ordre :

| # | Test | Résultat attendu |
|---|---|---|
| 1 | Cliquez sur **Envoyer mon inscription** sans rien remplir | Le formulaire ne part pas : `Veuillez renseigner ce champ.` |
| 2 | Remplissez tout, mais tapez `marie.dupont` dans l'e-mail | Le navigateur réclame un `@` |
| 3 | Cliquez sur l'icône à droite de la date de naissance | Un calendrier s'ouvre |
| 4 | Corrigez l'e-mail et envoyez | La page se vide : regardez la **barre d'adresse** |

Après le test 4, la fin de l'adresse ressemble à ceci :

```text
inscription.html?nom_adherent=Dupont&prenom_adherent=Marie&date_naissance=2007-03-14&rue=12+rue+des+Clefs&…
```

::: info Où partent les données ?
Pour l'instant, nulle part : aucun programme ne les reçoit, la page se recharge simplement. Plus tard, un programme placé sur le serveur les recevra et les enregistrera dans la base de données.
:::

::: tip 📸 Capture 2
Faites une capture de la barre d'adresse après l'envoi. Cliquez dedans pour afficher l'adresse en entier.
:::

::: tip Document de restitution - Question 3
Complétez la **Question 3** : ce que contient l'adresse.
:::

---

## Mission 4 - Donner son avis sur un livre

Sous le tableau de `catalogue.html`, les adhérents vont pouvoir noter les livres. Dans la base, un avis contient trois données :

| Donnée | Signification | Type |
|---|---|---|
| `id_livre` | Numéro du livre noté | Entier |
| `note` | Note de 1 à 5 | Entier |
| `commentaire` | L'avis du lecteur | Texte |

À la fin de `<main>`, ajoutez une `<section>` avec un titre `<h2>Donnez votre avis</h2>` et un formulaire :

| Étiquette | Champ |
|---|---|
| Livre | Une liste des 8 livres. Chaque `value` est le **numéro** du livre : `<option value="1">Dune</option>` |
| Note sur 5 | `<input type="number" min="1" max="5">`, obligatoire |
| Commentaire | `<textarea></textarea>`, une zone de texte sur plusieurs lignes |
| | Un bouton `Publier mon avis` |

::: warning `<textarea>` a une balise fermante
Contrairement à `<input>`, `<textarea>` s'écrit toujours avec sa balise fermante, même vide.
:::

Testez : tapez `7` dans la note et publiez. Puis publiez un avis correct, et regardez la barre d'adresse : que vaut `id_livre` ?

![Le formulaire d'avis attendu sous le tableau du catalogue : livre, note sur 5, commentaire et bouton](/tp/html/tp5-avis.png)

::: tip 📸 Capture 3
Faites une capture de votre formulaire d'avis.
:::

---

## Mission 5 - Zéro erreur partout

Passez `inscription.html` et `catalogue.html` au validateur du W3C et corrigez jusqu'à zéro erreur. Vérifiez enfin que le menu fonctionne sur les **six** pages du site.

::: details Un indice si le validateur proteste
- Chaque `for` doit correspondre à l'`id` d'un champ.
- Un même `id` ne sert qu'une seule fois par page.
:::

---

## Pour aller plus loin

### Bonus 1 - Des cadres pour s'y retrouver

Cherchez sur [MDN](https://developer.mozilla.org/fr/docs/Web/HTML/Element/fieldset) à quoi servent `<fieldset>` et `<legend>`. Regroupez les champs de l'inscription en trois cadres : `Vous`, `Votre adresse` et `Votre abonnement`.

### Bonus 2 - La taille du dictionnaire

Dans le dictionnaire des données, le nom fait au plus **50** caractères et le code postal **5**. L'attribut `maxlength="50"` empêche d'en taper plus. Ajoutez-le aux champs de texte, avec les tailles du dictionnaire : nom et prénom 50, rue 100, code postal 5, ville 50, téléphone 10, e-mail 100.

### Bonus 3 - Des boutons radio

Sur la fiche papier, la formule se coche dans une case. Remplacez la liste déroulante par trois `<input type="radio">`. Comment faire pour qu'on ne puisse en cocher **qu'un seul** ?

### Bonus 4 - Un mot de passe plus solide

Cherchez l'attribut `minlength` et imposez **12 caractères** au moins pour le mot de passe. Testez avec un mot de passe trop court.

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de la séance. Il contient **3 captures** et **3 réponses**.
:::

::: info La suite
Gardez votre dossier `mediatheque`. Au prochain TP, le site prend enfin des couleurs : vous découvrirez le **CSS**, le langage de la mise en forme.
:::
