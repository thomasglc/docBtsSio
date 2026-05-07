---
outline: deep
---

# TP 3 — Gestion des tickets d'assistance avec GLPI

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Administration système" />  <Badge type="danger" text="GLPI + Helpdesk + ITIL" />

::: info Contexte
La société **TechServices** dispose désormais d'un GLPI opérationnel avec un parc informatique alimenté. Votre responsable souhaite maintenant **ouvrir le helpdesk** : les employés pourront soumettre leurs demandes d'assistance directement dans GLPI, et les techniciens les traiteront depuis l'interface. Votre mission est de configurer ce système et d'en simuler l'utilisation de bout en bout.
:::

::: warning Modalités
Vous avez besoin de votre VM-Serveur GLPI issue du TP 1. Aucune VM supplémentaire n'est nécessaire — vous allez simuler plusieurs rôles en changeant de compte dans le navigateur (ou en utilisant une navigation privée pour un deuxième compte simultané).

Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸.
:::

---

## Le helpdesk dans GLPI

Le module **Assistance** de GLPI est un système de ticketing conforme aux bonnes pratiques **ITIL** (Information Technology Infrastructure Library). Il permet de :

- Centraliser toutes les demandes des utilisateurs dans un seul outil
- Distinguer les **incidents** (quelque chose est cassé) des **demandes** (une action est requise)
- Suivre le cycle de vie de chaque ticket : ouverture → attribution → traitement → résolution → clôture
- Lier les tickets aux équipements du parc pour tracer les interventions

| Type de ticket | Définition | Exemple |
|---|---|---|
| **Incident** | Interruption ou dégradation d'un service | Mon PC ne démarre plus |
| **Demande** | Requête planifiée pour un service ou une ressource | Installer le logiciel Inkscape |

---

## Mission 1 — Créer les utilisateurs du helpdesk

Pour simuler un vrai helpdesk, vous allez créer deux comptes : un **utilisateur lambda** (qui soumet les tickets) et un **technicien** (qui les traite). GLPI gère les droits via des **profils** — un profil définit ce que chaque type de compte peut voir et faire.

### Tâche 1.1 — Explorer les profils existants

Connectez-vous à GLPI avec le compte administrateur (**glpi**), puis naviguez dans **Administration → Profils**.

Observez les profils disponibles et notez leur rôle :

| Profil | Rôle |
|---|---|
| `Super-Admin` | Accès total à toutes les fonctions de GLPI |
| `Admin` | Administration sans accès à la configuration globale |
| `Technician` | Traitement des tickets et gestion du parc |
| `Hotliner` | Création et suivi de tickets, sans accès au parc |
| `Observer` | Lecture seule |
| `Self-Service` | Portail simplifié : soumet et consulte uniquement ses propres tickets |

Cliquez sur le profil **Self-Service** pour consulter les droits associés. Ce profil correspond à ce que voient les employés non-techniciens.

::: tip 📸 Capture 1
Page **Administration → Profils** — liste des profils. Le profil **Self-Service** est ouvert et ses droits sont visibles.
:::

### Tâche 1.2 — Créer un utilisateur standard

Naviguez dans **Administration → Utilisateurs**, puis cliquez sur **+ Ajouter**.

Renseignez les champs suivants :

| Champ | Valeur |
|---|---|
| Identifiant | `m.dupont` |
| Prénom | `Marie` |
| Nom | `Dupont` |
| Mot de passe | `Password1!` |
| Profil par défaut | `Self-Service` |
| Entité | `Entité racine` |

Cliquez sur **Ajouter**.

::: info Pourquoi le profil Self-Service ?
Ce profil donne accès à un portail simplifié où l'utilisateur ne voit que ses propres tickets. Il ne peut pas parcourir le parc ou modifier la configuration — exactement ce qu'il faut pour un employé ordinaire.
:::

::: tip 📸 Capture 2
Formulaire de création de l'utilisateur `m.dupont` — champs remplis avant validation.
:::

### Tâche 1.3 — Créer un utilisateur technicien

Toujours dans **Administration → Utilisateurs**, créez un second compte :

| Champ | Valeur |
|---|---|
| Identifiant | `j.martin` |
| Prénom | `Jean` |
| Nom | `Martin` |
| Mot de passe | `Password1!` |
| Profil par défaut | `Technician` |
| Entité | `Entité racine` |

Cliquez sur **Ajouter**.

::: tip 📸 Capture 3
Formulaire de création de l'utilisateur `j.martin` — profil **Technician** sélectionné.
:::

---

## Mission 2 — Configurer les catégories de tickets

Les **catégories** permettent de classer les tickets par nature (matériel, réseau, logiciel…). Elles facilitent le routage des demandes vers le bon technicien et la production de statistiques par domaine.

