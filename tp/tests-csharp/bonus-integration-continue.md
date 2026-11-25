---
outline: deep
---

# TP bonus - L'intégration continue

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Git · GitHub Actions" />

::: info Contexte
Vos tests ne servent que si on les lance. Avec l'**intégration continue**, GitHub les lance tout seul à **chaque push**, sur un serveur à lui. Un collègue casse une règle ? Le dépôt passe au rouge, et tout le monde le voit.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, avec votre solution `Authentification`. Il faut un **compte GitHub** et **Git** installé sur le poste. Collez vos **captures d'écran** dans le **document de restitution**, puis déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp-bonus-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Intégration continue** | Les tests sont lancés automatiquement à chaque modification du code |
| **Workflow** | Le fichier qui décrit à GitHub ce qu'il doit faire, et quand |
| **Badge** | Une petite image qui affiche l'état des tests dans le README |

---

## Mission 1 - Le dépôt GitHub

### Tâche 1.1 - Créer le dépôt

Sur GitHub : **New repository**, nom `authentification-tests`, **sans** README. Copiez l'adresse du dépôt.

### Tâche 1.2 - Envoyer la solution

Dans Visual Studio, ouvrez **Affichage** > **Terminal** : il s'ouvre dans le dossier de la solution. Tapez, une ligne à la fois :

```bash
dotnet new gitignore
git init
git add .
git commit -m "Module d'authentification et ses tests"
git branch -M main
git remote add origin https://github.com/VOTRE-COMPTE/authentification-tests.git
git push -u origin main
```

`dotnet new gitignore` évite d'envoyer les dossiers `bin` et `obj`, qui sont recréés à chaque compilation.

---

## Mission 2 - Le workflow

### Tâche 2.1 - Écrire le fichier

Dans le terminal, créez les dossiers et ouvrez le nouveau fichier dans le Bloc-notes (répondez **Oui** pour le créer) :

```bash
mkdir .github/workflows
notepad .github/workflows/tests.yml
```

Collez ce contenu, puis enregistrez :

```yaml
name: Tests

on: [push]

jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.0.x'
      - run: dotnet test
```

| Ligne | Rôle |
|---|---|
| `on: [push]` | Quand : à chaque push |
| `runs-on: ubuntu-latest` | Où : sur un serveur Linux prêté par GitHub |
| `actions/checkout` | Récupérer votre code |
| `actions/setup-dotnet` | Installer .NET 8 |
| `run: dotnet test` | Lancer **tous** vos tests |

### Tâche 2.2 - Envoyer

```bash
git add .
git commit -m "Intégration continue"
git push
```

Sur GitHub, ouvrez l'onglet **Actions** : votre workflow tourne, puis affiche une coche verte ✅.

::: tip 📸 Capture 1
L'onglet Actions, avec votre premier workflow en vert.
:::

---

## Mission 3 - Casser, puis réparer

### Tâche 3.1 - Le sabotage

Dans `PolitiqueMotDePasse`, remettez le bug du TP 1 : `>` au lieu de `>=`. Faites un commit et un push.

Sur GitHub : croix rouge ❌. Ouvrez le workflow, puis l'étape **Run dotnet test** : le nom du test en échec y est écrit.

::: tip 📸 Capture 2
Le workflow rouge, avec le test en échec visible dans le journal.
:::

### Tâche 3.2 - La réparation

Corrigez, faites un commit et un push : le dépôt repasse au vert ✅.

### Tâche 3.3 - Le badge

Créez le fichier `README.md` à la racine de la solution, avec `notepad README.md` :

```markdown
# Module d'authentification

![Tests](https://github.com/VOTRE-COMPTE/authentification-tests/actions/workflows/tests.yml/badge.svg)
```

Remplacez `VOTRE-COMPTE`, puis envoyez-le. La page d'accueil du dépôt affiche maintenant l'état des tests.

::: tip 📸 Capture 3
La page d'accueil du dépôt, avec le badge.
:::

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les **3 captures**.
:::
