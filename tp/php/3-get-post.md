# 📝 TP 03 - La méthode $_GET et $_POST

## Exercice 1 : Utilisation de la méthode $_GET pour un convertisseur de devises

Créez un convertisseur de devises simple où l'utilisateur peut spécifier un montant en euros et obtenir sa valeur en dollars.

1. Créez un fichier ``convertisseur.php``.
2. Créez un formulaire HTML dans ce fichier avec :
   * Champ "Montant en euros" (nombre, ``name="montant"``).
   * Bouton "Convertir".
3. Configurez le formulaire pour qu'il utilise la méthode ``$_GET`` et envoie les données à lui-même.
4. En PHP, récupérez le montant via ``$_GET`` et effectuez la conversion avec un taux de change fixe (ex. 1 € = 1,10 $).
5. Affichez le montant converti sous la forme :
   * "`montant` euros équivalent à `résultat` dollars."
1. Si aucun montant n'est fourni, affichez un message :
    * "Veuillez entrer un montant en euros."

#### Aide :

* Vérifiez si le formulaire est soumis avec ``isset()``.
* Effectuez une conversion en multipliant le montant par le taux de change (1.10).


## Exercice 2 : Formulaire d'inscription

Créez un formulaire HTML pour collecter le prénom et l'âge d'un utilisateur, puis affichez un message personnalisé après l'envoi du formulaire.
1. Créez un fichier ``formulaire_post.php`` contenant le formulaire suivant :
   * Champ "Prénom" (texte, ``name="prenom"``).
   * Champ "Âge" (nombre, ``name="age"``).
   * Champ "Sexe" (nombre/texte, ``name="sexe"`` Les valeurs possible sont : Féminin / Masculin / Non défini).
   * Bouton "Envoyer".

2. Configurez le formulaire pour qu'il envoie les données à`` resultat_post.php`` avec la méthode ``$_POST``.

3. Dans le fichier ``resultat_post.php``, récupérez les valeurs envoyées via ``$_POST`` et affichez un message personnalisé sous la forme :
   * "Bonjour `prenom`, vous avez ``age`` ans."

4. Ajoutez une vérification pour afficher un message si le formulaire est soumis sans remplir tous les champs :
   * "Veuillez remplir tous les champs."