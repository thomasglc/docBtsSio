---
outline: deep
---

# TP 1 — Découverte de Docker

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Durée : 2 heures" />  <Badge type="danger" text="Docker + Debian" />

::: info Contexte
La société **TechServices** souhaite moderniser son infrastructure en adoptant la **conteneurisation**. Plutôt que de déployer ses applications sur des serveurs dédiés ou des machines virtuelles lourdes, elle veut utiliser **Docker** pour isoler, déployer et gérer ses services plus efficacement. Vous êtes chargé de prendre en main cet outil.
:::

---

## Qu'est-ce que Docker ?

Avant de taper la moindre commande, il est essentiel de comprendre ce que vous allez manipuler.

### Le problème que Docker résout

Vous avez déjà installé une pile LAMP manuellement : configurer Apache, MariaDB, PHP, gérer les dépendances, les conflits de versions… C'est long, fragile, et difficile à reproduire sur une autre machine.

Docker résout ce problème en empaquetant une application **avec tout ce dont elle a besoin** (système, bibliothèques, configuration) dans une unité portable appelée **conteneur**.

### Conteneur vs Machine Virtuelle

| | Machine Virtuelle | Conteneur Docker |
|---|---|---|
| Ce qu'il contient | OS complet + application | Application + bibliothèques uniquement |
| Démarrage | 1 à 2 minutes | Quelques secondes |
| Taille | Plusieurs Go | Quelques dizaines de Mo |
| Isolation | Totale (noyau propre) | Partielle (partage le noyau hôte) |

Un conteneur n'est pas une VM légère — c'est un **processus isolé** qui tourne directement sur le noyau de la machine hôte.

### Les trois concepts clés

| Concept | Analogie | Définition |
|---|---|---|
| **Image** | Recette de cuisine | Modèle immuable qui décrit ce que contiendra un conteneur |
| **Conteneur** | Plat cuisiné | Instance en cours d'exécution d'une image |
| **Registry** | Supermarché de recettes | Serveur où sont stockées et distribuées les images (ex : Docker Hub) |

Une image ne s'exécute jamais directement. On crée un conteneur **à partir** d'une image. On peut créer autant de conteneurs qu'on veut à partir de la même image.

---

## Mission 1 — Installer Docker sur Debian

Docker ne s'installe pas avec un simple `apt install docker` — le paquet présent dans les dépôts Debian est une ancienne version communautaire. On installe la version officielle depuis le dépôt de Docker.

### Tâche 1.1 — Ajouter le dépôt officiel Docker

```bash
sudo apt update
sudo apt install -y ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
```

### Tâche 1.2 — Installer Docker

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin
```

::: info Pourquoi ces paquets ?
- `docker-ce` — le moteur Docker
- `docker-ce-cli` — la commande `docker` en ligne de commande
- `containerd.io` — le runtime bas niveau qui gère les conteneurs
- `docker-compose-plugin` — le plugin `docker compose` intégré
:::

### Tâche 1.3 — Autoriser votre utilisateur à utiliser Docker

Par défaut, seul `root` peut parler au daemon Docker. On ajoute notre utilisateur au groupe `docker` pour éviter de taper `sudo` à chaque commande.

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Vérifiez que Docker fonctionne :

```bash
docker --version
docker run hello-world
```

::: tip 📸 Capture 1
Sortie de `docker run hello-world` — le message `Hello from Docker!` est visible.
:::

::: info Que vient-il de se passer ?
Docker a cherché l'image `hello-world` localement → ne l'a pas trouvée → l'a téléchargée depuis Docker Hub → a créé un conteneur → l'a exécuté → le conteneur a affiché son message et s'est arrêté. Tout cela en quelques secondes.
:::

---

## Mission 2 — Images et conteneurs

### Tâche 2.1 — Télécharger une image

```bash
docker pull httpd
```

Docker télécharge l'image officielle **Apache** depuis Docker Hub. Observez les lignes `Pull complete` : chaque ligne correspond à une **couche** (layer) de l'image. Les images sont construites en couches empilées — c'est ce qui les rend légères et partageables.

Listez les images disponibles localement :

```bash
docker images
```

::: tip 📸 Capture 2
Sortie de `docker images` — l'image `httpd` apparaît avec sa taille et son tag (`latest`).
:::

### Tâche 2.2 — Lancer un conteneur

```bash
docker run httpd
```

Le terminal est bloqué — Apache tourne au premier plan. Faites `Ctrl+C` pour l'arrêter.

Pour lancer un conteneur **en arrière-plan** (mode détaché), utilisez le flag `-d` :

```bash
docker run -d httpd
```

Docker affiche un long identifiant hexadécimal — c'est l'ID du conteneur.

### Tâche 2.3 — Lister les conteneurs

```bash
docker ps
```

Vous voyez votre conteneur Apache en cours d'exécution avec son ID, son image, la commande lancée, et depuis combien de temps il tourne.

```bash
docker ps -a
```

Le flag `-a` (all) affiche **tous** les conteneurs, y compris ceux qui sont arrêtés. Vous devriez voir le conteneur Apache lancé sans `-d` à la tâche précédente, avec le statut `Exited`.

::: tip 📸 Capture 3
Sortie de `docker ps -a` — un conteneur en cours (`Up`) et un arrêté (`Exited`) visibles.
:::

### Tâche 2.4 — Cycle de vie d'un conteneur

Récupérez l'ID ou le nom du conteneur en cours depuis `docker ps`, puis testez ces commandes :

```bash
docker stop <ID_ou_nom>
docker ps -a        # le conteneur est maintenant Exited

