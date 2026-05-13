# Design — TP 1.5 : Construire ses propres images Docker

**Date :** 2026-05-13  
**Statut :** Validé  
**Durée cible :** 2 heures  
**Public :** BTS SIO SISR 1ère année  
**Position dans la séquence :** Entre TP 1 (Découverte) et TP 2 (Docker Compose + WordPress)

---

## Problème pédagogique

Dans le TP 1, les étudiants utilisent des images Docker Hub (`httpd`, `hello-world`) sans jamais comprendre ce qu'est une image concrètement. L'analogie "recette de cuisine" reste abstraite. Ce TP comble ce manque en leur faisant **construire eux-mêmes une image** à partir d'un Dockerfile.

---

## Objectif

À la fin du TP, l'étudiant est capable de :
- Écrire un Dockerfile avec les instructions `FROM`, `COPY`, `RUN`, `CMD`
- Construire une image avec `docker build`
- Expliquer la différence entre ce qui s'exécute au **build** (`RUN`, `COPY`) et au **runtime** (`CMD`)
- Comprendre qu'une image est immuable et reproductible, contrairement à un conteneur modifié à la main

---

## Contexte TechServices

L'équipe infrastructure de TechServices veut standardiser ses déploiements Apache. Plutôt que de télécharger une image Docker Hub et de la modifier à la main à chaque fois (comme au TP 1), elle veut construire une image sur mesure qui intègre directement les fichiers de l'entreprise — distribuable à n'importe quel membre de l'équipe.

---

## Structure — 3 missions

### Mission 1 — Anatomie d'un Dockerfile

**Instructions enseignées :** `FROM`, `CMD`  
**Objectif :** Écrire, construire et lancer sa première image

**Tâches :**

1. Créer un dossier de travail `~/tp-dockerfile`
2. Écrire le Dockerfile minimal :
   ```dockerfile
   FROM httpd:latest
   CMD ["/bin/sh", "-c", "echo 'Serveur Apache en cours de démarrage...' && httpd-foreground"]
   ```
