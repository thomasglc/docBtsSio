---
outline: deep
---

# TP 2 — Sécuriser les mots de passe

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Durée : 1 heure" />  <Badge type="danger" text="PHP + bcrypt" />

::: info Contexte
En TP 1, vous avez créé une mini-API PHP de gestion de notes personnelles. Elle fonctionne, mais n'importe qui peut lire et créer des notes : il n'y a aucune notion d'utilisateur.

Ce TP ajoute la première brique d'authentification : l'inscription et la connexion avec un mot de passe haché via **bcrypt**. La semaine prochaine, vous ajouterez les tokens JWT pour protéger les routes de notes.
:::

---

## Mission 1 — Préparer la structure des données

### Tâche 1.1 — Créer le fichier `data/users.json`

Dans votre dossier `notes-app/data/`, créez un fichier `users.json` contenant simplement un tableau vide :

```json
[]
```

Ce fichier servira à stocker les comptes utilisateurs.

### Tâche 1.2 — Nouvelle arborescence du projet

Votre projet doit maintenant ressembler à ceci :

```
notes-app/
├── api/
│   ├── notes.php       ← existant (TP 1)
│   ├── register.php    ← à créer
│   └── login.php       ← à créer
├── data/
│   ├── notes.json      ← existant (TP 1)
│   └── users.json      ← créé à l'instant
└── index.html          ← existant, à modifier en Mission 4
```

::: warning Vérifiez les permissions
Assurez-vous que le serveur web (Apache/PHP) a le droit d'écrire dans le dossier `data/`. Sur XAMPP, ce n'est généralement pas un problème si le projet est dans `htdocs/`.
:::

---

## Mission 2 — Créer la route d'inscription

### Tâche 2.1 — Créer `api/register.php`

Créez le fichier `notes-app/api/register.php` avec le code suivant :

```php
<?php
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

foreach ($users as $u) {
    if ($u['email'] === $body['email']) {
        http_response_code(409);
        echo json_encode(['erreur' => 'Cet email est déjà utilisé']);
        exit;
    }
}

$nouveauUser = [
    'id'            => count($users) + 1,
    'email'         => $body['email'],
    'password_hash' => password_hash($body['password'], PASSWORD_BCRYPT)
];
$users[] = $nouveauUser;
file_put_contents($fichier, json_encode($users, JSON_PRETTY_PRINT));

http_response_code(201);
echo json_encode(['message' => 'Compte créé', 'email' => $nouveauUser['email']]);
```

::: info Que fait ce code ?
1. Il lit le body JSON de la requête (`php://input`)
2. Il vérifie que `email` et `password` sont bien présents
3. Il charge `users.json` et parcourt les comptes existants pour détecter un doublon
4. Si l'email est libre, il crée un objet utilisateur avec `password_hash()` qui génère un hash bcrypt
5. Il sauvegarde la liste mise à jour dans `users.json` et répond `201 Created`

Le mot de passe brut n'est **jamais** écrit dans le fichier.
:::

### Tâche 2.2 — Tester l'inscription avec curl

Ouvrez un terminal et exécutez :

```bash
curl -X POST http://localhost/notes-app/api/register.php \
  -H "Content-Type: application/json" \
  -d '{"email": "alice@example.com", "password": "MonMotDePasse123"}'
```

Vous devez obtenir une réponse similaire à :

```json
{
  "message": "Compte créé",
  "email": "alice@example.com"
}
```

Essayez ensuite la même commande une deuxième fois : vous devez obtenir un `409 Conflict` avec `"Cet email est déjà utilisé"`.

::: tip Vous n'avez pas curl ?
Utilisez l'extension **Thunder Client** dans VS Code, **Postman**, ou l'onglet **Réseau** des DevTools avec un `fetch()` dans la console du navigateur.
:::

### Tâche 2.3 — Vérifier le hash dans `data/users.json`

Ouvrez le fichier `notes-app/data/users.json` avec votre éditeur. Vous devez voir quelque chose comme :

```json
[
  {
    "id": 1,
    "email": "alice@example.com",
    "password_hash": "$2y$12$Xk9mL3p...longueChaine..."
  }
]
```

::: tip 📸 Capture 1
Faites une capture d'écran du fichier `users.json` ouvert dans votre éditeur, avec le hash `$2y$...` clairement visible.
:::

::: danger Règle absolue
Si vous voyez le mot de passe en clair dans ce fichier, quelque chose s'est mal passé. Ne continuez pas avant d'avoir compris pourquoi.
:::

---

## Mission 3 — Créer la route de connexion

### Tâche 3.1 — Créer `api/login.php`

Créez le fichier `notes-app/api/login.php` avec le code suivant :

