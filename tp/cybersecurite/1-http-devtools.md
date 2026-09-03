---
outline: deep
---

# TP 1 — Observer le trafic HTTP

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Durée : 1 heure" />  <Badge type="danger" text="PHP + JavaScript + DevTools" />

::: info Contexte
Vous commencez la construction de l'application fil rouge du cours de cybersécurité : une **API de gestion de notes personnelles**. Dans ce premier TP, l'objectif n'est pas encore la sécurité — c'est de **comprendre ce qui se passe** entre le client et le serveur, avant de le sécuriser.
:::

---

## Mission 1 — Mise en place du projet

### Tâche 1.1 — Structure des fichiers

Créez le dossier `notes-app` dans votre répertoire web (htdocs pour XAMPP, www pour Laragon) avec la structure suivante :

```
notes-app/
├── api/
│   └── notes.php
├── data/
│   └── notes.json
└── index.html
```

### Tâche 1.2 — Fichier de données initial

Créez `data/notes.json` avec le contenu suivant :

```json
[
  { "id": 1, "texte": "Première note de test" },
  { "id": 2, "texte": "Deuxième note de test" }
]
```

---

## Mission 2 — Créer l'API PHP

### Tâche 2.1 — Le fichier notes.php

Créez `api/notes.php` :

```php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

$fichier = __DIR__ . '/../data/notes.json';
$methode = $_SERVER['REQUEST_METHOD'];

if ($methode === 'OPTIONS') {
    http_response_code(204);
    exit;
}

if ($methode === 'GET') {

    $notes = json_decode(file_get_contents($fichier), true) ?? [];
    echo json_encode($notes);

} elseif ($methode === 'POST') {

    $body = json_decode(file_get_contents('php://input'), true);

    if (empty($body['texte'])) {
        http_response_code(400);
        echo json_encode(['erreur' => 'Le champ texte est obligatoire']);
        exit;
    }

    $notes = json_decode(file_get_contents($fichier), true) ?? [];
    $nouvelle = [
        'id'    => count($notes) + 1,
        'texte' => $body['texte']
    ];
    $notes[] = $nouvelle;
    file_put_contents($fichier, json_encode($notes));

    http_response_code(201);
    echo json_encode($nouvelle);

} else {
    http_response_code(405);
    echo json_encode(['erreur' => 'Méthode non autorisée']);
}
```

::: info Que fait ce code ?
- `header('Content-Type: application/json')` — indique au client que la réponse est au format JSON
- `$_SERVER['REQUEST_METHOD']` — récupère la méthode HTTP de la requête (GET, POST…)
- `file_get_contents('php://input')` — lit le corps (body) de la requête
- `http_response_code(201)` — envoie le code de statut 201 Created
:::

### Tâche 2.2 — Tester l'API directement

Ouvrez votre navigateur sur `http://localhost/notes-app/api/notes.php`.

Vous devriez voir le contenu JSON de vos deux notes s'afficher directement dans le navigateur.

::: tip 📸 Capture 1
La réponse JSON de l'API affichée dans le navigateur.
:::

---

## Mission 3 — Créer le client JavaScript

### Tâche 3.1 — La page index.html

Créez `index.html` :

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Mes notes</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 600px; margin: 40px auto; padding: 0 20px; }
    ul   { list-style: none; padding: 0; }
    li   { background: #f0f4ff; border-left: 4px solid #3748A0; padding: 10px 14px; margin-bottom: 8px; border-radius: 4px; }
    input  { padding: 8px; width: 70%; border: 1px solid #ccc; border-radius: 4px; }
    button { padding: 8px 16px; background: #3748A0; color: white; border: none; border-radius: 4px; cursor: pointer; }
  </style>
</head>
<body>

  <h1>📝 Mes notes</h1>
  <ul id="liste-notes"></ul>

  <h2>Ajouter une note</h2>
  <input type="text" id="champ-note" placeholder="Votre note..." />
  <button onclick="ajouterNote()">Ajouter</button>

  <script>
    const API = 'http://localhost/notes-app/api/notes.php';

    async function chargerNotes() {
      const reponse = await fetch(API);
      const notes   = await reponse.json();

      const liste = document.getElementById('liste-notes');
      liste.innerHTML = '';
      notes.forEach(note => {
        const li = document.createElement('li');
        li.textContent = note.texte;
        liste.appendChild(li);
      });
    }

    async function ajouterNote() {
      const texte = document.getElementById('champ-note').value;
      if (!texte) return;

      await fetch(API, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ texte })
      });

      document.getElementById('champ-note').value = '';
      chargerNotes();
    }

    chargerNotes();
  </script>

