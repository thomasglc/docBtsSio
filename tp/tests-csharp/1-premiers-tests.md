---
outline: deep
---

# TP 1 - Premiers tests unitaires

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Visual Studio 2022 · C# · xUnit" />

::: info Contexte
L'API notes-app a maintenant une version Windows, écrite en C#. Un stagiaire a codé son **module d'authentification** : les règles des mots de passe. Il assure que tout fonctionne. Vous allez le vérifier avec des **tests automatiques**.
:::

::: warning Modalités
Ce TP se déroule **individuellement**. Collez vos **captures d'écran** dans le **document de restitution** au fil de la séance. Ce document est à déposer sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp1-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Projet de test** | Un projet à part, qui ne contient que les tests |
| **`[Fact]`** | L'attribut qui transforme une méthode en test |
| **Arrange / Act / Assert** | Les trois étapes d'un test : préparer, agir, vérifier |
| **Explorateur de tests** | La fenêtre qui lance les tests : vert ✅ ou rouge ❌ |

---

## Mission 1 - Mettre en place le projet

### Tâche 1.1 - Créer la solution

Dans Visual Studio, cliquez sur **Créer un projet** :

| Champ | Valeur |
|---|---|
| Modèle | **Bibliothèque de classes** (C#) |
| Nom du projet | `Securite` |
| Emplacement | Le dossier à votre nom sur le disque D |
| Nom de la solution | `Authentification` |
| Case | ❌ Placer la solution et le projet dans le même répertoire |
| Framework | .NET 8.0 |

Une bibliothèque de classes n'a pas de `Main` : elle contient du code que d'autres projets utilisent.

<!-- 📷 IMAGE REQUISE : fenêtre "Configurer votre nouveau projet" remplie -->

### Tâche 1.2 - Ajouter le projet de test

1. Clic droit sur la solution `Authentification` > **Ajouter** > **Nouveau projet**.
2. Choisissez le modèle **Projet de test xUnit** (C#), nommez-le `Securite.Tests`, framework .NET 8.0.
3. Clic droit sur `Securite.Tests` > **Ajouter** > **Référence de projet**, cochez `Securite`, puis **OK**.

Votre Explorateur de solutions doit ressembler à ceci :

```text
Solution 'Authentification' (2 projets)
├── Securite
│   └── Class1.cs
└── Securite.Tests
    └── UnitTest1.cs
```

::: info Pourquoi deux projets ?
Le code de l'application et ses tests sont séparés : on livre `Securite` aux utilisateurs, jamais les tests.
:::

### Tâche 1.3 - Le code du stagiaire

Renommez `Class1.cs` en `PolitiqueMotDePasse.cs` (clic droit > **Renommer**), puis remplacez tout son contenu par :

```csharp
namespace Securite
{
    public static class PolitiqueMotDePasse
    {
        public const int LongueurMinimale = 12;

        public static bool LongueurSuffisante(string motDePasse)
        {
            return motDePasse.Length > LongueurMinimale;
        }

        public static bool ContientChiffre(string motDePasse)
        {
            foreach (char c in motDePasse)
            {
                if (char.IsDigit(c))
                {
                    return true;
                }
            }
            return false;
        }

        public static bool ContientMajuscule(string motDePasse)
        {
            foreach (char c in motDePasse)
            {
                if (char.IsUpper(c))
                {
                    return true;
                }
            }
            return false;
        }

        public static bool EstValide(string motDePasse)
        {
            return LongueurSuffisante(motDePasse)
                && ContientChiffre(motDePasse)
                && ContientMajuscule(motDePasse);
        }
    }
}
```

La règle que le stagiaire devait coder :

| Règle | Méthode |
|---|---|
| Au moins **12** caractères | `LongueurSuffisante` |
| Au moins un chiffre | `ContientChiffre` |
| Au moins une majuscule | `ContientMajuscule` |
| Les trois règles à la fois | `EstValide` |

### Tâche 1.4 - Votre premier test

Renommez `UnitTest1.cs` en `PolitiqueMotDePasseTests.cs`, puis remplacez tout son contenu par :

```csharp
namespace Securite.Tests
{
    public class PolitiqueMotDePasseTests
    {
        [Fact]
        public void LongueurSuffisante_15Caracteres_RenvoieVrai()
        {
            // Arrange : préparer les données
            string motDePasse = "SoleilDuMatin15";

            // Act : appeler la méthode à tester
            bool resultat = PolitiqueMotDePasse.LongueurSuffisante(motDePasse);

            // Assert : vérifier le résultat
            Assert.True(resultat);
        }
    }
}
```

Ouvrez **Test** > **Explorateur de tests**, puis cliquez sur **Exécuter tous les tests**.

Résultat attendu : **1 test réussi** ✅.

<!-- 📷 IMAGE REQUISE : Explorateur de tests avec le premier test en vert -->

::: tip 📸 Capture 1
L'Explorateur de tests, avec votre premier test en vert.
:::

### Tâche 1.5 - Le test qui trouve un bug

Ajoutez ce second test, sous le premier :

```csharp
[Fact]
public void LongueurSuffisante_12Caracteres_RenvoieVrai()
{
    string motDePasse = "Securite2026";

    bool resultat = PolitiqueMotDePasse.LongueurSuffisante(motDePasse);

    Assert.True(resultat);
}
```

Lancez les tests : celui-ci est **rouge** ❌. Cliquez dessus et lisez le message en bas de l'Explorateur.

::: tip 📸 Capture 2
Le test rouge et son message d'erreur, avant toute correction.
:::

La règle dit « **au moins** 12 caractères ». Trouvez l'erreur du stagiaire dans `LongueurSuffisante`, corrigez-la, puis relancez : tout est vert.

::: info Un test rouge n'est pas un échec
C'est un bug trouvé **avant** l'utilisateur.
:::

---

## Mission 2 - Exercices

::: info Conseils
- Un test = une méthode `[Fact]`. Son nom dit ce qu'il vérifie : `Methode_Situation_ResultatAttendu`.
- Pour un résultat `false`, utilisez `Assert.False(...)`.
- Lancez les tests après chaque exercice.
:::

### Exercice 1 - Trop court

| Méthode | Mot de passe | Résultat attendu |
|---|---|---|
| `LongueurSuffisante` | `"Bonjour2026"` (11 caractères) | `false` |

### Exercice 2 - Les chiffres

| Méthode | Mot de passe | Résultat attendu |
|---|---|---|
| `ContientChiffre` | `"motdepasse"` | `false` |
| `ContientChiffre` | `"motdepasse7"` | `true` |

Un test par ligne du tableau.

### Exercice 3 - Les majuscules

| Méthode | Mot de passe | Résultat attendu |
|---|---|---|
| `ContientMajuscule` | `"motdepasse"` | `false` |
| `ContientMajuscule` | `"motDepasse"` | `true` |

### Exercice 4 - La règle complète

| Méthode | Mot de passe | Résultat attendu |
|---|---|---|
| `EstValide` | `"Securite2026"` | `true` |
| `EstValide` | `"securite2026"` | `false` |
| `EstValide` | `"SecuriteTotale"` | `false` |
| `EstValide` | `"Secu2026"` | `false` |

Résultat attendu : **11 tests réussis** ✅.

::: tip 📸 Captures 3 et 4
- **Capture 3** : votre fichier `PolitiqueMotDePasseTests.cs` (en deux captures s'il est long).
- **Capture 4** : l'Explorateur de tests, avec les 11 tests en vert.
:::

### Bonus - Exercice 5 - Les minuscules

Ajoutez à `PolitiqueMotDePasse` une méthode `ContientMinuscule`, sur le modèle de `ContientMajuscule`, puis écrivez ses deux tests.

::: tip Astuce
`char.IsLower(c)` renvoie `true` pour une lettre minuscule.
:::

### Bonus - Exercice 6 - Le saboteur

Échangez votre poste avec votre voisin. Modifiez **une seule ligne** de son fichier `PolitiqueMotDePasse.cs` (jamais les tests !), puis rendez-lui la main.

Ses tests trouvent-ils le sabotage ? Si aucun test ne devient rouge, il en manque un : écrivez-le.

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les **4 captures**.
:::