```php
<?php
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
    if ($u['email'] === $body['email']) {
        $userTrouve = $u;
        break;
    }
}

if ($userTrouve === null || !password_verify($body['password'], $userTrouve['password_hash'])) {
    http_response_code(401);
    echo json_encode(['erreur' => 'Identifiants incorrects']);
    exit;
}

echo json_encode(['message' => 'Connexion réussie', 'email' => $userTrouve['email']]);
// Semaine 3 : on ajoutera le token JWT ici
```

::: info Que fait ce code ?
1. Il lit `email` et `password` dans le body
2. Il parcourt `users.json` pour trouver un utilisateur avec cet email
3. Si l'utilisateur n'existe pas **ou** si `password_verify()` retourne `false`, il répond `401 Unauthorized`
4. Si tout est correct, il répond `200 OK` avec un message de confirmation

Remarquez que le code retourne **le même message d'erreur** que l'email soit inconnu ou que le mot de passe soit faux : c'est intentionnel. Expliquer lequel des deux a échoué aiderait un attaquant à énumérer les comptes existants.
:::

### Tâche 3.2 — Tester les scénarios de connexion

Testez les deux cas avec curl (ou votre outil REST) :

**Bon mot de passe :**
```bash
curl -X POST http://localhost/notes-app/api/login.php \
  -H "Content-Type: application/json" \
  -d '{"email": "alice@example.com", "password": "MonMotDePasse123"}'
```

**Mauvais mot de passe :**
```bash
curl -X POST http://localhost/notes-app/api/login.php \
  -H "Content-Type: application/json" \
  -d '{"email": "alice@example.com", "password": "mauvaisMotDePasse"}'
```

Notez vos observations dans le tableau suivant :

| Question | Votre réponse |
|---|---|
| Status code avec le bon mot de passe | |
| Corps de la réponse avec le bon mot de passe | |
| Status code avec un mauvais mot de passe | |
| Corps de la réponse avec un mauvais mot de passe | |

::: tip 📸 Capture 2
Faites une capture d'écran montrant les deux requêtes et leurs réponses dans votre outil REST (ou dans le terminal).
:::

### Tâche 3.3 — Tester avec un email inexistant

Envoyez une requête de connexion avec un email qui n'existe pas dans `users.json` :

```bash
curl -X POST http://localhost/notes-app/api/login.php \
  -H "Content-Type: application/json" \
  -d '{"email": "inconnu@example.com", "password": "nimportequoi"}'
```

| Question | Votre réponse |
|---|---|
| Quel code HTTP obtenez-vous ? | |
| Le message d'erreur est-il différent du cas "mauvais mot de passe" ? | |
| Pourquoi est-ce important que les messages soient identiques ? | |

---

## Mission 4 — Brancher le client JS

### Tâche 4.1 — Modifier `index.html`

Remplacez (ou complétez) le contenu de votre `index.html` par le code suivant. Il ajoute deux formulaires : inscription et connexion.

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Notes App</title>
  <style>
    body { font-family: sans-serif; max-width: 600px; margin: 40px auto; padding: 0 16px; }
    h2 { margin-top: 2rem; }
    form { display: flex; flex-direction: column; gap: 8px; max-width: 320px; }
    input { padding: 6px; font-size: 1rem; }
    button { padding: 8px; cursor: pointer; }
    #msg-register, #msg-login { margin-top: 8px; font-weight: bold; }
  </style>
</head>
<body>

  <h1>Notes App</h1>

  <h2>Inscription</h2>
  <form id="form-register">
    <input type="email" id="reg-email" placeholder="Email" required>
    <input type="password" id="reg-password" placeholder="Mot de passe" required>
    <button type="submit">Créer un compte</button>
  </form>
  <p id="msg-register"></p>

  <h2>Connexion</h2>
  <form id="form-login">
    <input type="email" id="login-email" placeholder="Email" required>
    <input type="password" id="login-password" placeholder="Mot de passe" required>
    <button type="submit">Se connecter</button>
  </form>
  <p id="msg-login"></p>

  <script>
    const API = 'http://localhost/notes-app/api';

    document.getElementById('form-register').addEventListener('submit', async (e) => {
      e.preventDefault();
      const email    = document.getElementById('reg-email').value;
      const password = document.getElementById('reg-password').value;
      const msgEl    = document.getElementById('msg-register');

      try {
        const res  = await fetch(`${API}/register.php`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email, password })
        });
        const data = await res.json();
        msgEl.style.color = res.ok ? 'green' : 'red';
        msgEl.textContent = res.ok ? data.message : data.erreur;
      } catch (err) {
        msgEl.style.color = 'red';
        msgEl.textContent = 'Erreur réseau';
      }
    });

    document.getElementById('form-login').addEventListener('submit', async (e) => {
      e.preventDefault();
      const email    = document.getElementById('login-email').value;
      const password = document.getElementById('login-password').value;
      const msgEl    = document.getElementById('msg-login');

      try {
        const res  = await fetch(`${API}/login.php`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email, password })
        });
        const data = await res.json();
        msgEl.style.color = res.ok ? 'green' : 'red';
        msgEl.textContent = res.ok ? data.message + ' (' + data.email + ')' : data.erreur;
      } catch (err) {
        msgEl.style.color = 'red';
        msgEl.textContent = 'Erreur réseau';
      }
    });
  </script>
