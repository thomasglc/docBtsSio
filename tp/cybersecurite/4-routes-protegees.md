---
outline: deep
---

# TP 4 - Sécuriser les routes /notes

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Durée : 1 heure" />  <Badge type="danger" text="PHP + JWT + middleware" />

::: info Contexte
À la fin du TP 3, la connexion renvoie un **JWT** que le client range dans le `localStorage`. Mais la route `GET /notes` répond encore à **tout le monde** : le serveur ne regarde jamais le token.

Dans ce TP, vous allez écrire un **middleware** PHP qui vérifie le token avant de laisser accéder aux notes, faire envoyer le `Bearer token` par le client à chaque requête, et tester les trois cas d'erreur : token **absent**, **modifié** et **expiré**.
:::

À la fin du TP, votre projet ressemblera à ceci :

```
notes-app/
├── api/
│   ├── auth.php        ← nouveau : le middleware
│   ├── login.php       ← existant (TP 3)
│   ├── notes.php       ← à protéger
│   └── register.php    ← existant
├── data/
│   ├── notes.json
│   └── users.json
├── vendor/
├── config.php          ← existant (TP 3)
└── index.html          ← à modifier
```

---

## Mission 1 - Écrire le middleware

### Tâche 1.1 - Créer api/auth.php

Un **middleware** est un bout de code qui s'exécute **avant** une route, comme un videur à l'entrée : il laisse passer la requête ou la renvoie avec une erreur.

Créez le fichier `api/auth.php` :

```php
<?php
// Middleware d'authentification : vérifie le token JWT avant d'accéder à une route protégée
require_once __DIR__ . '/../vendor/autoload.php';
require_once __DIR__ . '/../config.php';

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Firebase\JWT\ExpiredException;
use Firebase\JWT\SignatureInvalidException;

// Arrête la requête avec une erreur 401 Unauthorized
function refuser(string $message): void
{
    http_response_code(401);
    echo json_encode(['erreur' => $message]);
    exit;
}

// Lit l'en-tête Authorization envoyé par le client
function lireEnTeteAuthorization(): string
{
    foreach (getallheaders() as $nom => $valeur) {
        if (strtolower($nom) === 'authorization') {
            return $valeur;
        }
    }
    return $_SERVER['HTTP_AUTHORIZATION'] ?? '';
}

// Renvoie le payload du token s'il est valide, sinon répond 401 et arrête tout
function verifierToken(): object
{
    $entete = lireEnTeteAuthorization();

    if (!str_starts_with($entete, 'Bearer ')) {
        refuser('Token manquant');
    }

    $token = substr($entete, 7); // ce qui suit « Bearer »

    try {
        return JWT::decode($token, new Key(JWT_SECRET, 'HS256'));
    } catch (ExpiredException $e) {
        refuser('Token expiré');
    } catch (SignatureInvalidException $e) {
        refuser('Signature invalide');
    } catch (Exception $e) {
        refuser('Token invalide');
    }
}
```

::: info Que fait ce code ?
- `lireEnTeteAuthorization()` récupère le header `Authorization: Bearer ...` envoyé par le client
- `str_starts_with($entete, 'Bearer ')` vérifie qu'il commence bien par `Bearer `
- `JWT::decode()` recalcule la signature avec la clé secrète **et** vérifie la date d'expiration
- Chaque type d'erreur (`ExpiredException`, `SignatureInvalidException`…) donne un message précis
- Si tout est bon, la fonction **retourne le payload** (`sub`, `email`…) ; sinon elle répond 401 et arrête le script
:::

---

## Mission 2 - Protéger la route des notes

### Tâche 2.1 - Brancher le middleware sur notes.php

Ouvrez `api/notes.php`. Juste après les `header(...)` et la réponse au `OPTIONS`, ajoutez l'appel au middleware. Modifiez aussi la gestion des notes pour tenir compte de l'utilisateur connecté :

