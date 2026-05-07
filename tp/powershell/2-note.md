---
outline: deep
search: false
---

# TP Noté — Administration système avec PowerShell

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Durée : 1 heure" />  <Badge type="danger" text="Documents non autorisés" />

::: danger Consignes générales
- Durée : **1 heure**
- **Documents et Internet non autorisés** — la commande `Get-Help` est autorisée
- **Nommez vos fichiers exactement** comme indiqué : `ex1.ps1`, `ex2.ps1`, `ex3.ps1`
- Les blocs de code marqués **— NE PAS MODIFIER —** doivent être copiés tels quels en début de chaque script : la correction est automatisée et repose sur ces valeurs exactes
- Placez vos 3 scripts dans un dossier nommé `NOM-Prénom` et déposez-le sur Moodle avant la fin de l'heure
:::

::: info Contexte
Vous êtes technicien informatique chez **TechServices**. Votre responsable vous confie trois scripts à écrire pour automatiser des tâches d'administration courantes sur le parc Windows.
:::

---

## Exercice 1 — Fiche serveur `4 points`

Créez le script `ex1.ps1`.

**— NE PAS MODIFIER —**
```powershell
$serveur           = "SRV-TECH-01"
$ip                = "192.168.1.10"
$os                = "Windows Server 2022"
$anneeInstallation = 2020
$dureeGarantie     = 5
```

Votre script doit ensuite :

1. Calculer et stocker dans `$anneeFinGarantie` l'année de fin de garantie *(année d'installation + durée de garantie)*
2. Afficher dans la **console** une fiche formatée contenant toutes ces informations, dont l'année de fin de garantie calculée

**Exemple de résultat :**

```
=== Fiche serveur ===
Nom      : SRV-TECH-01
IP       : 192.168.1.10
OS       : Windows Server 2022
Installé : 2020
Garantie : jusqu'en 2025
```

---

## Exercice 2 — Diagnostic d'espace disque `6 points`

Créez le script `ex2.ps1`.

**— NE PAS MODIFIER —**
```powershell
$espaceLibre = 8
```

Votre script doit afficher un message selon la valeur de `$espaceLibre` :

| Condition | Message à afficher | Couleur |
|---|---|---|
| Moins de 10 Go | `CRITIQUE — Espace insuffisant (X Go restants)` | Rouge |
| Entre 10 et 30 Go | `ATTENTION — Espace limité (X Go restants)` | Jaune |
| Plus de 30 Go | `OK — Espace suffisant (X Go restants)` | Vert |

*Avec la valeur `8`, votre script doit afficher le message CRITIQUE.*

::: warning Attention
Les messages à afficher doivent être **exactement** ceux indiqués dans le tableau ci-dessus.
:::

---

## Exercice 3 — Création d'arborescence `10 points`

Créez le script `ex3.ps1`.

**— NE PAS MODIFIER —**
```powershell
$dossierBase = "$env:USERPROFILE\Documents\TP-Note\Inventaire"
$machines    = @("PC-RH-01", "PC-COMPTA-01", "SRV-FICHIERS", "PC-DIR-01", "LAPTOP-TECH-01")
```

Votre script doit :

1. Créer le dossier `Documents\TP-Note\Inventaire` s'il n'existe pas déjà
2. Pour chaque machine du tableau :
   - Créer un sous-dossier portant le nom de la machine
   - Créer un fichier `log.txt` dans ce sous-dossier contenant la ligne `Inventaire de [machine] — [date du jour]`
   - Afficher `[OK] Dossier créé pour [machine]`

**Exemple de résultat :**

```
[OK] Dossier créé pour PC-RH-01
[OK] Dossier créé pour PC-COMPTA-01
[OK] Dossier créé pour SRV-FICHIERS
[OK] Dossier créé pour PC-DIR-01
[OK] Dossier créé pour LAPTOP-TECH-01
```

---

::: danger Rendu
Placez vos 3 scripts (`ex1.ps1`, `ex2.ps1`, `ex3.ps1`) dans un dossier nommé `NOM-Prénom` et déposez-le sur Moodle avant la fin de l'heure.  
Tout script absent ou mal nommé sera compté **zéro**.
:::
