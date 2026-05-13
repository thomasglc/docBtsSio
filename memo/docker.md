# Docker

Docker est une plateforme de **conteneurisation** : elle permet d'empaqueter une application avec tout ce dont elle a besoin (code, dépendances, configuration) dans un **conteneur** isolé, léger et portable.

```mermaid
graph LR
    A[Image Docker] -->|docker run| B[Conteneur]
    B -->|docker stop| C[Conteneur arrêté]
    C -->|docker start| B
    C -->|docker rm| D[Supprimé]
```

## Images

Une **image** est un modèle en lecture seule. On l'utilise comme base pour créer des conteneurs.

### Télécharger une image
```sh
docker pull <image>
```
Télécharge l'image depuis [Docker Hub](https://hub.docker.com). Exemple : `docker pull nginx`

### Lister les images locales
```sh
docker images
```

### Supprimer une image
```sh
docker rmi <image>
```

## Conteneurs

Un **conteneur** est une instance en cours d'exécution d'une image.

### Lancer un conteneur
```sh
docker run -d --name <nom> -p <port_hôte>:<port_conteneur> <image>
```

| Option | Effet |
|---|---|
| `-d` | Lancer en arrière-plan (detached) |
| `--name <nom>` | Donner un nom au conteneur |
| `-p 8080:80` | Relier le port 8080 de la machine au port 80 du conteneur |
| `-v /chemin/hôte:/chemin/conteneur` | Monter un volume (dossier partagé) |
| `-e CLE=valeur` | Définir une variable d'environnement |
| `--rm` | Supprimer le conteneur automatiquement à l'arrêt |

### Lister les conteneurs
```sh
docker ps        # conteneurs en cours d'exécution
docker ps -a     # tous les conteneurs (y compris arrêtés)
```

### Arrêter / démarrer un conteneur
```sh
docker stop <nom>    # arrêt propre (signal SIGTERM)
docker start <nom>   # redémarrer un conteneur arrêté
docker restart <nom> # arrêter puis redémarrer
```

### Supprimer un conteneur
```sh
docker rm <nom>
```
Le conteneur doit être arrêté avant d'être supprimé.

### Afficher les logs
```sh
docker logs <nom>
docker logs -f <nom>   # suivre les logs en temps réel
```

### Ouvrir un shell dans un conteneur
```sh
docker exec -it <nom> bash
```
`-it` = mode interactif + terminal. Utiliser `sh` si `bash` n'est pas disponible.

## Volumes

Un **volume** permet de persister des données en dehors du conteneur. Sans volume, toute donnée est perdue à la suppression du conteneur.

```sh
docker volume create <nom_volume>
docker volume ls
docker volume rm <nom_volume>
```

Monter un volume lors du `docker run` :
```sh
docker run -d -v mon_volume:/var/lib/mysql mysql
```

## Docker Compose

Docker Compose permet de définir et lancer **plusieurs conteneurs** via un fichier `docker-compose.yml`.

### Structure de base
```yaml
services:
  web:
    image: nginx
    ports:
      - "8080:80"
  db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

### Commandes Compose

```sh
docker compose up -d        # créer et démarrer tous les services
docker compose down         # arrêter et supprimer les conteneurs
docker compose down --volumes  # idem + supprimer les volumes
docker compose ps           # état des services
docker compose logs -f      # logs en temps réel
docker compose logs <service>  # logs d'un service spécifique
docker compose exec <service> bash  # shell dans un service
docker compose stop         # arrêter sans supprimer
docker compose start        # redémarrer des services arrêtés
```

## Nettoyage

```sh
docker system prune          # supprimer conteneurs arrêtés, images inutilisées, réseaux orphelins
docker system prune -a       # idem + toutes les images non utilisées
```

::: warning Attention
`docker system prune` est irréversible. Vérifiez ce que vous souhaitez conserver avant de l'exécuter.
:::

::: tip Rappel clé
- **Image** = le modèle (recette)
- **Conteneur** = l'instance en cours (le plat cuisiné)
- **Volume** = les données persistées (le frigo)
- **Compose** = orchestration de plusieurs conteneurs
:::