```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Le middleware : sans token valide, le script s'arrête ici avec une 401
require_once __DIR__ . '/auth.php';
$utilisateur = verifierToken();

$fichier = __DIR__ . '/../data/notes.json';
$methode = $_SERVER['REQUEST_METHOD'];

if ($methode === 'GET') {

    $notes = json_decode(file_get_contents($fichier), true) ?? [];

    // On ne renvoie que les notes de l'utilisateur connecté
    $mesNotes = [];
    foreach ($notes as $note) {
        if (($note['id_utilisateur'] ?? null) === $utilisateur->sub) {
            $mesNotes[] = $note;
        }
    }
    echo json_encode($mesNotes);

} elseif ($methode === 'POST') {

    $body = json_decode(file_get_contents('php://input'), true);

    if (empty($body['texte'])) {
        http_response_code(400);
        echo json_encode(['erreur' => 'Le champ texte est obligatoire']);
        exit;
    }

    $notes = json_decode(file_get_contents($fichier), true) ?? [];
    $nouvelle = [
        'id'             => count($notes) + 1,
        'texte'          => $body['texte'],
        'id_utilisateur' => $utilisateur->sub
    ];
    $notes[] = $nouvelle;
    file_put_contents($fichier, json_encode($notes, JSON_PRETTY_PRINT));

    http_response_code(201);
    echo json_encode($nouvelle);

} else {
    http_response_code(405);
    echo json_encode(['erreur' => 'Méthode non autorisée']);
}
```

::: info Deux changements importants
1. **La ligne qui protège :** `$utilisateur = verifierToken();`. Tout ce qui est en dessous n'est atteint qu'avec un token valide.
2. **À chacun ses notes :** chaque note enregistre l'`id_utilisateur` (= le claim `sub` du token). Le GET ne renvoie que les notes de l'utilisateur connecté.
:::

::: warning L'id vient du token, jamais du client
L'identifiant de l'utilisateur est lu dans le **token signé** (`$utilisateur->sub`), pas dans l'URL ni dans le body. Un utilisateur ne peut donc pas réclamer les notes d'un autre : il ne peut pas modifier le token sans casser la signature.
:::

### Tâche 2.2 - Vérifier que la route est fermée

Sans rien envoyer, testez la route avec curl (ou Thunder Client / Postman) :

```bash
curl -i http://localhost/notes-app/api/notes.php
```

Vous devez obtenir un **401 Unauthorized** avec `{"erreur":"Token manquant"}`.

::: tip 📸 Capture 1
La réponse **401 Token manquant** pour un `GET /notes` sans token.
:::

---

## Mission 3 - Envoyer le token depuis le client

### Tâche 3.1 - Une fonction qui joint le token

Dans `index.html`, toutes les requêtes vers les routes protégées doivent envoyer le header `Authorization`. Pour éviter de le répéter, créez une petite fonction qui l'ajoute automatiquement :

```javascript
const API = 'http://localhost/notes-app/api';

// Appelle une route protégée en joignant le token
async function appelerApi(route, options = {}) {
  const token = localStorage.getItem('token');

  const reponse = await fetch(`${API}/${route}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    }
  });

  const data = await reponse.json();

  if (reponse.status === 401) {
    alert('Accès refusé : ' + data.erreur);
    return null;
  }
  return data;
}
```

### Tâche 3.2 - Charger et créer des notes avec le token

Utilisez cette fonction pour lire et ajouter des notes :

```javascript
async function chargerNotes() {
  const notes = await appelerApi('notes.php');
  if (notes === null) return;

  const liste = document.getElementById('liste-notes');
  liste.innerHTML = '';
  notes.forEach(note => {
    const li = document.createElement('li');
    li.textContent = '#' + note.id + ' ' + note.texte;
    liste.appendChild(li);
  });
}

async function ajouterNote(texte) {
  const resultat = await appelerApi('notes.php', {
    method: 'POST',
    body: JSON.stringify({ texte })
  });
  if (resultat === null) return;
  chargerNotes();
}
```

::: info La clé du header
Le token est joint avec `'Authorization': \`Bearer ${token}\``. Le mot `Bearer`, une espace, puis le token : c'est exactement ce que le middleware attend avec `str_starts_with($entete, 'Bearer ')`.
:::

