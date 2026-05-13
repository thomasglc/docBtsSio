---
outline: deep
---

# TP 2 — Docker Compose et déploiement de WordPress

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Durée : 2 heures" />  <Badge type="danger" text="Docker Compose + WordPress + MySQL" />

::: info Contexte
Maintenant que vous maîtrisez les bases, **TechServices** vous demande de déployer un site WordPress pour son intranet. L'installation manuelle d'une pile LAMP vous a pris plusieurs heures lors du TP Système. Vous allez faire la même chose avec Docker en quelques minutes, et comprendre pourquoi c'est devenu la norme en entreprise.
:::

::: warning Prérequis
Ce TP nécessite d'avoir complété le TP 1. Docker doit être installé et votre utilisateur doit être dans le groupe `docker`.
:::

---

## Pourquoi Docker Compose ?

Au TP 1, vous avez lancé des conteneurs **un par un** à la main. Imaginez devoir démarrer WordPress : il faut un conteneur MySQL, un conteneur WordPress, les connecter ensemble, configurer les variables d'environnement, les volumes… Autant de commandes à retaper à chaque fois.

**Docker Compose** résout ce problème : on décrit toute l'infrastructure dans un seul fichier `docker-compose.yml`, puis on démarre tout avec une seule commande.

| Sans Compose | Avec Compose |
|---|---|
| Une commande `docker run` par conteneur | `docker compose up -d` |
| Réseau manuel entre conteneurs | Réseau automatique |
| Variables d'environnement à retaper | Centralisées dans un fichier |
| Difficile à partager | Le fichier se partage, se versionne |

---

## Mission 1 — Premiers pas avec Docker Compose

### Tâche 1.1 — Créer un dossier de travail

```bash
mkdir ~/tp-compose && cd ~/tp-compose
```

Travaillez toujours dans un dossier dédié : Docker Compose utilise le nom du dossier comme préfixe pour nommer les ressources qu'il crée.

### Tâche 1.2 — Écrire un premier fichier Compose

Créez le fichier `docker-compose.yml` :

```bash
nano docker-compose.yml
```

Copiez ce contenu :

```yaml
services:
  web:
    image: httpd
    ports:
      - "8080:80"
```

::: info Structure d'un fichier Compose
- `services` — liste des conteneurs à créer
- `web` — nom du service (et du conteneur)
- `image` — l'image Docker à utiliser
- `ports` — mapping de ports (hôte:conteneur)
:::

### Tâche 1.3 — Démarrer et observer

```bash
docker compose up -d
docker compose ps
```

Accédez à `http://[IP-VM]:8080` — Apache répond.

Consultez les logs du service `web` :

```bash
docker compose logs web
docker compose logs -f web
```

Arrêtez tout :

```bash
docker compose down
docker ps -a    # les conteneurs ont disparu
```

::: tip 📸 Capture 1
Sortie de `docker compose ps` — le service `web` est visible avec son statut et son port.
:::

::: info `down` vs `stop`
`docker compose down` arrête **et supprime** les conteneurs. `docker compose stop` les arrête sans les supprimer. En développement, on utilise presque toujours `down`.
:::

---

## Mission 2 — Volumes et persistance des données

C'est le concept le plus important à comprendre avant de déployer WordPress.

### Tâche 2.1 — Démontrer la perte de données

Modifiez `docker-compose.yml` pour ajouter un conteneur Apache avec une page personnalisée :

```yaml
services:
  web:
    image: httpd
    ports:
      - "8080:80"
```

```bash
docker compose up -d
docker compose exec web bash
echo "<h1>Donnee importante !</h1>" > /usr/local/apache2/htdocs/index.html
exit
```

Vérifiez que la page s'affiche à `http://[IP-VM]:8080`.

Maintenant supprimez et recréez le conteneur :

```bash
docker compose down
docker compose up -d
```

Accédez à nouveau à `http://[IP-VM]:8080` — la page d'accueil Apache par défaut est revenue. **La modification est perdue.**

### Tâche 2.2 — Ajouter un volume

Un **volume** est un espace de stockage géré par Docker, qui existe **en dehors du cycle de vie des conteneurs**. Les données y survivent aux `docker compose down`.

Modifiez `docker-compose.yml` :

```yaml
services:
  web:
    image: httpd
    ports:
      - "8080:80"
    volumes:
      - donnees-web:/usr/local/apache2/htdocs

volumes:
  donnees-web:
```

