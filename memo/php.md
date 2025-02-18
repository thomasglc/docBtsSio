# 📌 Mémo PHP

## Les Bases

### Structure de base
```php
<?php
    // Code PHP ici
?>
```

### Variables et Types
```php
$nom = "Thomas";           // Chaîne de caractères
$age = 25;                // Nombre entier
$prix = 19.99;            // Nombre décimal
$estVrai = true;          // Booléen
$fruits = ["pomme", "banane"]; // Tableau
```

### Conditions (if / else)
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

### Boucles
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

### Fonctions
```php
function direBonjour($nom) {
    return "Bonjour " . $nom;
}
echo direBonjour("Thomas"); // Affiche: Bonjour Thomas
```

### Tableaux
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

### Chaînes de caractères
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

### Inclusion de fichiers
```php
require 'config.php';     // Arrête le script si erreur
include 'header.php';     // Continue même si erreur
require_once 'config.php'; // Vérifie si déjà inclus
```

### Sessions et Cookies
```php
// Sessions
session_start();
$_SESSION['user'] = "Thomas";
echo $_SESSION['user'];

// Cookies
setcookie("utilisateur", "Thomas", time() + 3600); // Expire dans 1h
echo $_COOKIE['utilisateur'];
```

<!-- ### Connexion Base de données (PDO)
```php
try {
    $pdo = new PDO(
        "mysql:host=localhost;dbname=test",
        "utilisateur",
        "mot_de_passe"
    );
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo "Erreur : " . $e->getMessage();
}
```

### Requêtes SQL avec PDO
```php
// Sélection
$stmt = $pdo->query("SELECT * FROM utilisateurs");
while ($row = $stmt->fetch()) {
    echo $row['nom'];
}

// Insertion sécurisée
$stmt = $pdo->prepare("INSERT INTO utilisateurs (nom, age) VALUES (?, ?)");
$stmt->execute(["Thomas", 25]);
```  -->