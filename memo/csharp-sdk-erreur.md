---
outline: deep
---

# Erreur — SDK .NET introuvable dans Visual Studio

<Badge type="danger" text="Erreur MSBuild" />  <Badge type="info" text="Visual Studio 2022" />  <Badge type="warning" text="Windows" />

::: danger Message d'erreur
```
Le SDK 'Microsoft.NET.Sdk' spécifié est introuvable.
Vérifiez que le SDK est installé et que global.json ne pointe pas vers une version manquante.
```
:::

Ce message apparaît au moment de créer ou d'ouvrir un projet C#. Visual Studio n'arrive pas à localiser le SDK .NET — l'outil qui compile votre code.

---

## Correction — Supprimer l'entrée x86 du PATH

Windows dispose souvent de **deux installations de .NET** :
- `C:\Program Files\dotnet\` — version **x64**, contient le SDK complet ✅
- `C:\Program Files (x86)\dotnet\` — version **x86**, contient seulement le runtime ❌

Si le dossier `(x86)` apparaît **en premier** dans le PATH, MSBuild trouve le mauvais `dotnet.exe` et ne trouve pas le SDK.

### Procédure de correction

**1.** Appuyez sur `Win + S`, tapez **« Variables d'environnement »** et ouvrez **« Modifier les variables d'environnement système »**.

**2.** Cliquez sur **« Variables d'environnement… »** en bas de la fenêtre.

**3.** Dans la section **« Variables système »** (panneau du bas), sélectionnez la variable **`Path`** et cliquez sur **Modifier**.

**4.** Dans la liste, repérez l'entrée :
```
C:\Program Files (x86)\dotnet\
```

**5.** Sélectionnez-la et cliquez sur **Supprimer**.

::: warning Ne supprimez que l'entrée (x86)
L'entrée `C:\Program Files\dotnet\` (sans `(x86)`) doit rester — c'est celle qui contient le SDK.
:::

**6.** Cliquez sur **OK** dans toutes les fenêtres ouvertes.

**7.** **Redémarrez le PC** — c'est indispensable pour que Windows recharge le PATH modifié.

**8.** Une fois redémarré, rouvrez Visual Studio.

---

## Vérification après correction

Après correction, ouvrez à nouveau un terminal et exécutez :

```
dotnet --list-sdks
```

Vous devriez voir au moins une version listée, par exemple :

```
8.0.100 [C:\Program Files\dotnet\sdk]
```

Ouvrez ensuite votre projet dans Visual Studio — l'erreur ne doit plus apparaître.

