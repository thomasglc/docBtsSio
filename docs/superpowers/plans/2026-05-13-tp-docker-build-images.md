# TP 1.5 — Construire ses propres images Docker — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Créer le fichier `tp/docker/1.5-construire-images.md` et l'ajouter à la sidebar, pour un TP de 2h sur la construction d'images Docker avec Dockerfile.

**Architecture:** Deux fichiers à toucher — le nouveau fichier markdown du TP, et `.vitepress/config.mts` pour l'entrée sidebar. Le TP suit la structure des autres TPs Docker : badges, contexte, missions numérotées, captures, récapitulatif, questions de réflexion.

**Tech Stack:** VitePress, Markdown, composants Badge/tip/info/warning VitePress natifs.

---

### Task 1 : Entrée sidebar + squelette du fichier

**Files:**
- Modify: `.vitepress/config.mts:124` (après la ligne `1 - Découverte de Docker`)
- Create: `tp/docker/1.5-construire-images.md`

- [ ] **Step 1 : Ajouter l'entrée dans la sidebar**

Dans `.vitepress/config.mts`, la section Docker ressemble à ceci :

```ts
items: [
  { text: '1 - Découverte de Docker', link: '/tp/docker/1-decouverte.md' },
  { text: '2 - Compose et WordPress', link: '/tp/docker/2-compose-wordpress.md' },
]
```

Modifier pour :

```ts
items: [
  { text: '1 - Découverte de Docker', link: '/tp/docker/1-decouverte.md' },
  { text: '1.5 - Construire ses propres images', link: '/tp/docker/1.5-construire-images.md' },
  { text: '2 - Compose et WordPress', link: '/tp/docker/2-compose-wordpress.md' },
]
```

- [ ] **Step 2 : Créer le fichier avec le frontmatter et l'en-tête**

Créer `tp/docker/1.5-construire-images.md` avec ce contenu :

```markdown
---
outline: deep
---

# TP 1.5 — Construire ses propres images Docker

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Durée : 2 heures" />  <Badge type="danger" text="Docker + Debian" />

::: info Contexte
Au TP 1, vous avez utilisé des images Docker Hub toutes prêtes (`httpd`, `hello-world`). Mais d'où viennent ces images ? Quelqu'un les a construites. **TechServices** veut maintenant standardiser ses déploiements : plutôt que de télécharger une image et de la modifier à la main à chaque fois, l'équipe infrastructure va construire ses propres images sur mesure — intégrant directement les fichiers de l'entreprise, distribuables à n'importe quel membre de l'équipe sans manipulation supplémentaire.
:::

---
```

- [ ] **Step 3 : Vérifier que le serveur démarre sans erreur**

```bash
npm run dev
```

Ouvrir `http://localhost:5173` dans le navigateur. Vérifier que le lien "1.5 - Construire ses propres images" apparaît dans la sidebar Docker et que la page s'affiche (vide pour l'instant, c'est normal).

- [ ] **Step 4 : Commit**

```bash
git add .vitepress/config.mts tp/docker/1.5-construire-images.md
git commit -m "add TP 1.5 docker build images skeleton and sidebar entry"
```

---

### Task 2 : Mission 1 — Anatomie d'un Dockerfile (FROM, CMD)

**Files:**
- Modify: `tp/docker/1.5-construire-images.md`

- [ ] **Step 1 : Ajouter la Mission 1 au fichier**

Ajouter après le bloc `---` de l'en-tête :

````markdown
## Mission 1 — Anatomie d'un Dockerfile

### Tâche 1.1 — Créer un dossier de travail

```bash
mkdir ~/tp-dockerfile && cd ~/tp-dockerfile
```

Travaillez toujours dans un dossier dédié : le dossier courant devient le **contexte de build** — les fichiers que Docker pourra copier dans l'image.

### Tâche 1.2 — Écrire le premier Dockerfile

```bash
nano Dockerfile
```

```dockerfile
FROM httpd:latest
CMD ["/bin/sh", "-c", "echo 'Serveur Apache en cours de démarrage...' && httpd-foreground"]
```

::: info Décryptage
**`FROM httpd:latest`** — point de départ. On repart de l'image `httpd` déjà vue au TP 1 : Apache y est déjà installé et configuré.

**`CMD`** — la commande qui s'exécutera **dans le conteneur** au moment du `docker run`. Ici : on affiche un message, puis on lance Apache.
:::

### Tâche 1.3 — Construire l'image

```bash
docker build -t techservices-web:1.0 .
```

::: info Décryptage de la commande
- `docker build` — construit une image à partir d'un Dockerfile
- `-t techservices-web:1.0` — nom (`techservices-web`) et tag (`1.0`) de l'image
- `.` — contexte de build : Docker cherche le `Dockerfile` dans le **dossier courant**
:::

### Tâche 1.4 — Comparer avec l'image d'origine

```bash
docker images
```