docker start <ID_ou_nom>
docker ps           # il tourne à nouveau

docker stop <ID_ou_nom>
docker rm <ID_ou_nom>
docker ps -a        # le conteneur a disparu
```

::: warning Arrêter ≠ Supprimer
`stop` arrête le conteneur mais le conserve (avec ses données). `rm` le supprime définitivement. Un conteneur arrêté n'utilise pas de CPU ni de RAM, mais occupe encore de l'espace disque.
:::

---

## Mission 3 — Nommer et inspecter un conteneur

Jusqu'ici Docker attribue des noms aléatoires (`hopeful_morse`, `crazy_einstein`…). En production on nomme toujours ses conteneurs.

### Tâche 3.1 — Lancer un conteneur nommé

```bash
docker run -d --name monserveur httpd
```

Le flag `--name` donne un nom fixe au conteneur. Vérifiez avec `docker ps`.

### Tâche 3.2 — Consulter les logs

```bash
docker logs monserveur
docker logs -f monserveur
```

`-f` (follow) affiche les logs en temps réel. Faites `Ctrl+C` pour quitter le suivi sans arrêter le conteneur.

### Tâche 3.3 — Entrer dans un conteneur

```bash
docker exec -it monserveur bash
```

Vous êtes maintenant **à l'intérieur** du conteneur. Explorez :

```bash
ls /usr/local/apache2/conf/          # configuration d'Apache
cat /usr/local/apache2/conf/httpd.conf
ls /usr/local/apache2/htdocs/        # fichiers servis par défaut
cat /usr/local/apache2/htdocs/index.html
exit
```

::: info exec vs run
`docker run` crée un nouveau conteneur. `docker exec` exécute une commande dans un conteneur **déjà en cours d'exécution** — ici on ouvre un shell interactif (`-it` = interactive + TTY).
:::

::: tip 📸 Capture 4
Shell interactif à l'intérieur du conteneur — invite de commande différente visible (`root@<ID>:/#`).
:::

---

## Mission 4 — Exposer des ports

Pour l'instant Apache tourne dans le conteneur mais n'est pas accessible depuis l'extérieur. Docker isole les ports : il faut explicitement faire un **mapping de port** entre l'hôte et le conteneur.

### Tâche 4.1 — Comprendre le mapping de port

La syntaxe est `-p <port_hote>:<port_conteneur>`.

```bash
docker stop monserveur
docker rm monserveur

docker run -d --name web -p 8080:80 httpd
```

Apache écoute sur le port **80 à l'intérieur du conteneur**. On le rend accessible sur le port **8080 de la VM**.

### Tâche 4.2 — Accéder au serveur depuis un navigateur