```bash
docker compose down
docker compose up -d
docker compose exec web bash
echo "<h1>Donnee persistante !</h1>" > /usr/local/apache2/htdocs/index.html
exit
```

Vérifiez la page à `http://[IP-VM]:8080`, puis :

```bash
docker compose down
docker compose up -d
```

Accédez à nouveau : la page personnalisée est toujours là.

::: tip 📸 Capture 2
Page `http://[IP-VM]:8080` affichant "Donnee persistante !" après un `docker compose down` et `up`.
:::

::: info Où sont stockés les volumes ?
Les volumes nommés sont gérés par Docker dans `/var/lib/docker/volumes/`. Vous pouvez les inspecter avec `docker volume ls` et `docker volume inspect <nom>`.
:::

### Tâche 2.3 — Nettoyer avant la suite

```bash
docker compose down --volumes
```

Le flag `--volumes` supprime aussi les volumes associés. Utile pour repartir de zéro.

---

## Mission 3 — Déployer WordPress avec Docker Compose

Vous avez tous les outils en main. Place au projet.

### Tâche 3.1 — Créer un dossier pour le projet

```bash
cd ~
mkdir wordpress && cd wordpress
```

### Tâche 3.2 — Comprendre l'architecture

WordPress a besoin de deux services :

```
┌─────────────────────────────────────────┐
│              Réseau Docker              │
│                                         │
│  ┌─────────────┐    ┌───────────────┐  │
│  │  wordpress  │───▶│     mysql     │  │
│  │  (port 80)  │    │  (port 3306)  │  │
│  └─────────────┘    └───────────────┘  │
│         │                   │           │
│    Volume wp_data      Volume db_data   │
└─────────────────────────────────────────┘
         │
    Port 8080 (hôte)
```

Docker Compose crée automatiquement un réseau partagé entre tous les services du fichier. Les services peuvent se joindre **par leur nom** (`mysql` est joignable depuis `wordpress` directement).

### Tâche 3.3 — Écrire le fichier docker-compose.yml

```bash
nano docker-compose.yml
```

```yaml
services:

  mysql:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wp_user
      MYSQL_PASSWORD: wp_pass
    volumes:
      - db_data:/var/lib/mysql

  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: wp_user
      WORDPRESS_DB_PASSWORD: wp_pass
    volumes:
      - wp_data:/var/www/html
    depends_on:
      - mysql

volumes:
  db_data:
  wp_data:
```

::: info Décryptage du fichier

**`restart: always`** — le conteneur redémarre automatiquement s'il plante ou si la VM redémarre. Indispensable en production.

**`environment`** — variables d'environnement injectées dans le conteneur. C'est ainsi que WordPress connaît le mot de passe de la base de données sans qu'on ait à modifier de fichier de configuration manuellement.

**`WORDPRESS_DB_HOST: mysql`** — WordPress se connecte au service nommé `mysql`. Docker Compose traduit ce nom en adresse IP grâce au réseau interne qu'il crée automatiquement.