::: tip 📸 Capture 1
Sortie de `docker images` — `techservices-web` apparaît dans la liste à côté de `httpd`.
:::

Les deux images sont distinctes, mais presque identiques pour l'instant — la différence viendra quand on y intégrera nos propres fichiers.

### Tâche 1.5 — Lancer un conteneur et observer CMD en action

```bash
docker run -d --name test-web -p 8080:80 techservices-web:1.0
docker logs test-web
```

Le message "Serveur Apache en cours de démarrage..." est visible dans les logs — preuve que `CMD` s'exécute **dans** le conteneur, au moment du `docker run`, pas au moment du build.

::: tip 📸 Capture 2
Sortie de `docker logs test-web` — le message de démarrage est visible avant les logs Apache.
:::

---
````

- [ ] **Step 2 : Vérifier le rendu dans le navigateur**

Le serveur `npm run dev` tourne déjà. Naviguer vers la page TP 1.5. Vérifier que :
- Les blocs `:::info` et `:::tip` s'affichent correctement
- Les blocs de code sont colorisés
- Les numéros de tâches sont lisibles

- [ ] **Step 3 : Commit**

```bash
git add tp/docker/1.5-construire-images.md
git commit -m "add TP 1.5 mission 1 - Dockerfile anatomy (FROM, CMD)"
```

---

### Task 3 : Mission 2 — Intégrer ses fichiers avec COPY

**Files:**
- Modify: `tp/docker/1.5-construire-images.md`

- [ ] **Step 1 : Ajouter la Mission 2 au fichier**

Ajouter après le `---` de fin de Mission 1 :

````markdown
## Mission 2 — Intégrer ses fichiers avec COPY

### Tâche 2.1 — Créer une page HTML

Dans votre dossier `~/tp-dockerfile`, créez le fichier `index.html` :

```bash
nano index.html
```

```html
<!DOCTYPE html>
<html>
<head>
  <title>TechServices</title>
</head>
<body>
  <h1>TechServices</h1>
  <p>Portail interne — version 1.0</p>
</body>
</html>
```

### Tâche 2.2 — Modifier le Dockerfile pour intégrer le fichier

```bash
nano Dockerfile
```

```dockerfile
FROM httpd:latest
COPY index.html /usr/local/apache2/htdocs/index.html
CMD ["/bin/sh", "-c", "echo 'Serveur Apache en cours de démarrage...' && httpd-foreground"]
```

::: info COPY : source → destination
- **Source** : `index.html` dans votre dossier de build (sur la machine hôte)
- **Destination** : `/usr/local/apache2/htdocs/index.html` dans l'image

Le fichier sera présent dans **toutes les instances** de cette image, sans aucune manipulation manuelle.
:::

### Tâche 2.3 — Reconstruire et tester

```bash
docker build -t techservices-web:1.0 .
docker rm -f test-web
docker run -d --name test-web -p 8080:80 techservices-web:1.0
```

Accédez à `http://[IP-de-la-VM]:8080` depuis votre navigateur.

::: tip 📸 Capture 3
Page HTML personnalisée TechServices affichée dans le navigateur.
:::

### Tâche 2.4 — Vérifier que c'est reproductible

Supprimez le conteneur et créez-en un nouveau depuis la même image :

```bash
docker rm -f test-web
docker run -d --name test-web2 -p 8080:80 techservices-web:1.0
```

Accédez à nouveau à `http://[IP-de-la-VM]:8080`.

::: tip 📸 Capture 4
Page personnalisée toujours présente après suppression et recréation du conteneur — sans aucune modification manuelle.
:::

::: info Le déclic
Au TP 1, on modifiait `index.html` avec `docker exec ... echo > ...` — et la modification **disparaissait** à la suppression du conteneur.

Ici, `index.html` est **intégré dans l'image**. N'importe qui qui lance `techservices-web:1.0` obtient la même page. C'est ça, une image.
:::

---
````

- [ ] **Step 2 : Vérifier le rendu dans le navigateur**

Vérifier que le bloc `:::info Le déclic` s'affiche correctement — c'est le point pédagogique central de cette mission.

- [ ] **Step 3 : Commit**

```bash
git add tp/docker/1.5-construire-images.md
git commit -m "add TP 1.5 mission 2 - COPY files into image"
```

---

### Task 4 : Mission 3 — Exécuter des commandes au build avec RUN

**Files:**
- Modify: `tp/docker/1.5-construire-images.md`

- [ ] **Step 1 : Ajouter la Mission 3 au fichier**

Ajouter après le `---` de fin de Mission 2 :

````markdown
## Mission 3 — Exécuter des commandes au build avec RUN

### Tâche 3.1 — Ajouter une commande RUN

```bash
nano Dockerfile
```

```dockerfile
FROM httpd:latest
RUN echo "Image construite par TechServices" > /usr/local/apache2/htdocs/info.txt
COPY index.html /usr/local/apache2/htdocs/index.html
CMD ["/bin/sh", "-c", "echo 'Serveur Apache en cours de démarrage...' && httpd-foreground"]
```

