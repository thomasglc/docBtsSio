<#
.SYNOPSIS
    Correcteur automatique - TP note PowerShell BTS SIO 1ere annee

.DESCRIPTION
    Execute les scripts d'un etudiant (ex1.ps1 a ex3.ps1) et calcule
    automatiquement une note sur 20 avec un rapport de correction detaille.
    Bareme : Ex1 = 4 pts | Ex2 = 6 pts | Ex3 = 10 pts

.PARAMETER DossierEleve
    Chemin vers le dossier contenant les scripts de l'etudiant.

.PARAMETER Eleve
    Nom de l'eleve (utilise dans le rapport). Optionnel, deduit du nom
    du dossier si non fourni.

.EXAMPLE
    # Corriger un seul eleve
    .\correcteur-ps.ps1 -DossierEleve "C:\Rendus\DUPONT-Marie"

.EXAMPLE
    # Corriger tous les sous-dossiers d'un dossier de rendus
    Get-ChildItem "C:\Rendus" -Directory | ForEach-Object {
        .\correcteur-ps.ps1 -DossierEleve $_.FullName -Eleve $_.Name
    }
#>

param(
    [Parameter(Mandatory)]
    [string]$DossierEleve,

    [string]$Eleve = ""
)

Set-StrictMode -Off
$ErrorActionPreference = "SilentlyContinue"

if ($Eleve -eq "") {
    $Eleve = (Split-Path $DossierEleve -Leaf)
}

# ---------------------------------------------------------------------------
# Fonctions utilitaires
# ---------------------------------------------------------------------------

function Invoke-ScriptWithCapture {
    param([string]$Path)

    if (-not (Test-Path $Path)) { return $null }

    $output = & powershell.exe -ExecutionPolicy Bypass -NonInteractive -File $Path 2>&1
    if ($null -eq $output) { return "" }
    return ($output | Out-String).Trim()
}

function Invoke-ScriptWithInjection {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Replacement
    )

    if (-not (Test-Path $Path)) { return $null }

    $content  = Get-Content $Path -Raw -Encoding UTF8
    $modified = $content -replace $Pattern, $Replacement
    $tempPath = Join-Path ([System.IO.Path]::GetTempPath()) ("corr_$([System.Guid]::NewGuid()).ps1")

    try {
        $modified | Set-Content $tempPath -Encoding UTF8
        return Invoke-ScriptWithCapture -Path $tempPath
    }
    finally {
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
    }
}

function Run-Script {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return }
    & powershell.exe -ExecutionPolicy Bypass -NonInteractive -File $Path 2>&1 | Out-Null
}

$script:rapport = [System.Collections.Generic.List[string]]::new()

function Write-Rapport {
    param([string]$Ligne, [string]$Couleur = "White")
    $script:rapport.Add($Ligne)
    Write-Host $Ligne -ForegroundColor $Couleur
}

function Test-Critere {
    param(
        [bool]$Ok,
        [string]$LabelOk,
        [string]$LabelKo,
        [int]$Points
    )
    if ($Ok) {
        Write-Rapport "  [OK] $LabelOk : +$Points" "Green"
        return $Points
    }
    else {
        Write-Rapport "  [KO] $LabelKo : +0" "Red"
        return 0
    }
}

# ---------------------------------------------------------------------------
# En-tete du rapport
# ---------------------------------------------------------------------------

$separateur = "=" * 54

Write-Rapport $separateur
Write-Rapport "  CORRECTION - $Eleve"
Write-Rapport "  Dossier : $DossierEleve"
Write-Rapport "  Date    : $(Get-Date -Format 'dd/MM/yyyy HH:mm')"
Write-Rapport $separateur
Write-Rapport ""

$totalPoints = 0

# ===========================================================================
# EXERCICE 1 - Fiche serveur (4 points | 4 x 1pt)
# ===========================================================================
Write-Rapport "[Exercice 1 - Fiche serveur /4]" "Cyan"
$ex1Score = 0
$ex1Path  = Join-Path $DossierEleve "ex1.ps1"

if (-not (Test-Path $ex1Path)) {
    Write-Rapport "  [KO] Fichier ex1.ps1 introuvable" "Red"
}
else {
    $out = Invoke-ScriptWithCapture -Path $ex1Path

    if ($null -eq $out -or $out -eq "") {
        Write-Rapport "  [!!] Aucune sortie (erreur d'execution ?)" "Yellow"
    }
    else {
        $ex1Score += Test-Critere ($out -match "SRV-TECH-01")        "Nom serveur affiche (SRV-TECH-01)"           "Nom serveur absent"                    1
        $ex1Score += Test-Critere ($out -match "192\.168\.1\.10")     "Adresse IP affichee (192.168.1.10)"          "Adresse IP absente"                    1
        $ex1Score += Test-Critere ($out -match "Windows Server 2022") "OS affiche (Windows Server 2022)"            "OS absent"                             1
        $ex1Score += Test-Critere ($out -match "2025")                "Fin de garantie calculee (2025)"             "Fin de garantie incorrecte ou absente"  1
    }
}

Write-Rapport "  Score : $ex1Score/4" "Cyan"
Write-Rapport ""
$totalPoints += $ex1Score