### Tâche 3.3 - Tester le parcours complet

1. Connectez-vous avec un compte créé au TP 3.
2. Ajoutez une note : elle s'affiche.
3. Ouvrez les DevTools (F12) → onglet **Réseau**, cliquez sur la requête `notes.php`, puis sur **Headers**. Repérez le header `Authorization: Bearer ...` dans la requête.

::: warning Mes anciennes notes ont disparu ?
C'est normal : les notes créées avant ce TP n'ont pas de champ `id_utilisateur`, elles n'appartiennent à personne. Seules les notes créées **après connexion** apparaissent. Vous pouvez vider `data/notes.json` en y remettant `[]` pour repartir propre.
:::

::: tip 📸 Capture 2
L'onglet **Réseau** des DevTools, requête `notes.php`, avec le header `Authorization: Bearer ...` visible.
:::

---

## Mission 4 - Tester les trois cas d'erreur

Un middleware ne sert à rien si on ne vérifie pas qu'il **refuse** bien les mauvais tokens. Testez les trois cas.

### Tâche 4.1 - Token absent

Déjà fait en Mission 2 : un `GET /notes` sans header `Authorization` renvoie **401 Token manquant**.

### Tâche 4.2 - Token modifié

Récupérez un token valide (connectez-vous, puis dans la console : `localStorage.getItem('token')`). Changez **un seul caractère** au milieu du token, puis envoyez-le :

```bash
curl -i http://localhost/notes-app/api/notes.php \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1Q...VOTRE_TOKEN_MODIFIE..."
```

| Question | Votre réponse |
|---|---|
| Quel code HTTP obtenez-vous ? | |
| Quel message d'erreur ? | |
| Pourquoi le serveur détecte-t-il la modification ? | |

### Tâche 4.3 - Token expiré

Dans `config.php`, changez temporairement l'expiration à **10 secondes** :

```php
define('JWT_EXPIRATION', 10); // 10 secondes, le temps du test
```

Reconnectez-vous pour obtenir un token tout neuf, **attendez 15 secondes**, puis rechargez la liste des notes.

| Question | Votre réponse |
|---|---|
| Quel code HTTP obtenez-vous ? | |
| Quel message d'erreur ? | |
| Quel claim du token le serveur a-t-il comparé à l'heure actuelle ? | |

::: danger N'oubliez pas de remettre 3600
Après le test, remettez `define('JWT_EXPIRATION', 3600);` dans `config.php`.
:::

::: tip 📸 Capture 3
Les réponses du serveur pour les deux cas : token **modifié** et token **expiré** (votre outil REST ou le terminal).
:::

---

## Questions de réflexion

Répondez dans votre compte-rendu :

1. Pourquoi place-t-on `verifierToken()` **au début** de `notes.php`, et pas à la fin ?
2. Le serveur ne garde aucune session. Comment sait-il, à chaque requête, quel utilisateur fait la demande ?
3. Un étudiant propose de récupérer l'utilisateur avec `GET /notes?user=3` au lieu du token. Pourquoi est-ce une mauvaise idée ?
4. On a protégé `notes.php`. Faut-il aussi protéger `login.php` et `register.php` avec le middleware ? Pourquoi ?

---

## Récapitulatif

| Élément | Ce qu'on a fait |
|---|---|
| `api/auth.php` | Middleware `verifierToken()` : lit le header `Bearer`, vérifie signature et expiration |
| `api/notes.php` | Protégé par le middleware ; ne renvoie que les notes de l'utilisateur connecté |
| `index.html` | Joint `Authorization: Bearer <token>` à chaque requête protégée |
| Tests | 401 pour un token **absent**, **modifié** ou **expiré** |

::: info La suite
Votre API est désormais protégée par authentification. La semaine prochaine, vous allez **attaquer votre propre application** (injection SQL, XSS) pour découvrir les failles qui restent, puis les corriger.
:::