### Tâche 3.2 — Observer les couches lors du build

```bash
docker build -t techservices-web:1.0 .
```

La sortie affiche les étapes numérotées. Chaque instruction du Dockerfile est une étape distincte — et chaque `RUN` crée une nouvelle **couche** dans l'image.

::: tip 📸 Capture 5
Sortie de `docker build` — les étapes sont numérotées, le `RUN` apparaît comme une étape distincte.
:::

### Tâche 3.3 — Vérifier que RUN s'est exécuté au build

```bash
docker rm -f test-web2
docker run -d --name test-web3 -p 8080:80 techservices-web:1.0
docker exec test-web3 cat /usr/local/apache2/htdocs/info.txt
```

Le fichier `info.txt` existe — il a été créé **au moment du build**, pas au démarrage du conteneur. À chaque `docker run`, le résultat est déjà là dans l'image.

::: tip 📸 Capture 6
Contenu de `info.txt` affiché depuis l'intérieur du conteneur : "Image construite par TechServices".
:::

### Tâche 3.4 — Observer les couches de l'image

```bash
docker history techservices-web:1.0
```

Chaque instruction du Dockerfile correspond à une couche. Retrouvez-y votre `RUN` et votre `COPY`.

::: tip 📸 Capture 7
Sortie de `docker history` — couches listées avec leur taille et la commande qui les a créées.
:::

::: info Relier avec le TP 1
Au TP 1, lors du `docker pull httpd`, vous avez vu des lignes `Pull complete` s'afficher une par une. Ce sont les **couches** de l'image qui se téléchargent séparément. Chaque `RUN` dans un Dockerfile produit une couche — et ces couches sont réutilisables entre images.
:::

---
````

- [ ] **Step 2 : Vérifier le rendu dans le navigateur**

Vérifier que le bloc `:::info Relier avec le TP 1` s'affiche et que les 7 captures sont toutes présentes dans la page.

- [ ] **Step 3 : Commit**

```bash
git add tp/docker/1.5-construire-images.md
git commit -m "add TP 1.5 mission 3 - RUN commands and image layers"
```

---

### Task 5 : Récapitulatif + questions de réflexion

**Files:**
- Modify: `tp/docker/1.5-construire-images.md`

- [ ] **Step 1 : Ajouter le récapitulatif et les questions**

Ajouter après le `---` de fin de Mission 3 :

````markdown
## Questions de réflexion

Répondez à ces questions **dans votre tête ou à l'oral avec votre voisin** — elles seront à la base de la discussion en fin de séance :

1. Quelle différence concrète avez-vous observée entre modifier un conteneur avec `docker exec` (TP 1) et intégrer un fichier avec `COPY` ?
2. Pourquoi `RUN` s'exécute-t-il au moment du build et non au démarrage du conteneur ?
3. Si vous donnez votre image `techservices-web:1.0` à un collègue, que devra-t-il faire pour lancer le serveur avec votre page personnalisée ?

---

## Récapitulatif des instructions Dockerfile

| Instruction | Quand s'exécute-t-elle ? | Rôle |
|---|---|---|
| `FROM` | Build | Image de base (point de départ) |
| `RUN` | Build | Exécuter une commande et créer une couche |
| `COPY` | Build | Copier des fichiers de l'hôte vers l'image |
| `CMD` | Runtime | Commande par défaut au démarrage du conteneur |
````

- [ ] **Step 2 : Vérifier le rendu complet de la page**

Parcourir toute la page dans le navigateur de haut en bas. Vérifier :
- Les badges en haut s'affichent (info, warning, danger)
- Les 3 missions sont bien séparées par des `---`
- Le tableau récapitulatif est correctement rendu
- La table des matières (outline) à droite liste bien les 3 missions

- [ ] **Step 3 : Commit**

```bash
git add tp/docker/1.5-construire-images.md
git commit -m "add TP 1.5 recap table and reflection questions"
```

---

## Self-Review

**Spec coverage :**
- [x] M1 FROM + CMD avec message dans logs → Task 2
- [x] M2 COPY + déclic "disparaissait au TP 1" → Task 3
- [x] M3 RUN + docker history + lien couches TP 1 → Task 4
- [x] Tableau récap 4 instructions → Task 5
- [x] 3 questions de réflexion → Task 5
- [x] 7 captures photos → distribuées dans Tasks 2-4
- [x] Sidebar entry → Task 1
- [x] Contexte TechServices → Task 1

**Placeholder scan :** aucun TBD, aucun "implement later". Tous les blocs de code sont complets.

**Consistency :** Le nom du conteneur `test-web` est réutilisé entre missions avec des `docker rm -f` explicites. Le tag `techservices-web:1.0` est cohérent sur toutes les missions. Le Dockerfile final en M3 inclut bien les instructions des missions précédentes (FROM + RUN + COPY + CMD).