</body>
</html>
```

### Tâche 4.2 — Tester le parcours complet dans le navigateur

Ouvrez `http://localhost/notes-app/index.html` et effectuez les trois tests suivants :

1. **Inscription** : remplissez le formulaire avec un nouvel email et un mot de passe, cliquez sur "Créer un compte". Vous devez voir le message vert "Compte créé".
2. **Connexion réussie** : connectez-vous avec les mêmes identifiants. Vous devez voir "Connexion réussie".
3. **Mauvais mot de passe** : retentez la connexion avec un mauvais mot de passe. Vous devez voir le message rouge "Identifiants incorrects".

::: tip 📸 Capture 3
Faites une capture d'écran du navigateur montrant au moins un message de succès (vert) et un message d'erreur (rouge) après les tests.
:::

---

## Mission 5 — Comprendre les attaques

### Tâche 5.1 — Simuler une fuite de base de données

Imaginez qu'un attaquant obtienne une copie de `data/users.json`.

Ouvrez le fichier et répondez aux questions suivantes :

| Question | Votre réponse |
|---|---|
| Que voit l'attaquant pour chaque utilisateur ? | |
| Peut-il lire directement les mots de passe ? | |
| Avec MD5 (`md5($password)` stocké en base), que pourrait-il faire ? | |
| Avec bcrypt, pourquoi est-ce beaucoup plus difficile ? | |

::: info MD5 vs bcrypt
**MD5** est une fonction de hachage rapide : un ordinateur moderne peut tester des **milliards de mots de passe par seconde** contre un hash MD5 (attaque par dictionnaire ou rainbow table).

**bcrypt** est volontairement lent et intègre un paramètre de coût (le `12` dans `$2y$12$...`). Il est conçu pour que tester un seul mot de passe prenne plusieurs millisecondes, ce qui rend une attaque par force brute des centaines de milliers de fois plus lente.
:::

### Tâche 5.2 — Utiliser le hash comme mot de passe

Copiez la valeur complète du champ `password_hash` depuis `users.json` (la chaine qui commence par `$2y$12$...`).

Essayez de vous connecter en envoyant ce hash comme valeur du champ `password` :

```bash
curl -X POST http://localhost/notes-app/api/login.php \
  -H "Content-Type: application/json" \
  -d '{"email": "alice@example.com", "password": "$2y$12$..."}'
```

| Question | Votre réponse |
|---|---|
| Quel code HTTP obtenez-vous ? | |
| La connexion a-t-elle réussi ? | |
| Pourquoi `password_verify()` refuse-t-il le hash lui-même comme mot de passe ? | |

::: warning Pourquoi cette attaque échoue
`password_verify($motDePasse, $hash)` compare un mot de passe en clair avec un hash stocké. Fournir le hash comme mot de passe revient à hasher un hash : le résultat est complètement différent du hash stocké. Il ne suffit pas de connaître le hash pour se connecter.
:::

---

## Questions de réflexion

Répondez aux questions suivantes dans votre compte-rendu :

1. Pourquoi `password_verify()` est-il préférable à `md5($password) === $stored_hash` ?

2. Que signifie le `12` dans `$2y$12$...` ?

3. En l'état, si quelqu'un connaît l'URL de `/api/register.php`, peut-il créer autant de comptes qu'il veut ? Que faudrait-il ajouter pour limiter cela ?

4. Pourquoi la route `/api/login.php` ne renvoie-t-elle pas encore les notes de l'utilisateur connecté ? Que manque-t-il pour que le serveur sache, à la prochaine requête, que c'est bien Alice qui demande ses notes ?

---

## Récapitulatif

| Élément | Ce qu'on a ajouté |
|---|---|
| `POST /api/register.php` | Création de compte avec hash bcrypt, vérification des doublons, réponse 201 |
| `POST /api/login.php` | Vérification des identifiants avec `password_verify()`, réponse 200 ou 401 |
| `data/users.json` | Stockage persistant des comptes (id, email, password_hash) |
| `password_hash()` / `password_verify()` | Hachage sécurisé et vérification sans jamais stocker le mot de passe en clair |

::: info Semaine prochaine
Le serveur répond "Connexion réussie" mais le client ne peut pas encore prouver son identité sur les requêtes suivantes. En TP 3, vous ajouterez les **tokens JWT** : à la connexion, le serveur génèrera un token signé que le client joindra à chaque requête pour accéder à ses notes.
:::
