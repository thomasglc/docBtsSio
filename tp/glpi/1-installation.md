---
outline: deep
---

# TP 1 — Installation de GLPI sur Debian

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="GLPI + Debian + LAMP" />

::: info Contexte
La société **TechServices** souhaite mettre en place un outil centralisé pour gérer son parc informatique et assurer le suivi des demandes d'assistance. Vous êtes chargé d'installer **GLPI** (Gestionnaire Libre de Parc Informatique) sur le serveur Debian de l'entreprise, dont la pile LAMP est déjà opérationnelle.
:::

::: warning Modalités
Une VM Debian préconfigurée est disponible sur le serveur NAS. Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Qu'est-ce que GLPI ?

**GLPI** (Gestionnaire Libre de Parc Informatique) est une application web open source qui permet de :

- **Gérer un parc informatique** — ordinateurs, écrans, imprimantes, logiciels, licences…
- **Gérer les tickets d'assistance** — incidents, demandes, suivi des interventions
- **Suivre les contrats et fournisseurs** — maintenance, garanties, budgets

C'est l'un des outils les plus utilisés dans les PME et collectivités françaises. Il s'installe sur un serveur web Linux et s'utilise depuis n'importe quel navigateur.

---

## Mission 0 — Importer la VM préconfigurée

Une VM Debian avec LAMP et GLPI déjà déployés est disponible sur le serveur NAS. Vous allez l'importer dans VirtualBox.

**Tâche 0.1 — Récupérer le fichier OVA**

Depuis votre poste, accédez au partage réseau `\\serveur-nas` et copiez le fichier `glpi-debian.ova` vers votre bureau (ou un dossier local).

**Tâche 0.2 — Importer la VM dans VirtualBox**

Dans VirtualBox, allez dans **Fichier → Importer un appareil virtuel**, sélectionnez le fichier `.ova` et cliquez sur **Suivant**.

Vérifiez les paramètres proposés (RAM, CPU) et cliquez sur **Importer**. L'opération peut prendre quelques minutes.

**Tâche 0.3 — Démarrer la VM et vérifier les services**

Démarrez la VM importée puis connectez-vous. Vérifiez que les services sont bien actifs :

```bash
systemctl status apache2
systemctl status mariadb
```

::: tip 📸 Capture 1
Services Apache et MariaDB actifs sur la VM importée.
:::

---

## Mission 1 — Installation via l'interface web

Depuis un navigateur (sur votre poste ou une VM cliente), accédez à :

```
http://[adresse-IP-du-serveur]
```

::: info Trouver l'adresse IP du serveur
Si vous ne connaissez pas l'adresse IP de votre serveur Debian, exécutez `ip a` dans son terminal.
:::

### Étape 1 — Choix de la langue

Sélectionnez **Français** et cliquez sur **OK**.

::: tip 📸 Capture 2
Page de sélection de la langue — Français sélectionné.
:::

### Étape 2 — Acceptation de la licence

Lisez rapidement la licence GPL et cliquez sur **Continuer**.

### Étape 3 — Type d'installation

Choisissez **Installer** (et non "Mettre à jour").

### Étape 4 — Vérification des prérequis

GLPI vérifie automatiquement que toutes les extensions PHP nécessaires sont présentes. Vous devez voir une liste avec uniquement des indicateurs **verts**.

:: tip 
Normalement vous devriez voir la librairie `bcmath` manquante. Installez la avec la commande suivante puis redémarrez le service apache.
``` bash
sudo apt install php-bcmath
```
:::

::: tip 📸 Capture 3
Page de vérification des prérequis — tous les indicateurs au vert.
:::

### Étape 5 — Configuration de la base de données

Renseignez les informations de connexion à MariaDB :

| Champ | Valeur |
|---|---|
| Serveur SQL | `localhost` |
| Utilisateur SQL | `glpi` |
| Mot de passe SQL | `glpi` |

Cliquez sur **Continuer**.

::: tip 📸 Capture 4
Page de configuration de la base de données — champs remplis.
:::

### Étape 6 — Sélection de la base de données

Dans la liste déroulante, sélectionnez la base **glpi**. Cliquez sur **Continuer**.

### Étape 7 — Finalisation

GLPI installe automatiquement toutes les tables dans la base de données. Cette étape peut prendre quelques secondes. Une page de confirmation apparaît avec les **identifiants par défaut**.

::: warning Notez ces identifiants
| Identifiant | Mot de passe | Profil |
|---|---|---|
| `glpi` | `glpi` | Super-administrateur |
| `tech` | `tech` | Technicien |
| `normal` | `normal` | Normal |
| `post-only` | `postonly` | Observateur |

**Ces comptes par défaut sont publiquement connus — ils seront changés immédiatement après installation.**
:::

::: tip 📸 Capture 5
Page de fin d'installation affichant les identifiants par défaut.
:::

Cliquez sur **Utiliser GLPI** pour accéder à l'interface.

---

## Mission 2 — Sécuriser l'installation

**Tâche 2.1 — Supprimer le répertoire d'installation**

Le dossier `install/` n'a plus aucune utilité et représente une faille de sécurité s'il reste accessible. Supprimez-le immédiatement :

```bash
rm -rf /var/www/html/glpi/install
```

