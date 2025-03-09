# 📝 **TP 01 - Découverte de Git et Github**  

## **🎯 Objectifs**  
✔ Apprendre à initialiser un dépôt Git localement.
✔ Savoir stager, committer et visualiser l’hisstorique des modifications.
✔ Expérimenter les branches et les merges.
✔ Découvrir le versionnement collaboratif avec GitHub (push, pull, clone).


## 🔧 Etape 1 : Téléchargement et configuration de Git
### Installation de Git

- Windows : Télécharger et installer depuis [git-scm.com](https://git-scm.com/downloads/win)
- Linux : `sudo apt install git`

::: details ℹ️ Aide d'installation
### Suivez ces étapes pour installer correctement Git
Après avoir téléchargé Git, vous avez un ensemble de configurations à réaliser.
![alt text](image.png)

---

Sur cet écran, vous pouvez sélectionner l'éditeur de texte par défaut que vous voulez utiliser pour la correction des conflits.
Vous pouvez sélectionner celui que vous souhaitez, mais je vous recommande `VSCode` qui est très performant pour faire de la correction de conflit.

![Choix éditeur de texte](image-1.png)

---

Ici on garde le choix recommandé : 
![path env](image-2.png)

---

Pour cette page on garde le choix 1, cela nous permet d'utiliser OpenSSH fournis avec l'installation de Git.
![SSH manager](image-3.png)

---

On garde le choix par défaut.
![https](image-4.png)

---

![line ending](image-5.png)

---

Ici on utilisera MinTTY
![MinTTY](image-6.png)

---

Séléction du choix par défaut : 
![git pull](image-7.png)

---

![git credential](image-8.png)

---

![caching](image-9.png)

---

Il ne vous reste plus qu'a ouvrir  `git Bash`.
Cela permet d'ouvrir une invite de commande qui vous permettra d'utiliser les commandes Linux. 

![git bash](image-10.png)
:::

Vérifier l'installation avec :
```sh
$ git --version
```

### Configuration de Git
Avant d'utiliser Git, configurez votre identité :
```sh
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@example.com"
```

Vous êtes à présent prêt pour utiliser Git dans des bonnes conditions.

## 🔧 Etape 2 : Initialisation d'un dépôt et les premiers commits

#### 🔃 **Initialiser** un dépôt Git

1. **Ouvrir un terminal** sur votre machine.  
2. Créer un nouveau dossier pour votre projet :  
   ```bash
   mkdir mon-projet-git
   cd mon-projet-git
   ```
3. **Initialiser** un dépôt Git dans ce dossier :  
   ```bash
   git init
   ```

---

#### 📂 **Ajouter** un fichier et faire un premier commit 
1. **Créer un fichier `index.html`** dans le dossier et ajouter la structure de base :  
2. Vérifier l’état du dépô :  
   ```bash
   git status
   ```
   👉 Que remarquez-vous ?  

3. Ajouter le fichier dans la zone de staging  
4. Créer un premier commit 
5. Vérifier que le commit a bien été enregistré
   
::: details ℹ️ Aide
   ```bash
   git add index.html
   git commit -m "Ajout du fichier .html"
   ```
   👉 Vérifiez que le commit a bien été enregistré avec :  
   ```bash
   git log --oneline
   ```
:::
---

#### ✏️ **Modifier** un fichier et faire un second commit
1. **Modifier** le fichier `index.html` en ajoutant un titre `<h1>` sur votre page :  
2. **Vérifier** les modifications 
3. **Ajouter** et committer les changements avec un message qui indique ce que vous avez fait.
4. **Consulter** l’historique des commits :  
 

