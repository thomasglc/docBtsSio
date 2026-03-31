# 📝 TP 1 : Mise en place LAMP
> 🎯 Objectif : Installer un serveur LAMP pour héberger un CMS WordPress.

## 1. Préparation du système
Avant toute installation, on s'assure que les dépôts et les paquets sont à jour.

```Bash
apt update && apt upgrade -y
```

Installez directement `ssh`, cela va vous permettre d'accéder à votre machine virtuelle depuis votre ordinateur. N'hésitez pas à changer le port par défaut.

Nous allons aussi directement installer le pare-feu `UFW`.
Autorisez uniquement le port que vous avez ouvert pour votre connexion `ssh` ainsi que le port pour le protocole `http`

## 2. Installation du serveur Web (Apache2)
Apache est le serveur HTTP le plus utilisé. On l'installe de manière minimaliste.

```Bash
apt install apache2 -y
```
Vérification : Tapez l'adresse IP de la VM dans un navigateur. Vous devriez voir la page "Apache2 Debian Default Page".


## 3. Installation de la base de données (MariaDB)
On privilégie MariaDB (fork communautaire de MySQL), standard sous Debian.

```Bash
apt install mariadb-server -y
```

## 4. Installation de PHP (Le moteur)
WordPress nécessite PHP et des extensions spécifiques pour fonctionner (gestion d'images, de la base de données, etc.).

```Bash
apt install php php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip libapache2-mod-php -y
```
Redémarrage d'Apache : Pour prendre en compte PHP.

```Bash
systemctl restart apache2
```
## 5. Création de la base de données pour WordPress
On ne se connecte jamais à WordPress avec le compte "root" de la base de données. On crée un utilisateur dédié.

Connectez-vous à MariaDB : `mysql -u root -p` puis exécutez ces requêtes :

```SQL

-- Création de la base
CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Création de l'utilisateur dédié - Vous devez changer le mot de passe.
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'TonMotDePasseTresSecurise-AChanger';

-- Attribution des droits
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'localhost';

-- Application et sortie
FLUSH PRIVILEGES;
EXIT;
```
## 6. Installation de WordPress
On télécharge la dernière version depuis les sources officielles.

Récupération :

```Bash
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
```
:::tip ❓Question
Que permet de faire la commande `wget` ?  
Quel est l'intérêt de la commande `tar -xzvf` ?
:::

Déplacement vers le répertoire Web :

```Bash
rm -rf /var/www/html/*
cp -r wordpress/* /var/www/html/
```

Gestion des permissions (Crucial) : L'utilisateur qui fait tourner Apache (www-data) doit être propriétaire des fichiers pour permettre les mises à jour et l'upload d'images.

```Bash
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
```

:::tip ❓Question
Présentez l'utilisateur `www-data`. Pourquoi c'est à lui qu'il faut donner les droits ?
:::
## 7. Configuration de l'Hôte Virtuel (VirtualHost)
Pour faire les choses proprement, on crée un fichier de configuration Apache dédié.

Désactiver le site par défaut : `a2dissite 000-default.conf`

Créer `/etc/apache2/sites-available/wordpress.conf` :

```Apache

<VirtualHost *:80>
    ServerAdmin admin@votre-domaine.lan
    DocumentRoot /var/www/html/
    <Directory /var/www/html/>
        AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
:::tip ❓Question
A quoi sert le fichier de configuration présent dans le dossier `sites-available` ?  
Expliquez chaque ligne présent dans le fichier `wordpress.conf`
:::

Activer le site et le module de réécriture (pour les liens WordPress) :

```Bash
a2ensite wordpress.conf
a2enmod rewrite
systemctl restart apache2
```