::: danger Ne pas oublier cette étape
Tant que le dossier `install/` est présent, n'importe qui ayant accès à l'URL de GLPI pourrait relancer l'assistant d'installation et écraser la base de données.
:::

**Tâche 2.2 — Changer les mots de passe par défaut**

Connectez-vous avec le compte **glpi / glpi**, puis naviguez dans **Administration → Utilisateurs**.

Pour chaque compte par défaut (`glpi`, `tech`, `normal`, `post-only`), cliquez sur le compte puis sur **Modifier** et changez le mot de passe.

::: tip 📸 Capture 6
Page d'administration des utilisateurs dans GLPI — liste des comptes visible.
:::

**Tâche 2.3 — Vérifier la suppression du dossier install**

Essayez d'accéder à `http://[IP]/install/install.php` depuis le navigateur. Vous devez voir une redirection sur la page principale.

---

## Mission 3 — Tour de GLPI

Vous allez maintenant explorer les différentes sections de GLPI afin de rédiger un document de présentation. Ce document sera utilisé comme référence par les futurs utilisateurs de l'outil.

::: info Objectif
Pour chaque section ci-dessous, explorez l'interface, notez son rôle et réalisez une capture d'écran. Ces éléments constitueront votre document de présentation.
:::

### Section 1 — Tableau de bord (accueil)

La page d'accueil affiche un résumé de l'activité : tickets ouverts, assets récents, indicateurs de parc.

**À noter dans votre document :** à quoi sert cette vue d'ensemble ? Qui l'utilise au quotidien ?

::: tip 📸 Capture 7
Tableau de bord GLPI après connexion avec le compte administrateur.
:::

### Section 2 — Parc

Naviguez dans le menu **Parc**. Cette section permet de gérer tous les équipements de l'entreprise.

Explorez les sous-menus :

| Sous-menu | Contenu |
|---|---|
| Ordinateurs | Liste des postes de travail et serveurs |
| Moniteurs | Écrans associés aux postes |
| Logiciels | Catalogue des logiciels installés |
| Réseaux | Équipements réseau (switchs, routeurs) |
| Périphériques | Imprimantes, téléphones, etc. |

**À noter dans votre document :** quelles informations peut-on enregistrer pour un ordinateur (marque, modèle, numéro de série, utilisateur affecté…) ?

::: tip 📸 Capture 8
Page **Parc → Ordinateurs** dans GLPI.
:::

### Section 3 — Assistance

Naviguez dans le menu **Assistance → Tickets**. C'est ici que sont gérées toutes les demandes d'intervention des utilisateurs.

Cliquez sur **+ Créer un ticket** et observez le formulaire sans le valider.

**À noter dans votre document :** quels types de tickets existe-t-il (incident, demande) ? Quels champs sont obligatoires ?

::: tip 📸 Capture 9
Formulaire de création d'un ticket dans GLPI.
:::

### Section 4 — Gestion

Naviguez dans le menu **Gestion**. Cette section regroupe les éléments financiers et contractuels.

| Sous-menu | Contenu |
|---|---|
| Budgets | Enveloppes budgétaires liées aux achats |
| Fournisseurs | Liste des prestataires et fabricants |
| Contacts | Interlocuteurs chez les fournisseurs |
| Contrats | Contrats de maintenance et licences |

**À noter dans votre document :** en quoi la section Gestion est-elle utile pour le suivi des contrats de maintenance ?

::: tip 📸 Capture 10
Page **Gestion → Fournisseurs** dans GLPI.
:::

### Section 5 — Administration et Configuration

Naviguez dans **Administration** puis dans **Configuration** (via la roue dentée en haut à droite).

Ces deux menus permettent de gérer :
- Les **utilisateurs et leurs profils** (qui peut faire quoi dans GLPI)
- Les **entités** (divisions de l'entreprise)
- Les **règles de routage** des tickets
- Les **paramètres généraux** (nom du helpdesk, URL, mail…)

**À noter dans votre document :** quelle est la différence entre un profil "Super-administrateur" et un profil "Technicien" ?

::: tip 📸 Capture 11
Page **Administration → Profils** dans GLPI — liste des profils disponibles.
:::

---

## Document de présentation à rédiger

::: danger À rendre
En plus du rapport-annexe, vous devez rédiger un **document de présentation de GLPI** (format PDF, 1 à 2 pages) destiné à un responsable informatique non-technicien. Ce document doit répondre aux questions suivantes :
:::

1. Qu'est-ce que GLPI et à quoi sert-il concrètement dans une entreprise ?
2. Présentez les **5 sections principales** de l'interface (une courte description + capture pour chacune).
3. Qui sont les utilisateurs types de GLPI dans une entreprise (rôles, profils) ?
4. Citez **deux avantages** de l'utilisation de GLPI par rapport à un suivi sur tableur Excel.

::: warning Critères de rédaction
Le document doit être clair et illustré. Il s'adresse à quelqu'un qui ne connaît pas GLPI — évitez le jargon technique sans explication. Utilisez vos captures de la Mission 3 pour illustrer chaque section.
:::

::: danger Rendu sur Moodle
Déposez sur Moodle :
- Votre **rapport-annexe** (PDF) avec les 12 captures numérotées et légendées
- Votre **document de présentation** (PDF)
:::
