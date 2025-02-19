# 📌 Mémo PHP

## Les Bases

## Structure de base
```php
<?php
    // Code PHP ici
?>
```

## Variables et Types
```php
$nom = "Thomas";           // Chaîne de caractères
$age = 25;                // Nombre entier
$prix = 19.99;            // Nombre décimal
$estVrai = true;          // Booléen
$fruits = ["pomme", "banane"]; // Tableau
```

## Conditions (if / else)
```php
$age = 20;
if ($age >= 18) {
    echo "Majeur";
} elseif ($age >= 16) {
    echo "Presque majeur";
} else {
    echo "Mineur";
}
```

## Boucles
```php
// Boucle for
for ($i = 0; $i < 5; $i++) {
    echo $i;
}

// Boucle while
$i = 0;
while ($i < 5) {
    echo $i;
    $i++;
}

// Boucle foreach
$fruits = ["pomme", "banane", "orange"];
foreach ($fruits as $fruit) {
    echo $fruit;
}
```

## Fonctions
```php
function direBonjour($nom) {
    return "Bonjour " . $nom;
}
echo direBonjour("Thomas"); // Affiche: Bonjour Thomas
```

## Tableaux
```php
// Tableau indexé
$fruits = ["pomme", "banane", "orange"];
echo $fruits[0]; // Affiche: pomme

// Tableau associatif
$personne = [
    "nom" => "Dupont",
    "age" => 25,
    "ville" => "Paris"
];
echo $personne["nom"]; // Affiche: Dupont
```

## Chaînes de caractères
```php
$prenom = "Thomas";
$nom = "Dupont";

// Concaténation
echo $prenom . " " . $nom;

// Interpolation
echo "Bonjour $prenom $nom";

// Fonctions utiles
echo strlen($prenom);     // Longueur
echo strtoupper($nom);    // Majuscules
echo strtolower($nom);    // Minuscules
```

## Inclusion de fichiers
```php
require 'config.php';     // Arrête le script si erreur
include 'header.php';     // Continue même si erreur
require_once 'config.php'; // Vérifie si déjà inclus
```

## Sessions et Cookies
```php
// Sessions
session_start();
$_SESSION['user'] = "Thomas";
echo $_SESSION['user'];

// Cookies
setcookie("utilisateur", "Thomas", time() + 3600); // Expire dans 1h
echo $_COOKIE['utilisateur'];
```
---


##  PDO : CRUD

## 1. Connexion à la base de données

```php
try {
    $pdo = new PDO("mysql:host=localhost;dbname=nom_de_la_base", "utilisateur", "mot_de_passe");

    //Configuration de PDO pour permettre la bonne gestion des erreurs
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connexion réussie";
} catch (PDOException $e) {
    die("Erreur : " . $e->getMessage());
}
```

## 2. Création (INSERT)

```php
$stmt = $pdo->prepare("INSERT INTO utilisateurs (nom, email) VALUES (:nom, :email)");

$nom = "Dupont";
$email = "dupont@example.com";

$stmt->bindParam(':nom', $nom);
$stmt->bindParam(':email', $email);
$stmt->execute();

echo "Utilisateur ajouté avec succès !";
```

---

## 3. Lecture (SELECT)

```php
$stmt = $pdo->prepare("SELECT * FROM utilisateurs");

$stmt->execute();

$users = $stmt->fetchAll(PDO::FETCH_ASSOC);
foreach($users as $user){
    echo "$user['name'] : $user['email']";
}
```

---

## 4. Mise à jour (UPDATE)

```php
$stmt = $pdo->prepare("UPDATE utilisateurs SET nom = :nom WHERE email = :email");

$nom = "Durand";
$email = "dupont@example.com";

$stmt->bindParam(':nom', $nom);
$stmt->bindParam(':email', $email);
$stmt->execute();

echo "Mise à jour effectuée !";
```

---

## 5. Suppression (DELETE)

```php
$stmt = $pdo->prepare("DELETE FROM utilisateurs WHERE email = :email");

$email = "dupont@example.com";
$stmt->bindParam(':email', $email);
$stmt->execute();

echo "Utilisateur supprimé !";
```

---

### Remarque sur `bindParam`
- `bindParam()` ne peut lier que des variables (et non des valeurs directes comme des chaînes de texte).
- Pour une liaison plus flexible, `bindValue()` peut être utilisé   
(exemple : `$stmt->bindValue(':nom', 'Dupont')`).

---

### Bonnes pratiques
✅ Toujours utiliser des requêtes préparées pour éviter les injections SQL.  
✅ Activer `PDO::ERRMODE_EXCEPTION` pour un meilleur débogage.  

