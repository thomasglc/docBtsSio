

# 📝 **TP 04 - Gestion de session, cookies et redirections en PHP**  

## 🎯 **Objectifs**  
✔ Comprendre et manipuler les **sessions** en PHP  
✔ Utiliser **les cookies** pour stocker des informations persistantes  
✔ Apprendre à gérer les **redirections avec `header()`**  
✔ Créer un **système de connexion simple** (sans base de données)  


## **🔧 Exercice 1 : Mise en place de la connexion avec les sessions**
### **Objectif :** Permettre aux utilisateurs de se connecter à une page sécurisée grâce aux sessions  

1. **Créez une page `login.php`** qui contient un formulaire avec :  
   - Un champ pour le **nom d’utilisateur (`login`)**  
   - Un champ pour le **mot de passe (`password`)**  
   - Un bouton **Se connecter**  

2. **Vérifiez les identifiants dans `login.php`** après soumission du formulaire :  
   - Acceptez uniquement le couple `admin / 1234`  
   - Si les identifiants sont corrects :  
     - Démarrez une **session PHP (`session_start()`)**  
     - Stockez le **nom d’utilisateur en session**  
     - Redirigez vers `dashboard.php` en utilisant `header("Location: dashboard.php");`  
   - Sinon, affichez un message d’erreur  



## **🔧 Exercice 2 : Sécuriser l’accès à une page avec les sessions**
###  **Objectif :** Bloquer l’accès à `dashboard.php` si l’utilisateur n’est pas connecté  

1. **Créez une page `dashboard.php`** qui :  
   - Démarre la session (`session_start()`)  
   - Vérifie si l’utilisateur est connecté  
   - Si ce n’est pas le cas, **redirige vers `login.php`**  
   - Affiche un message de bienvenue avec le nom d’utilisateur  



## **🔧 Exercice 3 : Ajouter un bouton de déconnexion**
###  **Objectif :** Permettre à l’utilisateur de se déconnecter en détruisant sa session  

1. **Créez une page `logout.php`** qui :  
   - Démarre la session  
   - Détruit la session (`session_destroy()`)  
   - Redirige l’utilisateur vers `login.php`  

2. **Ajoutez un bouton "Se déconnecter" sur `dashboard.php`** pointant vers `logout.php`  

::: details ℹ️ Aide
```html
    <p><a href="logout.php">Se déconnecter</a></p>
```
:::

## **🎁 Exercice 4 (bonus) : Utilisation des cookies pour retenir l’utilisateur**
###  **Objectif :** Permettre à l’utilisateur de rester connecté même après la fermeture du navigateur  

1. **Dans `login.php`**, si l’utilisateur coche **"Se souvenir de moi"** :  
   - Créez un cookie **`remember_user`** stockant le login (durée : 7 jours)  
   - Au prochain accès, remplissez automatiquement le champ login  

2. **Dans `dashboard.php`**, affichez un message indiquant si l’utilisateur est reconnu via le cookie  

::: details ℹ️ Aide 
```php
if (!empty($_POST['remember'])) {
    setcookie("remember_user", $_POST['login'], time() + 7 * 24 * 60 * 60);
}
```
:::

