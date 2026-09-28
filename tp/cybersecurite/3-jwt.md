---
outline: deep
---

# TP 3 - Les tokens JWT

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Durée : 1 heure" />  <Badge type="danger" text="PHP + JWT + localStorage" />

::: info Contexte
A la fin du TP 2, votre mini-API de gestion de notes personnelles dispose de :
- `notes-app/api/notes.php` - GET/POST sans authentification
- `notes-app/api/register.php` - création de compte avec `password_hash()`
- `notes-app/api/login.php` - vérification des identifiants avec `password_verify()`, renvoie 200 + message mais **pas encore de token**
- `notes-app/data/notes.json` et `notes-app/data/users.json`
- `notes-app/index.html` - client JS avec formulaires inscription/connexion

Dans ce TP, vous allez ajouter la génération d'un JWT (JSON Web Token) à la connexion et son stockage côté client.
:::

---

## Mission 1 - Explorer un JWT sur jwt.io

### Tâche 1.1 - Ouvrir jwt.io

Ouvrez [https://jwt.io](https://jwt.io) dans votre navigateur.

### Tâche 1.2 - Observer le JWT d'exemple

Sur la page, un JWT d'exemple est déjà présent dans la zone de gauche. Observez les trois parties colorées :

- **Rouge** - le Header (en-tête)
- **Mauve/violet** - le Payload (données)
- **Bleu** - la Signature

Chaque partie est séparée par un point `.`. La zone de droite ("Decoded") montre le contenu décodé de chaque partie.

### Tâche 1.3 - Modifier le payload

Dans la partie "Decoded" à droite, section "Payload", modifiez la valeur du champ `"name"` par votre prénom.

Observez que le token encodé (à gauche) change instantanément dès que vous modifiez le payload.

### Tâche 1.4 - Questions de compréhension

Complétez le tableau suivant après vos observations :

| Question | Votre réponse |
|---|---|
| Quel algorithme est utilisé dans le header ? | |
| Que contient le payload par défaut ? | |
| La modification du payload invalide-t-elle la signature ? | |
| Peut-on lire le payload sans connaître la clé secrète ? | |

::: warning Base64 n'est pas du chiffrement
Le payload d'un JWT est simplement **encodé en Base64**, pas chiffré. N'importe qui peut le décoder sans connaître la clé secrète. Ne mettez **jamais** un mot de passe, des données bancaires ou toute information confidentielle dans le payload d'un JWT.
:::

---

## Mission 2 - Installer firebase/php-jwt

::: info Composer sur Windows avec WAMP
Composer est un gestionnaire de dépendances PHP distinct de WAMP. Il se peut qu'il ne soit pas encore installé sur votre machine, et que PHP (inclus dans WAMP) ne soit pas accessible depuis le terminal. Suivez les étapes ci-dessous dans l'ordre.
:::

### Tâche 2.1 - Vérifier si Composer est déjà installé

Ouvrez PowerShell (touche Windows, tapez `powershell`) et exécutez :

```bash
composer --version
```

- Si vous obtenez `Composer version 2.x.x` : passez directement à la tâche 2.3.
- Si vous obtenez une erreur "n'est pas reconnu" : suivez la tâche 2.2.

### Tâche 2.2 - Installer Composer sur Windows

1. Téléchargez l'installeur Windows sur **[https://getcomposer.org/Composer-Setup.exe](https://getcomposer.org/Composer-Setup.exe)**
2. Lancez le fichier `.exe` téléchargé
3. L'installeur détecte automatiquement le PHP de WAMP. Si ce n'est pas le cas, parcourez jusqu'à l'exécutable PHP de WAMP, généralement situé ici :
   ```
   C:\wamp64\bin\php\php8.x.x\php.exe
   ```
4. Terminez l'installation (laissez toutes les options par défaut)
5. **Fermez et rouvrez PowerShell** (nécessaire pour que le PATH soit pris en compte)
6. Vérifiez l'installation :
   ```bash
   composer --version
   ```

::: warning PHP dans le PATH
Si Composer est installé mais que les commandes PHP échouent, il faut ajouter manuellement le dossier PHP de WAMP au PATH Windows : Panneau de configuration > Système > Paramètres système avancés > Variables d'environnement > `Path` > Ajouter `C:\wamp64\bin\php\php8.x.x\`.
:::

### Tâche 2.3 - Ouvrir un terminal dans le dossier du projet

Dans PowerShell, naviguez jusqu'au dossier `notes-app` (remplacez le chemin par celui de votre installation WAMP) :

```bash
cd C:\wamp64\www\notes-app
```

### Tâche 2.4 - Installer la librairie

Installez `firebase/php-jwt` (Composer crée automatiquement le `composer.json` si nécessaire) :

```bash
composer require firebase/php-jwt
```

### Tâche 2.5 - Vérifier l'installation

Vérifiez que les fichiers suivants ont bien été créés :

```
notes-app/
├── api/
│   ├── login.php
│   ├── notes.php
│   └── register.php
├── data/
│   ├── notes.json
│   └── users.json
├── vendor/              ← nouveau
│   └── ...
├── composer.json        ← nouveau
├── composer.lock        ← nouveau
└── index.html
```

::: tip 📸 Capture 1
Faites une capture d'écran du terminal avec la commande `composer require firebase/php-jwt` et la confirmation d'installation réussie.
:::

---

## Mission 3 - Générer un JWT a la connexion

### Tâche 3.1 - Créer le fichier de configuration

Créez un fichier `config.php` a la racine de `notes-app` :

```php
<?php
define('JWT_SECRET', 'votre-cle-secrete-longue-et-aleatoire-ici');
define('JWT_EXPIRATION', 3600); // 1 heure en secondes
```

::: warning Clé secrète
Choisissez une clé longue et difficile a deviner. Dans un vrai projet, elle serait stockée dans une variable d'environnement, jamais en dur dans le code source.
:::

### Tâche 3.2 - Modifier login.php

Remplacez le contenu de `api/login.php` par le code suivant :

```php
<?php
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../config.php';

use Firebase\JWT\JWT;

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }
if ($_SERVER['REQUEST_METHOD'] !== 'POST') { http_response_code(405); echo json_encode(['erreur' => 'Méthode non autorisée']); exit; }

$body = json_decode(file_get_contents('php://input'), true);

if (empty($body['email']) || empty($body['password'])) {
    http_response_code(400);
    echo json_encode(['erreur' => 'Email et mot de passe obligatoires']);
    exit;
}

$fichier = __DIR__ . '/../data/users.json';
$users   = json_decode(file_get_contents($fichier), true) ?? [];

$userTrouve = null;
foreach ($users as $u) {
    if ($u['email'] === $body['email']) { $userTrouve = $u; break; }
}

if ($userTrouve === null || !password_verify($body['password'], $userTrouve['password_hash'])) {
    http_response_code(401);
    echo json_encode(['erreur' => 'Identifiants incorrects']);
    exit;
}

$now     = time();
$payload = [
    'sub'   => $userTrouve['id'],
    'email' => $userTrouve['email'],
    'iat'   => $now,
    'exp'   => $now + JWT_EXPIRATION,
];

$token = JWT::encode($payload, JWT_SECRET, 'HS256');

echo json_encode(['token' => $token]);
```

::: info Que fait ce code ?
- `require_once '../vendor/autoload.php'` - charge automatiquement la librairie `firebase/php-jwt`
- `JWT::encode($payload, $key, 'HS256')` - génère le token signé avec l'algorithme HMAC-SHA256
- Le payload contient :
  - `sub` - l'identifiant unique de l'utilisateur (subject)
  - `email` - l'adresse email
  - `iat` - la date de création du token (issued at, timestamp Unix)
  - `exp` - la date d'expiration (timestamp Unix)
:::

### Tâche 3.3 - Tester avec curl ou Postman

Testez la connexion. La réponse doit maintenant contenir un champ `token` :

```bash
curl -X POST http://localhost/notes-app/api/login.php \
  -H "Content-Type: application/json" \
  -d '{"email":"votre@email.com","password":"votre-mdp"}'
```

Réponse attendue :

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0..."
}
```

::: tip 📸 Capture 2
Faites une capture d'écran de la réponse de l'API login dans DevTools ou curl, montrant le champ `"token"` avec la valeur JWT.
:::

### Tâche 3.4 - Vérifier le token sur jwt.io

Copiez le token reçu et collez-le sur [https://jwt.io](https://jwt.io). Vérifiez que le payload contient bien les champs `sub`, `email`, `iat` et `exp`.

::: tip 📸 Capture 3
Faites une capture d'écran du token décodé sur jwt.io avec le payload (sub, email, iat, exp) visible.
:::

---

## Mission 4 - Stocker le token dans le client JS

### Tâche 4.1 - Modifier la fonction connecter() dans index.html

Dans `index.html`, mettez a jour la fonction `connecter()` pour récupérer le token et le stocker dans `localStorage` :

```javascript
async function connecter() {
  const email    = document.getElementById('champ-email').value;
  const password = document.getElementById('champ-mdp').value;

  const reponse = await fetch('http://localhost/notes-app/api/login.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
  });

  const data = await reponse.json();

  if (reponse.ok) {
    localStorage.setItem('token', data.token);
    document.getElementById('statut').textContent = 'Connecté : ' + email;
    chargerNotes();
  } else {
    document.getElementById('statut').textContent = 'Erreur : ' + data.erreur;
  }
}
```

### Tâche 4.2 - Vérifier dans DevTools

1. Rechargez la page et connectez-vous avec votre compte
2. Ouvrez les DevTools (F12)
3. Allez dans l'onglet **Application** (ou **Stockage** selon le navigateur)
4. Dans le menu de gauche, cliquez sur **Local Storage** puis sur votre URL
5. Vérifiez que la clé `token` est présente avec le JWT comme valeur

::: tip 📸 Capture 4
Faites une capture d'écran de DevTools - Application - Local Storage montrant la clé `"token"` avec le JWT stocké.
:::

### Tâche 4.3 - Observer la persistance

Rechargez la page avec F5. Retournez dans DevTools - Application - Local Storage.

Le token est toujours présent. Contrairement a une variable JavaScript qui disparait au rechargement, `localStorage` persiste entre les sessions.

---

## Mission 5 - Inspecter et comprendre le token

### Tâche 5.1 - Lire le token depuis la console

Ouvrez la console DevTools (onglet **Console**) et tapez :

```javascript
localStorage.getItem('token')
```

Vous devez voir le JWT s'afficher dans la console.

### Tâche 5.2 - Décoder le payload manuellement

Toujours dans la console, décodez le payload sans utiliser jwt.io :

```javascript
const token = localStorage.getItem('token');
const payload = JSON.parse(atob(token.split('.')[1]));
console.log(payload);
```

Que voyez-vous ? Identifiez les champs `sub`, `email`, `iat` et `exp`.

::: info Explication du code
- `token.split('.')` - découpe le JWT en 3 parties (header, payload, signature)
- `[1]` - sélectionne la deuxième partie (le payload)
- `atob(...)` - décode le Base64 en texte brut
- `JSON.parse(...)` - convertit le texte JSON en objet JavaScript
:::

### Tâche 5.3 - Calculer la date d'expiration

Convertissez le timestamp `exp` en date lisible :

```javascript
console.log(new Date(payload.exp * 1000));
```

Dans combien de temps le token expirera-t-il ?

::: warning Ne jamais stocker de données sensibles dans le payload
Puisque n'importe qui peut décoder le payload d'un JWT (comme vous venez de le faire en deux lignes), ne mettez jamais dans le payload :
- Un mot de passe
- Des informations bancaires
- Toute donnée confidentielle

Le JWT garantit l'**intégrité** (on ne peut pas falsifier les données sans invalider la signature), pas la **confidentialité**.
:::

---


## Récapitulatif

| Élément | Ce qu'on a fait |
|---|---|
| jwt.io | Explorer la structure d'un JWT et comprendre le Base64 |
| firebase/php-jwt | Installer via Composer |
| `api/login.php` | Génère un JWT signé contenant `sub`, `email`, `iat`, `exp` |
| `index.html` | Stocke le token dans `localStorage` apres connexion |
| DevTools - Application | Vérifier la présence du token |

::: danger A retenir
Un JWT n'est **pas un mécanisme de chiffrement**. Il garantit que les données n'ont pas été altérées (grace a la signature HMAC), mais son contenu est lisible par tous. La prochaine étape (TP 4) sera de vérifier ce token cote serveur pour protéger les routes de l'API.
:::