</body>
</html>
```

### Tâche 3.2 — Tester l'application

Ouvrez `http://localhost/notes-app/` dans votre navigateur. Vos deux notes de test doivent s'afficher, et vous devez pouvoir en ajouter une nouvelle.

::: tip 📸 Capture 2
L'interface de l'application avec les notes affichées et le formulaire d'ajout.
:::

---

## Mission 4 — Observer avec DevTools

C'est la mission la plus importante de ce TP : comprendre ce qui se passe **sous le capot**.

### Tâche 4.1 — Ouvrir DevTools

Appuyez sur **F12** → onglet **Réseau** (Network). Videz le contenu avec l'icône 🚫, puis rechargez la page avec **F5**.

### Tâche 4.2 — Analyser la requête GET

Cliquez sur la requête vers `notes.php` dans la liste.

Dans l'onglet **Headers**, répondez aux questions suivantes :

| Question | Votre réponse |
|---|---|
| Quel est le **Request Method** ? | |
| Quel est le **Status Code** ? | |
| Quel est le **Content-Type** de la réponse ? | |

Dans l'onglet **Response**, que contient la réponse ?

::: tip 📸 Capture 3
Onglet Headers de la requête GET vers `notes.php` — Request Method et Status Code visibles.
:::

### Tâche 4.3 — Analyser la requête POST

Ajoutez une nouvelle note via le formulaire, et observez la nouvelle requête dans DevTools.

| Question | Votre réponse |
|---|---|
| Quel est le **Request Method** ? | |
| Quel est le **Status Code** ? | |
| Où se trouve le texte de la note envoyée ? | |

::: tip 📸 Capture 4
Onglet Payload (ou Headers) de la requête POST — body JSON envoyé visible.
:::

### Tâche 4.4 — Ce que ça révèle sur la sécurité

Regardez attentivement les requêtes dans DevTools. En l'état, n'importe qui connaissant l'URL de l'API peut :
- Lire **toutes les notes** avec un simple GET
- **Créer des notes** avec un POST

::: warning Pas d'authentification
Il n'y a aucun contrôle : l'API est entièrement ouverte. C'est exactement le problème qu'on va résoudre progressivement dans les prochains TP.
:::

---

## Mission 5 — Attaquer sa propre API

### Tâche 5.1 — Ouvrir une page sans rapport avec l'application

Ouvrez un **nouvel onglet** et naviguez sur n'importe quelle page — par exemple `https://www.google.fr`.

L'objectif : envoyer une requête à votre API **depuis une page extérieure**, comme le ferait un attaquant.

### Tâche 5.2 — Injecter une note depuis la console

Ouvrez DevTools (F12) → onglet **Console**, puis collez et exécutez ce code :

```js
fetch('http://localhost/notes-app/api/notes.php', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ texte: 'Note injectée depuis Google !' })
})
```

### Tâche 5.3 — Vérifier l'impact

Retournez sur `http://localhost/notes-app/` et rechargez la page.

::: danger La note est là
La note a bien été ajoutée — sans passer par votre interface, sans aucune authentification, depuis une page qui n'a rien à voir avec votre application. N'importe qui connaissant l'URL de votre API peut faire la même chose.
:::

::: tip 📸 Capture 5
L'application affichant la note injectée depuis la console de Google.
:::

---

## Questions de réflexion

Répondez à ces questions **dans votre rapport** :

1. Quelle différence concrète avez-vous observée entre la requête GET et la requête POST dans DevTools ?
2. Où se trouve le texte de la note dans la requête POST — dans l'URL, dans les headers, ou ailleurs ?
3. Si l'application tournait sur un serveur distant sans HTTPS, que pourrait voir quelqu'un qui intercepte le trafic sur le réseau ?
4. Que faudrait-il ajouter à cette API pour qu'elle ne soit accessible qu'à un utilisateur connecté ?

---

## Récapitulatif

| Requête | Ce qu'on a observé |
|---|---|
| `GET /api/notes.php` | Récupère toutes les notes — réponse JSON, code **200 OK** |
| `POST /api/notes.php` | Crée une note — body JSON, code **201 Created** |
| Header `Content-Type: application/json` | Indique le format des données échangées |
| DevTools → Réseau | Inspecte tout le trafic HTTP du navigateur en temps réel |