### Tâche 2.1 — Accéder aux catégories ITIL

Naviguez dans **Configuration → Intitulés** (accessible via l'icône de roue dentée en haut à droite).

Dans la liste des intitulés, repérez la section **Assistance** et cliquez sur **Catégories ITIL**.

### Tâche 2.2 — Créer les catégories

Créez les quatre catégories suivantes en cliquant sur **+ Ajouter** pour chacune :

| Nom | Commentaire |
|---|---|
| `Matériel` | Pannes et problèmes physiques (PC, écran, imprimante…) |
| `Réseau` | Connectivité, accès Internet, Wi-Fi |
| `Logiciel` | Installation, mise à jour, dysfonctionnement applicatif |
| `Accès & Droits` | Création de compte, réinitialisation de mot de passe, droits d'accès |

::: info Astuce
Pour chaque catégorie, renseignez le champ **Nom** et (optionnel) un **Commentaire** décrivant son usage. Laissez les autres champs vides pour l'instant.
:::

::: tip 📸 Capture 4
Page **Catégories ITIL** listant les quatre catégories créées.
:::

---

## Mission 3 — Créer des tickets (côté utilisateur)

Vous allez maintenant jouer le rôle de **Marie Dupont**, une employée de TechServices qui rencontre deux problèmes. Ouvrez une fenêtre de navigation privée pour vous connecter simultanément avec son compte sans déconnecter l'administrateur.

### Tâche 3.1 — Se connecter avec le compte utilisateur

Ouvrez une **fenêtre de navigation privée** (Ctrl+Maj+N) et accédez à l'URL de votre GLPI.

Connectez-vous avec :
- Identifiant : `m.dupont`
- Mot de passe : `Password1!`

Vous arrivez sur le **portail Self-Service** — une vue épurée, très différente de l'interface administrateur. Marie ne voit que les éléments qui la concernent.

::: tip 📸 Capture 5
Portail Self-Service de `m.dupont` après connexion — interface simplifiée visible.
:::

### Tâche 3.2 — Créer un ticket incident

Cliquez sur **Créer un ticket**.

Renseignez le formulaire :

| Champ | Valeur |
|---|---|
| Type | **Incident** |
| Catégorie | `Matériel` |
| Urgence | `Haute` |
| Titre | `Mon PC ne démarre plus depuis ce matin` |
| Description | `Depuis ce matin, mon PC (PC-Direction-01) ne s'allume plus. L'écran reste noir et on entend un bip au démarrage. J'ai besoin de mon poste pour travailler.` |

Cliquez sur **Envoyer le message** (ou **Soumettre**).

::: info Incident vs Demande
Vous sélectionnez **Incident** car il s'agit d'une interruption de service non planifiée. Une **Demande** s'utilise pour une action voulue et anticipée (installation, création de compte…).
:::

::: tip 📸 Capture 6
Récapitulatif du ticket incident créé depuis le portail de `m.dupont` — numéro de ticket visible.
:::

### Tâche 3.3 — Créer une demande de service

Revenez sur le portail et cliquez à nouveau sur **Créer un ticket**.

| Champ | Valeur |
|---|---|
| Type | **Demande** |
| Catégorie | `Logiciel` |
| Urgence | `Basse` |
| Titre | `Installation du logiciel LibreOffice` |
| Description | `Bonjour, pourriez-vous installer LibreOffice sur mon poste ? J'en ai besoin pour lire des fichiers .odt envoyés par un partenaire. Aucune urgence, d'ici la fin de la semaine c'est parfait.` |

Cliquez sur **Envoyer le message**.

::: tip 📸 Capture 7
Portail de `m.dupont` affichant ses **deux tickets** créés (l'incident et la demande) avec leur statut **Nouveau**.
:::

---

## Mission 4 — Traiter les tickets (côté technicien)

Repassez sur votre navigateur principal (administrateur) et **déconnectez-vous** du compte admin. Connectez-vous maintenant avec le compte technicien **j.martin**.

### Tâche 4.1 — Consulter la file des tickets

Après connexion, naviguez dans **Assistance → Tickets**.

Jean Martin voit tous les tickets ouverts assignés à son groupe ou non attribués. Repérez les deux tickets créés par Marie Dupont.

::: tip 📸 Capture 8
Liste des tickets dans l'interface du technicien `j.martin` — les deux tickets de `m.dupont` sont visibles avec leur statut **Nouveau**.
:::

### Tâche 4.2 — S'attribuer le ticket incident

Ouvrez le ticket **"Mon PC ne démarre plus depuis ce matin"**.

Dans la section **Techniciens**, cliquez sur **Attribuer à moi-même**.

Observez que le statut du ticket passe automatiquement de **Nouveau** à **En cours (attribué)**.

::: tip 📸 Capture 9
Fiche du ticket incident — statut **En cours (attribué)** et technicien `j.martin` affiché dans la section assignation.
:::

### Tâche 4.3 — Ajouter un suivi

Un **suivi** est un commentaire visible par toutes les parties (technicien et utilisateur). Il sert à communiquer sur l'avancement du ticket.

Dans la fiche du ticket, cliquez sur **Répondre**, puis saisissez :

> Bonjour Marie, j'ai bien pris en charge votre ticket. Je vais passer sur votre poste dans la matinée pour diagnostiquer la panne. Je vous tiendrai informée de l'avancement.

Cochez **Notifier par e-mail** si l'option est disponible, puis cliquez sur **Ajouter**.

::: tip 📸 Capture 10
Suivi ajouté au ticket — le message du technicien apparaît dans le fil de discussion du ticket.
:::

### Tâche 4.4 — Ajouter une tâche

Une **tâche** représente une action concrète à réaliser, avec une durée estimée. Elle sert à planifier et tracer le temps de travail.

Dans la fiche du ticket, cliquez sur le bouton **Tâche** en bas de page (à côté du bouton **Répondre**).

| Champ | Valeur |
|---|---|
| Description | `Diagnostic sur site : vérification des branchements, test alimentation, analyse des bips POST` |
| Statut | `À faire` |
| Durée | `30 minutes` |
| Technicien | `Jean Martin` |

Cliquez sur **Ajouter**.

::: tip 📸 Capture 11
Onglet **Tâches** du ticket — la tâche de diagnostic est créée avec sa durée estimée.
:::

### Tâche 4.5 — Lier le ticket à un asset du parc

L'un des atouts de GLPI est de pouvoir **relier un ticket à l'équipement concerné**. Cela permet de retrouver l'historique des interventions directement depuis la fiche d'un asset.

Dans la fiche du ticket, repérez la section **Éléments** (ou **Matériel associé**) et cliquez sur **+ Ajouter un élément**.

Recherchez et sélectionnez l'ordinateur **PC-Direction-01** (créé lors du TP 2).

::: info Pourquoi lier le ticket à l'asset ?
En ouvrant la fiche de `PC-Direction-01` dans **Parc → Ordinateurs**, vous verrez désormais tous les tickets qui lui ont été rattachés. Un technicien qui intervient sur ce poste dans 6 mois pourra consulter l'historique complet des pannes — un gain de temps considérable.
:::

::: tip 📸 Capture 12
Section **Éléments** du ticket — `PC-Direction-01` apparaît en tant qu'équipement associé.
:::

### Tâche 4.6 — Vérifier l'avancement côté utilisateur

Avant de résoudre le ticket, repassez sur la fenêtre de navigation privée (compte `m.dupont`).

Marie peut suivre l'évolution de son ticket en temps réel : le statut est passé à **En cours (attribué)** et le suivi laissé par Jean Martin est visible dans le fil de discussion.

::: tip 📸 Capture 13
Portail de `m.dupont` — ticket incident en statut **En cours (attribué)** avec le message du technicien visible dans le fil de discussion.
:::

Repassez ensuite sur le compte **j.martin** pour continuer le traitement.

### Tâche 4.7 — Résoudre le ticket

Jean a terminé son intervention. Il va maintenant renseigner la solution et passer le ticket en **Résolu**.

Dans la fiche du ticket, allez dans la section **Solution** et saisissez :

> Le condensateur de l'alimentation était défaillant. Remplacement de l'alimentation par une unité de rechange (réf. PSU-450W-01 issue du stock). Le poste a redémarré correctement. Test de stabilité effectué pendant 15 minutes — aucun incident. Le poste est rendu à l'utilisatrice.

Dans le champ **Type de solution**, sélectionnez **Solution connue**.

Cliquez sur **Sauvegarder** — le statut du ticket passe en **Résolu**.

::: tip 📸 Capture 14
Fiche du ticket avec la solution renseignée — statut **Résolu** visible en haut du ticket.
:::

### Tâche 4.8 — Vérifier la clôture côté utilisateur

Repassez sur la fenêtre de navigation privée (compte `m.dupont`).

Marie voit maintenant son ticket en statut **Résolu**. En entreprise, GLPI peut être configuré pour clôturer automatiquement les tickets résolus après un délai (ex : 7 jours sans réponse de l'utilisateur), ou l'utilisateur peut les clôturer manuellement.

Depuis le portail de Marie, cliquez sur le ticket résolu puis sur le bouton **Clore le ticket** (ou **Marquer comme résolu**).

::: tip 📸 Capture 15
Portail de `m.dupont` affichant le ticket incident en statut **Clos** — cycle de vie complet.
:::

---

## Mission 5 — Comprendre les priorités (urgence × impact)

GLPI calcule automatiquement la **priorité** d'un ticket en croisant deux critères saisis à la création :

- **Urgence** : dans quel délai faut-il résoudre le problème ?
- **Impact** : combien de personnes ou de services sont affectés ?

La priorité résultante détermine l'ordre de traitement et peut déclencher des alertes.

| | Impact faible | Impact moyen | Impact fort |
|---|---|---|---|
| **Urgence faible** | Très basse | Basse | Moyenne |
| **Urgence moyenne** | Basse | Moyenne | Haute |
| **Urgence forte** | Moyenne | Haute | Très haute |

### Tâche 5.1 — Créer un ticket de priorité critique

Connectez-vous avec le compte **glpi** (administrateur) depuis votre navigateur principal.

Naviguez dans **Assistance → Tickets → + Ajouter**.

Renseignez :

| Champ | Valeur |
|---|---|
| Type | `Incident` |
| Catégorie | `Réseau` |
| Urgence | `Très haute` |
| Impact | `Très haut` |
| Titre | `Coupure réseau totale — tous les postes hors ligne` |
| Description | `Suite à une panne du switch principal (SW-Principal-01), tous les postes du réseau sont coupés d'Internet et des ressources partagées. La production est à l'arrêt.` |
| Technicien assigné | `Jean Martin` |

Cliquez sur **Ajouter**.

Observez la **couleur rouge** et le badge **Très haute** associés à ce ticket dans la liste.

::: tip 📸 Capture 16
Fiche du ticket "Coupure réseau totale" — priorité **Très haute** affichée en rouge, urgence et impact renseignés.
:::

### Tâche 5.2 — Comparer les priorités dans la liste

Retournez dans **Assistance → Tickets**. Vous avez maintenant plusieurs tickets avec des priorités différentes.

Observez comment la liste les présente : les tickets critiques apparaissent en rouge, les tickets normaux en vert ou sans couleur.

::: tip 📸 Capture 17
Liste **Assistance → Tickets** affichant plusieurs tickets avec des codes couleur de priorité différents.
:::

---

## Mission 6 — Exploiter les statistiques du helpdesk

GLPI propose des tableaux de bord et des statistiques pour piloter l'activité du helpdesk. Un responsable informatique peut ainsi mesurer la charge de travail, les délais de traitement et les catégories les plus sollicitées.

### Tâche 6.1 — Consulter le tableau de bord Assistance

Naviguez dans **Assistance → Tableau de bord** (ou **Accueil** si le tableau de bord global s'affiche).

Observez les indicateurs présents :
- Nombre de tickets **ouverts**
- Nombre de tickets **résolus**
- Tickets **en retard** (délai dépassé)
- Répartition par **statut**

::: tip 📸 Capture 18
Tableau de bord **Assistance** — indicateurs clés visibles (tickets ouverts, résolus, en retard).
:::

### Tâche 6.2 — Consulter les statistiques par catégorie

Naviguez dans **Assistance → Statistiques → Ticket global**.

Dans le formulaire, sélectionnez :
- **Période** : ce mois
- **Regroupement** : par catégorie

Cliquez sur **Valider** et observez la répartition des tickets selon les catégories créées en Mission 2.

::: tip 📸 Capture 19
Page des statistiques GLPI — répartition des tickets par catégorie affichée sous forme de tableau ou graphique.
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Quelle est la différence entre un **incident** et une **demande** ?
2. Quel est l'intérêt de **lier un ticket à un asset du parc** (comme vous l'avez fait avec `PC-Direction-01`) ? Qui en bénéficie et dans quelle situation ?
3. Expliquez le fonctionnement de la matrice **urgence × impact**. Pourquoi ne pas laisser les utilisateurs choisir eux-mêmes la priorité de leurs tickets ?
4. Quelle est la différence entre un **suivi** et une **tâche** dans un ticket GLPI ?
5. Un employé vous signale qu'il ne voit pas le ticket qu'il vient de créer dans la liste des tickets de GLPI. Quelle en est la cause probable, et comment l'expliquer simplement à cet utilisateur ?
6. Le responsable informatique vous demande un rapport mensuel sur le nombre de tickets par catégorie. Comment GLPI vous permet-il de répondre à cette demande sans extraire les données manuellement ?

::: danger Rendu sur Moodle
Déposez votre **rapport-annexe** (PDF) avec les 19 captures numérotées et légendées ainsi que vos réponses aux questions de synthèse.
:::
