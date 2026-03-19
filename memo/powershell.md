# PowerShell

PowerShell est un terminal **et** un langage de script développé par Microsoft, conçu pour automatiser l'administration Windows. Les commandes s'appellent des **cmdlets** et suivent toujours la convention `Verbe-Nom`.

## Variables

Les variables commencent toujours par `$`. Le type est dynamique, mais peut être forcé.

```powershell
$nom   = "Alice"
$age   = 21
$actif = $true

# Typage forcé
[int]$nb = "42"       # cast automatique → 42
[string]$s = 123      # → "123"

# Connaître le type
$nom.GetType().Name   # String
```

### Interpolation de chaînes

```powershell
$prenom = "Bob"
Write-Host "Bonjour $prenom !"         # → Bonjour Bob !
Write-Host 'Bonjour $prenom !'         # → Bonjour $prenom ! (pas d'interpolation)
Write-Host "Résultat : $(2 + 2)"       # → Résultat : 4
```

## Types courants

| Type PowerShell | Exemple | Équivalent Python |
|---|---|---|
| `[string]` | `"Bonjour"` | `str` |
| `[int]` | `42` | `int` |
| `[double]` | `3.14` | `float` |
| `[bool]` | `$true` / `$false` | `True` / `False` |
| `[datetime]` | `Get-Date` | `datetime` |
| `[array]` | `@(1, 2, 3)` | `list` |
| `[hashtable]` | `@{clé="val"}` | `dict` |

Valeur nulle : `$null`

## Tableaux

```powershell
$fruits = @("pomme", "poire", "kiwi")

$fruits[0]       # pomme
$fruits[-1]      # kiwi (dernier élément)
$fruits.Count    # 3
$fruits += "banane"   # ajouter un élément
```

## Hashtables

```powershell
$user = @{
    Nom   = "Alice"
    Age   = 21
    Admin = $true
}

$user["Nom"]   # Alice
$user.Nom      # Alice (notation point)
$user["Email"] = "alice@bts.fr"   # ajouter une clé
$user.Keys     # lister les clés
```

## Opérateurs de comparaison

| PowerShell | Signification |
|---|---|
| `-eq` | Égal |
| `-ne` | Différent |
| `-lt` | Inférieur |
| `-le` | Inférieur ou égal |
| `-gt` | Supérieur |
| `-ge` | Supérieur ou égal |
| `-and` / `-or` / `-not` | Logique |
| `-like "*.txt"` | Wildcard (joker) |
| `%` | Modulo (reste de la division) |

::: warning Attention
PowerShell n'utilise pas `==` ou `<` pour les comparaisons.
:::

## Conditions

```powershell
$age = 17

if ($age -ge 18) {
    Write-Host "Majeur"
} elseif ($age -ge 16) {
    Write-Host "Presque majeur"
} else {
    Write-Host "Mineur"
}
```

## Boucles

### for

```powershell
for ($i = 0; $i -lt 5; $i++) {
    Write-Host "Itération $i"
}
```

### while

```powershell
$compteur = 0
while ($compteur -lt 3) {
    Write-Host "Compteur : $compteur"
    $compteur++
}
```

### foreach

```powershell
$serveurs = @("SRV01", "SRV02", "SRV03")

foreach ($srv in $serveurs) {
    Write-Host "Traitement de $srv"
}
```

## Navigation & fichiers

| Cmdlet | Rôle |
|---|---|
| `Get-Location` | Afficher le dossier courant |
| `Set-Location C:\dossier` | Changer de dossier |
| `Get-ChildItem` | Lister le contenu d'un dossier |
| `Get-ChildItem -Filter "*.exe"` | Filtrer par extension |
| `New-Item -Path "..." -ItemType Directory` | Créer un dossier |
| `New-Item -Path "..." -ItemType File` | Créer un fichier |
| `Remove-Item "..."` | Supprimer |
| `Copy-Item` | Copier |
| `Move-Item` | Déplacer |
| `Test-Path "..."` | Vérifier si un chemin existe |
| `Get-Content "..."` | Lire un fichier |
| `"texte" \| Out-File "..."` | Écrire dans un fichier |
| `Add-Content -Path "..." -Value "..."` | Ajouter à la fin d'un fichier |

## Système

| Cmdlet | Rôle |
|---|---|
| `Get-Process` | Lister les processus |
| `Get-Service` | Lister les services |
| `Get-Service -Name "Spooler"` | État d'un service |
| `Write-Host "texte" -ForegroundColor Green` | Afficher en couleur |
| `$env:COMPUTERNAME` | Nom de la machine |
| `Get-Date` | Date et heure actuelles |
| `(Get-Date).Year` | Année en cours |
| `Get-PSDrive -PSProvider FileSystem` | Lister les disques locaux |

## Aide intégrée

```powershell
Get-Help Get-Process            # aide sur une cmdlet
Get-Help Get-Process -Examples  # exemples concrets
Get-Command -Verb Get           # toutes les cmdlets Get-
Get-Command -Name "*service*"   # chercher par mot-clé
```