**`depends_on`** — WordPress attend que le service `mysql` soit **démarré** avant de se lancer. (Note : cela ne garantit pas que MySQL soit prêt à accepter des connexions — c'est pourquoi `restart: always` est important.)

**`volumes`** — deux volumes nommés persistent les données de MySQL et les fichiers WordPress.
:::

### Tâche 3.4 — Démarrer la stack

```bash
docker compose up -d
```

Docker télécharge les deux images (quelques minutes selon la connexion), crée le réseau, les volumes, et lance les deux conteneurs.

Suivez le démarrage :

```bash
docker compose ps
docker compose logs -f
```

Attendez que les deux services soient en statut `running`. Faites `Ctrl+C` pour quitter le suivi.

::: tip 📸 Capture 3
Sortie de `docker compose ps` — les services `mysql` et `wordpress` sont tous les deux en statut `running`.
:::

### Tâche 3.5 — Installer WordPress

Ouvrez votre navigateur et accédez à :

```
http://[IP-VM]:8080
```

L'assistant d'installation WordPress s'affiche. Complétez l'installation :

| Champ | Valeur |
|---|---|
| Titre du site | `TechServices Intranet` |
| Identifiant | `admin` |
| Mot de passe | *(choisissez un mot de passe)* |
| Adresse e-mail | `admin@techservices.local` |

Cliquez sur **Installer WordPress**.

::: tip 📸 Capture 4
Page d'accueil de l'assistant d'installation WordPress accessible à `http://[IP-VM]:8080`.
:::

::: tip 📸 Capture 5
Tableau de bord WordPress après installation — confirmation que le site fonctionne.
:::

### Tâche 3.6 — Vérifier la persistance

Vous venez d'installer WordPress. Vérifiez que vos données survivent à un redémarrage complet de la stack :

```bash
docker compose down
docker compose up -d
```

Accédez à nouveau à `http://[IP-VM]:8080` — WordPress est directement accessible, **sans passer par l'assistant d'installation**. Les données sont persistées dans les volumes.

::: tip 📸 Capture 6
Site WordPress directement accessible après `docker compose down` puis `docker compose up -d` — l'installation n'est pas reperdue.
:::

### Tâche 3.7 — Explorer l'infrastructure

Observez ce que Docker Compose a créé :

```bash
docker compose ps           # les deux conteneurs
docker network ls           # le réseau créé automatiquement
docker volume ls            # les deux volumes
```

Inspectez le réseau interne :

```bash
docker network inspect wordpress_default
```

Vous pouvez voir les deux conteneurs connectés à ce réseau avec leurs adresses IP internes.

::: tip 📸 Capture 7
Sortie de `docker network inspect wordpress_default` — les deux services et leurs adresses IP internes visibles.
:::

---

## Mission 4 — Comprendre ce qu'on a fait

### Tâche 4.1 — Comparer avec l'installation manuelle

Lors du TP Système, l'installation de WordPress sur une pile LAMP a nécessité :
- Installer et configurer Apache
- Installer et configurer MariaDB
- Créer manuellement la base de données et l'utilisateur
- Installer PHP et ses extensions
- Télécharger et décompresser WordPress
- Configurer `wp-config.php`
- Gérer les droits sur les fichiers

Avec Docker Compose, tout cela se résume à **un fichier de 30 lignes** et **une commande**.

### Tâche 4.2 — Tester la destruction des volumes

Pour comprendre l'importance des volumes, testez la destruction complète :

```bash
docker compose down --volumes
```

Accédez à `http://[IP-VM]:8080` — l'assistant d'installation WordPress réapparaît. Toutes les données ont été supprimées avec les volumes.

Relancez :

```bash
docker compose up -d
```

::: warning En production
On ne lance **jamais** `docker compose down --volumes` sur une infrastructure de production. Les volumes contiennent les données réelles. La commande sans `--volumes` suffit pour redémarrer proprement.
:::

### Tâche 4.3 — Ajouter un service phpMyAdmin (bonus)

Si vous avez terminé en avance, ajoutez un accès phpMyAdmin pour administrer la base de données graphiquement.

Modifiez `docker-compose.yml` et ajoutez ce service :

```yaml
  phpmyadmin:
    image: phpmyadmin
    restart: always
    ports:
      - "8081:80"
    environment:
      PMA_HOST: mysql
      PMA_USER: wp_user
      PMA_PASSWORD: wp_pass
```

```bash
docker compose up -d
```

Accédez à `http://[IP-VM]:8081` — phpMyAdmin vous permet de voir la base `wordpress` et ses tables créées par WordPress.

::: tip 📸 Capture 8 (bonus)
Interface phpMyAdmin accessible à `http://[IP-VM]:8081` — la base `wordpress` est visible avec ses tables.
:::

---

## Questions de réflexion

1. Pourquoi utilise-t-on des **variables d'environnement** plutôt que d'écrire directement les mots de passe dans les fichiers de configuration ?
2. Qu'est-ce qui se passerait si on supprimait le service `mysql` du fichier Compose et qu'on relançait `docker compose up -d` ?
3. Dans quel cas préféreriez-vous utiliser `docker compose stop` plutôt que `docker compose down` ?
4. En entreprise, le fichier `docker-compose.yml` est souvent versionné dans Git. Quel avantage cela apporte-t-il pour la gestion de l'infrastructure ?

---

## Récapitulatif des commandes Compose

| Commande | Effet |
|---|---|
| `docker compose up -d` | Créer et démarrer tous les services |
| `docker compose down` | Arrêter et supprimer les conteneurs |
| `docker compose down --volumes` | Idem + supprimer les volumes |
| `docker compose ps` | Lister l'état des services |
| `docker compose logs -f` | Suivre les logs en temps réel |
| `docker compose logs <service>` | Logs d'un service spécifique |
| `docker compose exec <service> bash` | Shell dans un conteneur |
| `docker compose stop` | Arrêter sans supprimer |
| `docker compose start` | Redémarrer des services arrêtés |
