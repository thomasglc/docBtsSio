# TP — Initiation à PowerShell

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="PowerShell ISE ou VS Code" />

Ce TP se déroule en 4 niveaux de difficulté croissante. Chaque exercice est indépendant. **Lisez bien les consignes avant de commencer à écrire.**


## Niveau 1 — Premiers pas

::: tip Niveau 1
Variables, affichage, types de base. Tout se tape directement dans la console.
:::

### Exercice 1 — Hello PowerShell

Ouvrez PowerShell ISE et tapez les commandes suivantes **une par une** dans la console (zone du bas).

1. Affichez le texte `Bonjour BTS SIO !` avec `Write-Host`
2. Affichez la date et l'heure actuelles avec `Get-Date`
3. Affichez uniquement l'année en cours

::: details Indice
Pour l'année, essayez `(Get-Date).Year`
:::

::: tip Résultat
La console affiche le texte, puis la date complète, puis l'année seule (ex: 2026)
:::

---

### Exercice 2 — Variables et calculs

Toujours dans la console, créez les variables suivantes :

1. Une variable `$prenom` contenant votre prénom
2. Une variable `$age` contenant votre âge
3. Affichez la phrase : `Je m'appelle [prénom] et j'ai [âge] ans.` en utilisant l'interpolation de chaîne
4. Créez une variable `$anneeNaissance` calculée automatiquement à partir de `$age` et de `(Get-Date).Year`
5. Affichez l'année de naissance

::: details Indice
`$anneeNaissance = (Get-Date).Year - $age`
:::

---

### Exercice 3 — Types de variables

Dans la console, testez le comportement des types :

1. Créez `$a = "10"` et `$b = 5`. Affichez `$a + $b`. Que se passe-t-il ?
2. Forcez le type : `[int]$a = "10"`, puis refaites `$a + $b`. Quelle différence ?
3. Vérifiez le type d'une variable avec `$a.GetType().Name`
4. Créez une variable `$actif = $true` et affichez son type

::: tip Résultat
Sans forçage, `"10" + 5` donne `105` (concaténation). Avec `[int]`, on obtient `15` (addition).
:::

---

## Niveau 2 — Fichiers et dossiers

::: info Niveau 2
Navigation dans l'arborescence, création et lecture de fichiers.
:::

### Exercice 4 — Navigation

Dans la console :

1. Affichez le dossier courant avec `Get-Location`
2. Allez dans `C:\Windows\System32`
3. Listez les fichiers avec `Get-ChildItem`
4. Listez uniquement les fichiers `.exe` en utilisant le paramètre `-Filter`
5. Revenez dans votre dossier de TP : `C:\TP-PowerShell`

::: details Indice
`Get-ChildItem -Filter "*.exe"`
:::

---

### Exercice 5 — Créer une arborescence — `ex5.ps1`

Créez un script `ex5.ps1` qui :

1. Crée le dossier `C:\TP-PowerShell\Projet`
2. À l'intérieur, crée trois sous-dossiers : `Documents`, `Images`, `Scripts`
3. Dans `Documents`, crée un fichier texte `notes.txt` contenant la ligne `Mes notes de cours`
4. Affiche un message de confirmation pour chaque création

::: details Indice
`New-Item -Path "C:\..." -ItemType Directory` pour un dossier, `-ItemType File` pour un fichier.
Pour écrire du texte dans un fichier : `"texte" | Out-File "chemin"`
:::

::: tip Résultat
L'arborescence est créée et la console affiche un message pour chaque étape.
:::

---

### Exercice 6 — Lire et écrire dans un fichier — `ex6.ps1`

Créez un script `ex6.ps1` qui :

1. Vérifie si le fichier `C:\TP-PowerShell\Projet\Documents\notes.txt` existe avec `Test-Path`
2. S'il existe : lit son contenu avec `Get-Content` et l'affiche
3. Ajoute la ligne `Ajout du [date du jour]` à la fin du fichier avec `Add-Content`
4. Relit le fichier pour vérifier que la ligne a bien été ajoutée

::: details Indice
`Add-Content -Path "..." -Value "texte"` — pour insérer la date : `"Ajout du $(Get-Date)"`
:::

---

## Niveau 3 — Conditions et boucles

::: warning Niveau 3
Écriture de scripts avec `if`, `for`, `foreach` et `while`.
:::

### Exercice 7 — Conditions — `ex7.ps1`

Créez un script `ex7.ps1` qui :

1. Déclare une variable `$note` avec une valeur entre 0 et 20
2. Affiche la mention correspondante selon ce barème :

| Note | Mention |
|------|---------|
| 16 et plus | Très bien |
| 14 à 15 | Bien |
| 12 à 13 | Assez bien |
| 10 à 11 | Passable |
| Moins de 10 | Insuffisant |

3. Testez votre script avec plusieurs valeurs de `$note`

::: warning Bonus
Ajoutez une vérification que la note est bien entre 0 et 20, sinon affichez `Note invalide`
:::

---

### Exercice 8 — Boucle for — `ex8.ps1`

Créez un script `ex8.ps1` qui :

1. Affiche les nombres de 1 à 20, un par ligne
2. Pour chaque nombre, affiche `[nombre] - pair` ou `[nombre] - impair` selon le cas