Récupérez l'adresse IP de votre VM :

```bash
ip a
```

Depuis votre navigateur (sur votre poste hôte), accédez à :

```
http://[IP-de-la-VM]:8080
```

La page de bienvenue Apache (`It works!`) s'affiche.

::: tip 📸 Capture 5
Page de bienvenue Apache (`It works!`) accessible depuis le navigateur via `http://[IP]:8080`.
:::

### Tâche 4.3 — Lancer deux serveurs simultanément

Chaque conteneur a son propre espace réseau interne. On peut donc lancer deux Apache sur des ports différents :

```bash
docker run -d --name web2 -p 8081:80 httpd
docker ps
```

Accédez à `http://[IP]:8081` — un deuxième Apache tourne en parallèle.

::: info Ce qui se passerait avec des VMs
Faire tourner deux serveurs web simultanément sur deux VMs séparées demanderait deux OS complets. Ici, les deux conteneurs partagent le même noyau Debian et démarrent en quelques secondes.
:::

### Tâche 4.4 — Modifier le contenu servi

Entrez dans le conteneur `web` et modifiez la page d'accueil :

```bash
docker exec -it web bash
echo "<h1>Bienvenue sur TechServices !</h1>" > /usr/local/apache2/htdocs/index.html
exit
```

Rafraîchissez `http://[IP]:8080` dans votre navigateur — la page a changé.

::: warning Données non persistantes
Si vous supprimez le conteneur (`docker rm -f web`) et en relancez un nouveau, la modification disparaît. Les données écrites **dans** un conteneur sont perdues à sa suppression. La solution (les volumes) sera vue au TP 2.
:::

::: tip 📸 Capture 6
Page `http://[IP]:8080` affichant le message personnalisé "Bienvenue sur TechServices !".
:::

---

## Mission 5 — Nettoyer l'environnement

### Tâche 5.1 — Arrêter et supprimer tous les conteneurs

```bash
docker stop web web2
docker rm web web2
docker ps -a        # la liste doit être vide
```

Pour tout supprimer d'un coup (utile en TP) :

```bash
docker rm -f $(docker ps -aq)
```

::: danger
`docker rm -f $(docker ps -aq)` supprime **tous** les conteneurs sans confirmation. À utiliser avec précaution en dehors d'un contexte de TP.
:::

### Tâche 5.2 — Nettoyer les images

```bash
docker images
docker rmi httpd
docker images       # l'image a été supprimée
```

Pour supprimer toutes les ressources inutilisées (images, réseaux, volumes orphelins) :

```bash
docker system prune
```

::: tip 📸 Capture 7
Sortie de `docker system prune` — espace disque récupéré affiché.
:::

---

## Questions de réflexion

Répondez à ces questions **dans votre tête ou à l'oral avec votre voisin** — elles n'ont pas à être rendues, mais elles seront à la base de la discussion en fin de séance :

1. Quelle différence concrète avez-vous observée entre `docker stop` et `docker rm` ?
2. Pourquoi a-t-on besoin du flag `-p` pour accéder à Apache depuis le navigateur ?
3. Qu'arrive-t-il à la modification de `index.html` si on supprime le conteneur ?
4. Si on peut lancer deux Apache sur le même serveur Debian, que faudrait-il faire sans Docker pour obtenir le même résultat ?

---

## Récapitulatif des commandes

| Commande | Effet |
|---|---|
| `docker pull <image>` | Télécharger une image depuis Docker Hub |
| `docker images` | Lister les images locales |
| `docker run -d --name <nom> -p <h>:<c> <image>` | Lancer un conteneur en arrière-plan |
| `docker ps` | Lister les conteneurs en cours |
| `docker ps -a` | Lister tous les conteneurs |
| `docker stop <nom>` | Arrêter un conteneur |
| `docker start <nom>` | Redémarrer un conteneur arrêté |
| `docker rm <nom>` | Supprimer un conteneur |
| `docker logs <nom>` | Afficher les logs |
| `docker exec -it <nom> bash` | Ouvrir un shell dans le conteneur |
| `docker rmi <image>` | Supprimer une image |
| `docker system prune` | Nettoyer les ressources inutilisées |
