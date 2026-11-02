---
outline: deep
---

# TP 5 - Attaquer et corriger sa propre API

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Durée : 1 heure" />  <Badge type="danger" text="PHP + PDO + MySQL" />

::: info Contexte
Votre API est maintenant protégée par authentification (JWT). Mais l'authentification n'est qu'**une** brique de sécurité. Pour aller plus loin, l'application passe d'un stockage en fichiers JSON à une **base de données MySQL**.

Le code migré vous est fourni. Avant de le « mettre en production », vous allez l'**auditer** comme le ferait un attaquant : il contient **trois failles classiques** (injection SQL, XSS, CORS trop permissif). Vous allez les exploiter sur votre propre application, puis les corriger.
:::

::: danger Cadre du TP
Vous attaquez **uniquement votre propre application**, en local, sur votre machine. Tester des failles sur un site dont on n'est pas propriétaire est **illégal**.
:::

---

## Mission 1 - Migrer vers une base de données

### Tâche 1.1 - Créer la base avec phpMyAdmin

Ouvrez **phpMyAdmin** (`http://localhost/phpmyadmin`), onglet **Importer**, et importez le script suivant (ou collez-le dans l'onglet **SQL**) :

```sql
DROP DATABASE IF EXISTS notes_app;
CREATE DATABASE notes_app CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE notes_app;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE notes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    texte VARCHAR(1000) NOT NULL,
    id_utilisateur INT NOT NULL,
    FOREIGN KEY (id_utilisateur) REFERENCES users (id)
);

-- Comptes de test (mots de passe : MonMotDePasse123 et MotDePasseDeBob)
INSERT INTO users (id, email, password_hash) VALUES
    (1, 'alice@example.com', '$2y$10$s6KFh7OKjuhSI2NrmKm97.w0B20OgxDPZLsKDY4zGcjvo1gQSusqW'),
    (2, 'bob@example.com',   '$2y$10$YmksD6sDQHPy/0bd2ll5resdLOUVGd5joVe/wlaj3pfIocJktBmtq');

INSERT INTO notes (texte, id_utilisateur) VALUES
    ('Code du casier : 4821', 1),
    ('Rendre le dossier de projet avant vendredi', 1),
    ('Acheter un câble HDMI', 2);
```

### Tâche 1.2 - Configurer la connexion

Complétez `config.php` avec les informations de connexion (valeurs par défaut de XAMPP / WAMP) :

```php
<?php
define('JWT_SECRET', 'votre-cle-secrete-longue-et-aleatoire-ici');
define('JWT_EXPIRATION', 3600);

// Connexion à la base de données
define('DB_HOST', 'localhost');
define('DB_PORT', 3306);
define('DB_NAME', 'notes_app');
define('DB_USER', 'root');
define('DB_PASS', '');
```

### Tâche 1.3 - Un fichier de connexion db.php

Créez `api/db.php` :

```php
<?php
require_once __DIR__ . '/../config.php';

// Ouvre une connexion PDO à la base notes_app
function connexion(): PDO
{
    $dsn = 'mysql:host=' . DB_HOST . ';port=' . DB_PORT . ';dbname=' . DB_NAME . ';charset=utf8mb4';
    $pdo = new PDO($dsn, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    return $pdo;
}
```

### Tâche 1.4 - Récupérer le code migré

Remplacez le contenu de vos fichiers par les versions ci-dessous, qui lisent et écrivent maintenant dans la base. **Un fichier `api/cors.php`** regroupe les en-têtes communs :

```php
<?php
// api/cors.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}
```

**`api/login.php`** interroge la table `users` :

```php
<?php
require_once __DIR__ . '/cors.php';
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/../vendor/autoload.php';

use Firebase\JWT\JWT;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); echo json_encode(['erreur' => 'Méthode non autorisée']); exit; }

$body = json_decode(file_get_contents('php://input'), true);

if (empty($body['email']) || empty($body['password'])) {
    http_response_code(400);
    echo json_encode(['erreur' => 'Email et mot de passe obligatoires']);
    exit;
}

$pdo = connexion();

$sql = "SELECT * FROM users WHERE email = '" . $body['email'] . "'";
$userTrouve = $pdo->query($sql)->fetch(PDO::FETCH_ASSOC);

if (!$userTrouve) {
    http_response_code(401);
    echo json_encode(['erreur' => 'Identifiants incorrects']);
    exit;
}

$now = time();
$payload = ['sub' => (int) $userTrouve['id'], 'email' => $userTrouve['email'], 'iat' => $now, 'exp' => $now + JWT_EXPIRATION];
echo json_encode(['token' => JWT::encode($payload, JWT_SECRET, 'HS256')]);
```

::: info Les autres fichiers
`register.php` et `notes.php` sont également migrés vers la base. Votre professeur vous fournit le projet complet migré. `auth.php` (le middleware du TP 4) ne change pas.
:::

### Tâche 1.5 - Vérifier que tout fonctionne

Ouvrez l'application, connectez-vous avec `alice@example.com` / `MonMotDePasse123`. Vous devez voir les notes d'Alice.

::: tip 📸 Capture 1
L'application fonctionnelle après migration, notes d'Alice affichées.
:::

---

## Mission 2 - L'injection SQL sur le login

### Tâche 2.1 - Lire la requête de connexion

Regardez cette ligne de `login.php` :

```php
$sql = "SELECT * FROM users WHERE email = '" . $body['email'] . "'";
```

L'email saisi est **collé directement** dans la requête SQL. Avec `alice@example.com`, la requête devient :

```sql
SELECT * FROM users WHERE email = 'alice@example.com'
```

Mais l'email est une **saisie libre**. Que se passe-t-il si elle contient des caractères SQL ?

### Tâche 2.2 - Exploiter la faille

Sur la page de connexion, saisissez dans le champ **Email** :

```
' OR '1'='1' --
```

et **n'importe quoi** comme mot de passe. Validez.

| Question | Votre réponse |
|---|---|
| Êtes-vous connecté ? Sous quel compte ? | |
| Avez-vous eu besoin du bon mot de passe ? | |

::: info Pourquoi ça marche
La requête envoyée devient :
```sql
SELECT * FROM users WHERE email = '' OR '1'='1' -- '
```
`'1'='1'` est toujours vrai : la requête renvoie **tous les utilisateurs**. Le code prend le **premier** (Alice) et vous connecte. Le `--` transforme la fin de la ligne en commentaire SQL.
:::

::: tip 📸 Capture 2
La connexion réussie en tant qu'Alice, obtenue avec la saisie d'injection et sans son mot de passe.
:::

### Tâche 2.3 - Corriger avec une requête préparée

Remplacez le bloc vulnérable de `login.php` par une **requête préparée**, et rétablissez la vérification du mot de passe avec `password_verify()` :

```php
$pdo = connexion();

// L'email est envoyé comme donnée, jamais comme code
$requete = $pdo->prepare('SELECT id, email, password_hash FROM users WHERE email = ?');
$requete->execute([$body['email']]);
$userTrouve = $requete->fetch(PDO::FETCH_ASSOC);

// On revérifie toujours le mot de passe
if (!$userTrouve || !password_verify($body['password'], $userTrouve['password_hash'])) {
    http_response_code(401);
    echo json_encode(['erreur' => 'Identifiants incorrects']);
    exit;
}
```

::: info Le `?` est un emplacement
Avec `prepare()` et `execute()`, la valeur est envoyée **séparément** de la requête. Le SGBD la traite comme une donnée : même `' OR '1'='1' --` est cherché **tel quel** comme email, et ne correspond à personne.
:::

### Tâche 2.4 - Vérifier la correction

Retentez l'injection `' OR '1'='1' --`. Vous devez maintenant obtenir **401 Identifiants incorrects**. Vérifiez qu'une connexion normale (bon email + bon mot de passe) fonctionne toujours.

---

## Mission 3 - Le XSS dans l'affichage des notes

### Tâche 3.1 - Injecter du HTML dans une note

Connectez-vous normalement, puis ajoutez une note contenant exactement :

```html
<img src=x onerror="alert('XSS !')">
```

Rechargez la liste des notes.

| Question | Votre réponse |
|---|---|
| Que se passe-t-il à l'affichage de la note ? | |
| Le texte de la note s'affiche-t-il, ou autre chose ? | |

::: danger Le script s'exécute
Une boîte d'alerte s'ouvre. Le navigateur a interprété votre note comme du **HTML**, et exécuté le JavaScript du `onerror`. Un attaquant pourrait, à la place, voler le token dans le `localStorage` et le laisser exécuter dans le navigateur **des autres utilisateurs**.
:::

### Tâche 3.2 - Trouver la cause

Regardez la fonction `chargerNotes()` dans `index.html` :

```javascript
liste.innerHTML += `<li>#${note.id} ${note.texte}</li>`;
```

`innerHTML` **interprète le HTML**. Le texte de la note est inséré comme du code, pas comme du texte.

### Tâche 3.3 - Corriger avec textContent

Remplacez la construction de chaque `<li>` pour insérer le texte avec `textContent` :

```javascript
notes.forEach(note => {
  const li = document.createElement('li');
  li.textContent = '#' + note.id + ' ' + note.texte;
  liste.appendChild(li);
});
```

::: info textContent affiche du texte, pas du HTML
Avec `textContent`, les caractères `<` et `>` sont affichés **tels quels**. La note `<img src=x ...>` apparaît comme du texte à l'écran, et rien ne s'exécute.
:::

### Tâche 3.4 - Vérifier la correction

Rechargez la page. L'ancienne note piégée doit maintenant s'**afficher comme du texte**, sans ouvrir d'alerte.

::: tip 📸 Capture 3
La note `<img src=x onerror=...>` affichée **comme du texte** après correction, sans boîte d'alerte.
:::

::: warning Et côté serveur ?
Côté PHP, la bonne pratique équivalente est `htmlspecialchars($texte)` avant d'afficher une donnée venue d'un utilisateur. Ici, l'affichage se fait côté client, donc on sécurise côté client avec `textContent`.
:::

---

## Mission 4 - CORS : qui a le droit d'appeler l'API ?

### Tâche 4.1 - Observer le CORS actuel

Dans `api/cors.php`, l'en-tête est :

```php
header('Access-Control-Allow-Origin: *');
```

Le `*` autorise **n'importe quel site** à appeler votre API depuis un navigateur.

### Tâche 4.2 - Tester depuis une autre page

Ouvrez un nouvel onglet sur une page quelconque (par exemple `https://www.google.fr`), ouvrez la console (F12) et exécutez :

```javascript
fetch('http://localhost/notes-app/api/login.php', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email: 'alice@example.com', password: 'x' })
}).then(r => console.log('Réponse reçue, statut', r.status));
```

Avec `*`, le navigateur laisse passer la réponse : une page extérieure peut dialoguer avec votre API.

### Tâche 4.3 - Restreindre l'origine

Remplacez le `*` par l'origine de **votre** application :

```php
header('Access-Control-Allow-Origin: http://localhost');
```

Refaites le test de la Tâche 4.2 depuis Google : le navigateur **bloque** maintenant la lecture de la réponse (erreur CORS dans la console).

| Question | Votre réponse |
|---|---|
| Quel message apparaît dans la console depuis Google ? | |
| L'application sur `http://localhost` fonctionne-t-elle toujours ? | |

::: warning CORS ne protège pas tout
Le CORS est une sécurité **du navigateur**. Un attaquant avec `curl` ou Postman **ignore** le CORS. La vraie protection des données reste le **token vérifié côté serveur** (TP 4). Le CORS limite seulement quels **sites web** peuvent appeler l'API depuis un navigateur.
:::

---

## Bonus - Sortir les secrets du code

La clé `JWT_SECRET` et le mot de passe de la base sont écrits en dur dans `config.php`. Si ce fichier est poussé sur GitHub, ils sont exposés.

1. Créez un fichier `.env` à la racine du projet :

```
JWT_SECRET=X7k#9pLqR2mVzW8n_changez_moi
DB_PASS=
```

2. Ajoutez `.env` à votre `.gitignore`.
3. Cherchez comment lire ces valeurs en PHP (par exemple avec la librairie `vlucas/phpdotenv`, ou une simple fonction qui lit le fichier).

::: info Pourquoi
Le code (versionné, partagé) et les secrets (propres à chaque environnement) doivent être **séparés**. On ne met jamais de clé ni de mot de passe dans un fichier suivi par Git.
:::

---

## Questions de réflexion

Répondez dans votre compte-rendu :

1. Pourquoi une requête préparée empêche-t-elle l'injection SQL, alors que la concaténation ne le fait pas ?
2. Quelle est la différence entre `innerHTML` et `textContent` du point de vue de la sécurité ?
3. Un camarade dit : « le CORS suffit à protéger mon API ». A-t-il raison ? Pourquoi ?
4. Les trois failles de ce TP ont un point commun. Lequel ?

---

## Récapitulatif

| Faille | Exploitation | Correction |
|---|---|---|
| **Injection SQL** | `' OR '1'='1' --` dans le login → connexion sans mot de passe | Requête préparée (`prepare` / `execute`) + `password_verify()` |
| **XSS** | `<img src=x onerror=...>` dans une note → script exécuté | `textContent` (client) ou `htmlspecialchars()` (serveur) |
| **CORS trop ouvert** | `*` → n'importe quel site appelle l'API | `Access-Control-Allow-Origin` limité à son origine |
| **Secrets en dur** | Clé visible sur GitHub | Fichier `.env` dans `.gitignore` |

::: info La suite
La semaine prochaine, vous situerez ces failles dans le **OWASP Top 10**, le classement de référence des risques de sécurité web, et vous ferez un audit croisé de l'application d'un autre binôme.
:::