::: details Indice
L'opérateur modulo en PowerShell est `%`. Un nombre est pair si `$i % 2 -eq 0`
:::

::: tip Résultat
```
1 - impair
2 - pair
3 - impair
…
```
:::

---

### Exercice 9 — Boucle foreach — `ex9.ps1`

Créez un script `ex9.ps1` qui :

1. Déclare un tableau de 5 prénoms :
```powershell
$eleves = @("Alice", "Bob", "Charlie", "Diana", "Evan")
```
2. Pour chaque élève, crée un dossier `C:\TP-PowerShell\Eleves\[prénom]`
3. Dans chaque dossier, crée un fichier `info.txt` contenant `Dossier de [prénom]`
4. Affiche un message de confirmation pour chaque élève traité

::: details Indice
Pensez à créer d'abord le dossier parent `C:\TP-PowerShell\Eleves` avant la boucle.
:::

::: tip Résultat
5 dossiers créés, chacun contenant un fichier `info.txt` personnalisé.
:::

---

### Exercice 10 — Boucle while — `ex10.ps1`

Créez un script `ex10.ps1` qui simule un compte à rebours :

1. Déclare une variable `$compteur = 10`
2. Tant que `$compteur` est supérieur à 0, affiche la valeur et la décrémente
3. Quand la boucle se termine, affiche `Décollage !`

::: warning Bonus
Ajoutez `Start-Sleep -Seconds 1` dans la boucle pour que le compte à rebours s'affiche seconde par seconde.
:::

---

## Niveau 4 — Mise en situation

::: danger Niveau 4
Scripts plus complets combinant plusieurs notions.
:::

### Exercice 11 — Générateur de rapport — `ex11.ps1`

Créez un script `ex11.ps1` qui génère un fichier de rapport système :

1. Déclare une variable `$rapport = "C:\TP-PowerShell\rapport.txt"`
2. Écrit dans ce fichier (avec `Out-File`) un en-tête contenant la date du jour et le nom de la machine (`$env:COMPUTERNAME`)
3. Ajoute la liste des disques locaux : utilisez `Get-PSDrive -PSProvider FileSystem` et une boucle `foreach` pour écrire chaque disque dans le fichier avec `Add-Content`
4. Ajoute la liste des 5 premiers processus en cours d'exécution : utilisez `Get-Process`, stockez le résultat dans une variable `$processus`, puis bouclez dessus pour écrire chaque nom dans le fichier
5. Affiche `Rapport généré : C:\TP-PowerShell\rapport.txt`

::: details Indice
`$processus = Get-Process` stocke tous les processus dans un tableau. Vous pouvez ensuite faire `foreach ($p in $processus) { ... }`. Pour les 5 premiers : `for ($i = 0; $i -lt 5; $i++) { $processus[$i].Name }`
:::

::: tip Résultat
Un fichier `rapport.txt` lisible contenant la date, la machine, les disques et 5 processus.
:::

---

### Exercice 12 — Vérificateur de services — `ex12.ps1`

Créez un script `ex12.ps1` qui vérifie l'état de plusieurs services Windows :

1. Déclare un tableau avec les services à surveiller :
```powershell
$services = @("Spooler", "wuauserv", "WinDefend")
```
2. Pour chaque service, récupère son état avec `Get-Service -Name $s` et stocke le résultat dans une variable
3. Si le service est `Running`, affiche en vert : `[OK] NomService est démarré`
4. Sinon, affiche en rouge : `[ARRET] NomService est arrêté`

::: details Indice
`Write-Host "texte" -ForegroundColor Green` pour afficher en couleur. La propriété à comparer : `$svc.Status -eq "Running"`
:::

::: warning Bonus
Comptez et affichez à la fin le nombre de services démarrés sur le total. Ex : `2/3 services actifs`
:::

---

### Exercice 13 — Moniteur d'espace disque — `ex13.ps1`

Créez un script `ex13.ps1` qui analyse l'espace disque de chaque lecteur local :

1. Récupérez tous les lecteurs locaux avec `Get-PSDrive -PSProvider FileSystem` et stockez-les dans `$lecteurs`
2. Pour chaque lecteur, calculez :
   - L'espace total : `$l.Used + $l.Free`
   - Le pourcentage utilisé : `[math]::Round($l.Used / ($l.Used + $l.Free) * 100, 1)`
3. Affichez une ligne par lecteur avec le format : `[C:] 45.2% utilisé (22 Go libres sur 50 Go)`
4. Colorez la ligne selon le taux d'utilisation :
   - **Rouge** si le taux dépasse 80 %
   - **Jaune** si le taux est entre 50 % et 80 %
   - **Vert** sinon

::: details Indice
`$l.Free` et `$l.Used` sont en octets. Pour convertir en Go : `[math]::Round($l.Free / 1GB, 1)`.  
Ignorez les lecteurs dont `$l.Used + $l.Free -eq 0` (lecteurs réseau ou sans taille connue).
:::

::: tip Résultat
```
[C:] 62.3% utilisé (37.8 Go libres sur 100 Go)
[D:] 12.0% utilisé (88.0 Go libres sur 100 Go)
```
La ligne du lecteur C: s'affiche en jaune (entre 50 et 80 %), la ligne D: en vert.
:::

---

::: info Aide
En cas de blocage sur une commande : `Get-Help NomCmdlet -Examples`
:::