3. Construire l'image : `docker build -t techservices-web:1.0 .`  
   Expliquer `-t` (nom de l'image) et `.` (contexte de build = dossier courant)
4. Vérifier avec `docker images` — 📸 **Capture 1** : `techservices-web` apparaît à côté de `httpd`
5. Lancer le conteneur : `docker run -d --name test-web -p 8080:80 techservices-web:1.0`
6. Consulter les logs : `docker logs test-web`  
   Le message "Serveur Apache en cours de démarrage..." est visible — preuve que `CMD` s'exécute **dans** le conteneur au démarrage.  
   📸 **Capture 2** : `docker logs test-web` — le message est visible

**Point pédagogique :** `FROM` définit le point de départ (on repart de `httpd` qui contient déjà Apache). `CMD` est la commande qui s'exécute dans le conteneur au moment du `docker run`, pas au moment du build.

---

### Mission 2 — Intégrer ses fichiers avec COPY

**Instructions enseignées :** `COPY`  
**Objectif :** Comprendre qu'une image encapsule des fichiers de façon permanente et reproductible

**Tâches :**

1. Créer `index.html` dans le dossier de travail :
   ```html
   <!DOCTYPE html>
   <html>
   <head><title>TechServices</title></head>
   <body>
     <h1>TechServices</h1>
     <p>Portail interne — version 1.0</p>
   </body>
   </html>
   ```
2. Modifier le Dockerfile :
   ```dockerfile
   FROM httpd:latest
   COPY index.html /usr/local/apache2/htdocs/index.html
   CMD ["/bin/sh", "-c", "echo 'Serveur Apache en cours de démarrage...' && httpd-foreground"]
   ```
   Expliquer `COPY` : `source` (machine hôte, dans le dossier de build) → `destination` (chemin dans l'image)
3. Reconstruire et relancer :
   ```bash
   docker build -t techservices-web:1.0 .
   docker rm -f test-web
   docker run -d --name test-web -p 8080:80 techservices-web:1.0
   ```
   Accéder à `http://[IP]:8080`  
   📸 **Capture 3** : page HTML personnalisée dans le navigateur
4. Supprimer le conteneur et en relancer un nouveau depuis la même image :
   ```bash
   docker rm -f test-web
   docker run -d --name test-web2 -p 8080:80 techservices-web:1.0
   ```
   📸 **Capture 4** : la page personnalisée est toujours présente sans aucune modification manuelle

**Déclic explicite :** Rappeler le TP 1 — on modifiait `index.html` avec `docker exec` et la modification disparaissait à la suppression du conteneur. Ici, le fichier est **intégré dans l'image** : n'importe qui qui la lance obtient la même page, immédiatement. C'est ça, une image.

---

### Mission 3 — Exécuter des commandes au build avec RUN

**Instructions enseignées :** `RUN`  
**Objectif :** Comprendre la différence build-time / runtime et le concept de couches

**Tâches :**

1. Ajouter un `RUN` au Dockerfile :
   ```dockerfile
   FROM httpd:latest
   RUN echo "Image construite par TechServices" > /usr/local/apache2/htdocs/info.txt
   COPY index.html /usr/local/apache2/htdocs/index.html
   CMD ["/bin/sh", "-c", "echo 'Serveur Apache en cours de démarrage...' && httpd-foreground"]
   ```
2. Reconstruire : `docker build -t techservices-web:1.0 .`  
   Observer les étapes numérotées dans la sortie — le `RUN` est une étape distincte.  
   📸 **Capture 5** : sortie de `docker build` avec les étapes numérotées
3. Vérifier que `RUN` s'est exécuté au build :
   ```bash
   docker run -d --name test-web3 -p 8080:80 techservices-web:1.0
   docker exec test-web3 cat /usr/local/apache2/htdocs/info.txt
   ```
   Le fichier `info.txt` existe — il a été créé pendant le build, pas au démarrage du conteneur.  
   📸 **Capture 6** : contenu de `info.txt` visible depuis l'intérieur du conteneur
4. Observer les couches de l'image :
   ```bash
   docker history techservices-web:1.0
   ```
   Chaque instruction du Dockerfile = une couche dans `docker history`.  
   Relier avec les lignes `Pull complete` du TP 1 : quand on télécharge une image, on télécharge ses couches une par une.  
   📸 **Capture 7** : `docker history` — couches listées avec taille et commande

**Point pédagogique :** `RUN` s'exécute **une fois, au moment du build**, et son résultat est figé dans une couche de l'image. À chaque `docker run`, le résultat est déjà là — Docker ne réexécute pas le `RUN`.

---

## Tableau récapitulatif des instructions

| Instruction | Quand s'exécute-t-elle ? | Rôle |
|---|---|---|
| `FROM` | Build | Image de base (point de départ) |
| `RUN` | Build | Exécuter une commande et créer une couche |
| `COPY` | Build | Copier des fichiers de l'hôte vers l'image |
| `CMD` | Runtime | Commande par défaut au démarrage du conteneur |

---

## Questions de réflexion

1. Quelle différence concrète entre modifier un conteneur avec `docker exec` (TP 1) et intégrer un fichier avec `COPY` ?
2. Pourquoi `RUN` s'exécute-t-il au moment du build et non au démarrage du conteneur ?
3. Si vous donnez votre image `techservices-web:1.0` à un collègue, que devra-t-il faire pour lancer le serveur avec votre page personnalisée ?

---

## Captures photos (7 au total)

| # | Commande / Vue | Ce qui doit être visible |
|---|---|---|
| 1 | `docker images` | `techservices-web` apparaît à côté de `httpd` |
| 2 | `docker logs test-web` | Message "Serveur Apache en cours de démarrage..." |
| 3 | Navigateur `http://[IP]:8080` | Page HTML personnalisée TechServices |
| 4 | Navigateur après suppression/recréation du conteneur | Page toujours présente sans modification manuelle |
| 5 | Sortie de `docker build` | Étapes numérotées, `RUN` visible comme étape distincte |
| 6 | `docker exec ... cat info.txt` | Contenu du fichier créé par `RUN` |
| 7 | `docker history techservices-web:1.0` | Couches listées avec taille et commande |