# ===========================================================================
# EXERCICE 2 - Diagnostic espace disque (6 points | 3 x 2pts)
# ===========================================================================
Write-Rapport "[Exercice 2 - Diagnostic espace disque /6]" "Cyan"
$ex2Score = 0
$ex2Path  = Join-Path $DossierEleve "ex2.ps1"

if (-not (Test-Path $ex2Path)) {
    Write-Rapport "  [KO] Fichier ex2.ps1 introuvable" "Red"
}
else {
    $out8 = Invoke-ScriptWithCapture -Path $ex2Path
    $ex2Score += Test-Critere ($out8 -match "(?i)critique")   "espaceLibre=8  -> CRITIQUE detecte"    "espaceLibre=8  -> CRITIQUE non trouve"   2

    $out25 = Invoke-ScriptWithInjection -Path $ex2Path `
        -Pattern     '\$espaceLibre\s*=\s*\d+' `
        -Replacement '$espaceLibre = 25'
    $ex2Score += Test-Critere ($out25 -match "(?i)attention")  "espaceLibre=25 -> ATTENTION detecte"   "espaceLibre=25 -> ATTENTION non trouve"  2

    $out60 = Invoke-ScriptWithInjection -Path $ex2Path `
        -Pattern     '\$espaceLibre\s*=\s*\d+' `
        -Replacement '$espaceLibre = 60'
    $ex2Score += Test-Critere ($out60 -match "(?i)\bOK\b")     "espaceLibre=60 -> OK detecte"          "espaceLibre=60 -> OK non trouve"         2
}

Write-Rapport "  Score : $ex2Score/6" "Cyan"
Write-Rapport ""
$totalPoints += $ex2Score

# ===========================================================================
# EXERCICE 3 - Creation d'arborescence (10 points | 5x1pt dossiers + 5x1pt fichiers)
# ===========================================================================
Write-Rapport "[Exercice 3 - Creation d'arborescence /10]" "Cyan"
$ex3Score       = 0
$ex3Path        = Join-Path $DossierEleve "ex3.ps1"
$machines       = @("PC-RH-01", "PC-COMPTA-01", "SRV-FICHIERS", "PC-DIR-01", "LAPTOP-TECH-01")
$inventairePath = "$env:USERPROFILE\Documents\TP-Note\Inventaire"

if (-not (Test-Path $ex3Path)) {
    Write-Rapport "  [KO] Fichier ex3.ps1 introuvable" "Red"
}
else {
    if (Test-Path $inventairePath) {
        Remove-Item $inventairePath -Recurse -Force -ErrorAction SilentlyContinue
    }

    Run-Script -Path $ex3Path

    # Dossiers : 1pt par dossier cree (5 pts max)
    $dossiersOk = 0
    foreach ($m in $machines) {
        if (Test-Path (Join-Path $inventairePath $m)) { $dossiersOk++ }
    }
    $couleurD = if ($dossiersOk -eq 5) { "Green" } else { "Yellow" }
    Write-Rapport ("  Dossiers crees      : {0}/5  ->  {0}/5 pts" -f $dossiersOk) $couleurD

    if ($dossiersOk -lt 5) {
        $manquants = $machines | Where-Object { -not (Test-Path (Join-Path $inventairePath $_)) }
        Write-Rapport "    Manquants : $($manquants -join ', ')" "Red"
    }

    # Fichiers log.txt : 1pt par fichier valide (5 pts max)
    $fichiersOk = 0
    foreach ($m in $machines) {
        $logPath = Join-Path $inventairePath "$m\log.txt"
        if (Test-Path $logPath) {
            $contenu = Get-Content $logPath -Raw -ErrorAction SilentlyContinue
            if ($null -ne $contenu -and $contenu -match [regex]::Escape($m)) {
                $fichiersOk++
            }
        }
    }
    $couleurF = if ($fichiersOk -eq 5) { "Green" } else { "Yellow" }
    Write-Rapport ("  Fichiers log.txt OK : {0}/5  ->  {0}/5 pts" -f $fichiersOk) $couleurF

    if ($fichiersOk -lt 5) {
        $manquants = $machines | Where-Object {
            $p = Join-Path $inventairePath "$_\log.txt"
            -not (Test-Path $p) -or -not ((Get-Content $p -Raw -ErrorAction SilentlyContinue) -match [regex]::Escape($_))
        }
        Write-Rapport "    Invalides ou manquants : $($manquants -join ', ')" "Red"
    }

    $ex3Score = $dossiersOk + $fichiersOk
}

Write-Rapport "  Score : $ex3Score/10" "Cyan"
Write-Rapport ""
$totalPoints += $ex3Score

# ===========================================================================
# NOTE FINALE
# ===========================================================================
Write-Rapport $separateur
$couleurNote = if ($totalPoints -ge 10) { "Green" } else { "Red" }
Write-Rapport ("  NOTE FINALE : {0} / 20" -f $totalPoints) $couleurNote
Write-Rapport $separateur

$nomFichier  = "note-$($Eleve -replace '[\\/:*?\"<>|]', '-').txt"
$fichierNote = Join-Path $DossierEleve $nomFichier
$script:rapport | Out-File $fichierNote -Encoding UTF8
Write-Host ""
Write-Host "Rapport sauvegarde : $fichierNote" -ForegroundColor Cyan
