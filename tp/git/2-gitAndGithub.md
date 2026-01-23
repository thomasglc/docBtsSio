# 📝 **TP 02 - Git et Github**  

## **🎯 Objectifs**  
✔ Création d'une clé SSH  
✔ Découvrir le versionnement GitHub (push, pull, clone).  
✔ Rejoindre le repository d'un collègue.  


## **🔑 Étape 1 : Génération d’une clé SSH et connexion à GitHub**  


1. **Générer une nouvelle clé SSH** :  
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   - Appuyez sur `Entrée` pour choisir l’emplacement par défaut.  
   - Si demandé, définissez (ou non) une phrase de passe.  

2. **Afficher la clé publique pour la copier** :  
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   - Copier son contenu (tout le texte).  

3. **Ajouter la clé SSH à GitHub** :  
   - Aller sur **Github** → **Settings** → **SSH and GPG keys** ([Configuration des clés SSH](https://github.com/settings/keys)).  
   - Cliquer sur **New SSH Key** → **Coller la clé** → **Ajouter**.  

4. **Vérifier la connexion avec GitHub** :  
   ```bash
   ssh -T git@github.com
   ```
   - Si tout est bien configuré, un message de bienvenue apparaît. 


## **📤 Étape 2 : Associer un dépôt local à GitHub**  

1. **Créer un dépôt GitHub distant** :  
   - Aller sur **GitHub** → **New Repository**.  
   - Nommer le dépôt `tp-git-github` et cliquer sur **Create Repository**.  
   - **Ne pas** initialiser avec un fichier README ou `.gitignore`.  

2. Retourner dans votre invite de commande Git à l'endroit ou vous avez votre projet Git.

3. **Ajouter le dépôt distant GitHub** :  
   ```bash
   git remote add origin git@github.com:VOTRE-UTILISATEUR/tp-git-github.git
   ```

4. **Vérifier que la remote a bien été ajoutée** :  
   ```bash
   git remote -v
   ```
   - Vous devez voir une ligne contenant `origin` suivi du lien SSH GitHub.  

5. **Envoyer le projet sur GitHub** :  
   ```bash
   git push origin main
   ```
   - Aller sur **GitHub** et vérifier que le code est bien en ligne.  

  ::: danger Attention
  Quand vous utilisez la commande précédente, vous poussez uniquement la branche `main`. Les autres branches ne sont pas disponibles depuis Github.
  Vous pouvez pousser toutes les branches d'un coup si vous souhaitez en utilisant la commande suivante : 
  ```bash
  git push --all origin
  ```
  :::

6. **Simuler un changement à distance** :  
   - Modifier un fichier directement **sur GitHub** via l’interface web.  
   - Télécharger la modification en local :  
     ```bash
     git pull origin main
     ```


## **👥 Étape 3 : Collaborer sur un dépôt distant**  

1. **Récupérer le TP de votre voisin**.  
   - Exemple : `git@github.com:UTILISATEUR-VOISIN/tp-git-github.git`. 

2. **Cloner son dépôt** :  
   ```bash
   git clone git@github.com:UTILISATEUR-VOISIN/tp-git-github.git
   ```

3. **Ajouter un fichier `style.css` dans le projet de votre voisin pour mettre le background en rouge** :  
   - Commitez vos modifications et poussez-les sur le Github de votre voisin.
   - Normalement vous allez recevoir un message d'erreur indiquant que vous n'avez pas les droits d'écriture.
   - Demandez à votre voisin de vous ajouter en tant que collaborateur sur le projet
   - **Settings** -> **Collaborators** -> **Add people**

4. **Votre collègue récupère votre modification** :  
   ```bash
   git pull origin main
   ```

::: tip Tip 📢


Les modifications et commits que vous effectuez en local ne sont visibles que sur votre ordinateur.

💡 Tant que vous ne faites pas un git push, vos collègues ne peuvent pas voir votre travail sur GitHub !

✅ Pensez à pousser régulièrement votre code avec :

```bash
git push origin NOM_DE_LA_BRANCHE
```
🚀 Bonne pratique : Avant de pousser, récupérez aussi les dernières modifications des autres avec :

```bash
git pull origin NOM_DE_LA_BRANCHE
```
Cela évite les conflits et garde votre code à jour ! 🔄
:::