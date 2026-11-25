---
outline: deep
---

# TP 3 - Tester un objet et mesurer la couverture

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Visual Studio 2022 · C# · xUnit" />

::: info Contexte
Le stagiaire a codé la classe qui protège les comptes : après **5 mots de passe faux**, le compte se verrouille. Cette fois, ce n'est plus une simple fonction : c'est un **objet**, dont l'état change à chaque appel. Vos tests vont suivre cet état, puis un outil vous dira quelles lignes ils n'ont jamais exécutées.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre solution `Authentification`. Collez vos **captures d'écran** dans le **document de restitution** au fil de la séance, puis déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp3-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Tester un objet** | Créer l'objet, lui faire subir des actions, puis vérifier son état |
| **Plusieurs `Assert`** | Vérifier plusieurs propriétés d'un même état |
| **Couverture de code** | Voir les lignes que vos tests n'exécutent jamais |

---

## Mission 1 - Le compte utilisateur

### Tâche 1.1 - Le code du stagiaire

Dans `Securite`, ajoutez une classe `CompteUtilisateur.cs` :

```csharp
namespace Securite
{
    public class CompteUtilisateur
    {
        public const int TentativesMax = 5;

        private string motDePasse;

        public string Identifiant { get; }
        public int TentativesEchouees { get; private set; }
        public bool EstVerrouille { get; private set; }

        public CompteUtilisateur(string identifiant, string motDePasse)
        {
            if (!PolitiqueMotDePasse.EstValide(motDePasse))
            {
                throw new ArgumentException("Le mot de passe ne respecte pas la politique.");
            }
            Identifiant = identifiant;
            this.motDePasse = motDePasse;
        }

        public bool VerifierMotDePasse(string essai)
        {
            if (EstVerrouille)
            {
                return false;
            }
            if (essai == motDePasse)
            {
                return true;
            }
            TentativesEchouees++;
            if (TentativesEchouees >= TentativesMax)
            {
                EstVerrouille = true;
            }
            return false;
        }

        public void Deverrouiller()
        {
            EstVerrouille = false;
            TentativesEchouees = 0;
        }
    }
}
```

La règle :

| # | Situation | Comportement attendu |
|---|---|---|
| 1 | Compte neuf | 0 tentative échouée, pas verrouillé |
| 2 | Bon mot de passe | `VerifierMotDePasse` renvoie `true` |
| 3 | 4 mots de passe faux | Pas encore verrouillé, 4 tentatives échouées |
| 4 | Compte verrouillé | Tout est refusé, **même le bon** mot de passe |
| 5 | Bon mot de passe après des échecs | Le compteur repart à **zéro** |
| 6 | `Deverrouiller()` | Plus verrouillé, compteur à zéro |
| 7 | Création avec `"azerty"` | `ArgumentException` (politique du TP 1) |

### Tâche 1.2 - Un premier test d'état

Dans `Securite.Tests`, ajoutez une classe `CompteUtilisateurTests.cs` :

```csharp
namespace Securite.Tests
{
    public class CompteUtilisateurTests
    {
        [Fact]
        public void VerifierMotDePasse_5Echecs_VerrouilleLeCompte()
        {
            // Arrange
            CompteUtilisateur compte = new CompteUtilisateur("alice", "Securite2026");

            // Act : 5 essais ratés
            for (int i = 0; i < 5; i++)
            {
                compte.VerifierMotDePasse("mauvais");
            }

            // Assert
            Assert.True(compte.EstVerrouille);
        }
    }
}
```

Lancez les tests : vert ✅.

---

## Mission 2 - Exercices

::: info Conseils
- Un test par ligne de la règle. Chaque test crée **son propre** compte : les tests ne doivent jamais dépendre les uns des autres.
- Un test peut avoir plusieurs `Assert` s'ils vérifient le **même** état.
- Pour un nombre : `Assert.Equal(attendu, obtenu)`. Pour une exception : `Assert.Throws`, comme au TP 2.
:::

### Exercices 1 à 7 - La règle, ligne par ligne

Écrivez un test pour chaque ligne du tableau de la règle (la ligne 4 de la tâche 1.2 compte déjà).

Un de vos tests devient rouge ❌ : c'est un bug. Corrigez le code du stagiaire.

::: tip 📸 Captures 1 et 2
- **Capture 1** : le test rouge et son message, **avant** la correction.
- **Capture 2** : votre fichier `CompteUtilisateurTests.cs`.
:::

---

## Mission 3 - La couverture de code

### Tâche 3.1 - Installer l'outil

Dans Visual Studio 2022 : **Extensions** > **Gérer les extensions**, cherchez **Fine Code Coverage**, cliquez sur **Télécharger**, puis fermez Visual Studio : l'installation se lance. Rouvrez ensuite votre solution.

::: details Vous avez Visual Studio 2026 ?
La couverture est intégrée : **Test** > **Analyser la couverture du code pour tous les tests**. Passez directement à la tâche 3.2.
:::

### Tâche 3.2 - Mesurer

Relancez tous les tests, puis ouvrez **Affichage** > **Autres fenêtres** > **Fine Code Coverage**.

- Le rapport donne, pour chaque classe, le pourcentage de lignes couvertes (*Line coverage*).
- Une ligne **verte** a été exécutée par au moins un test. Une ligne **rouge** ne l'a jamais été.

![Rapport de couverture de CompteUtilisateur : toutes les lignes en vert, sauf celle de la propriété Identifiant, en rouge](/tp/tests-csharp/tp3-couverture.png)

### Tâche 3.3 - Viser 100 %

Ajoutez le test qui manque pour que `CompteUtilisateur` atteigne **100 %** de lignes couvertes.

::: tip 📸 Capture 3
La fenêtre de couverture, avec `CompteUtilisateur` à 100 %.
:::

::: warning 100 % ne veut pas dire zéro bug
Une ligne exécutée n'est pas forcément **vérifiée** par un `Assert`.
:::

::: details L'extension ne s'installe pas ? La couverture en ligne de commande
Ouvrez **Affichage** > **Terminal**, placez-vous dans le dossier de la solution, puis :

```bash
dotnet tool install -g dotnet-reportgenerator-globaltool
dotnet test --collect:"XPlat Code Coverage"
reportgenerator -reports:"**/coverage.cobertura.xml" -targetdir:"rapport" -reporttypes:Html
```

La première commande ne sert qu'une fois. Ouvrez ensuite `rapport\index.html` dans le navigateur. Avant chaque nouvelle mesure, supprimez le dossier `Securite.Tests\TestResults`.
:::

### Bonus - Exercice 8 - Tout le projet

Portez aussi `PolitiqueMotDePasse` et `EvaluateurForce` à 100 %.

### Bonus - Exercice 9 - Le test qui ne vérifie rien

Écrivez un test qui appelle `VerifierMotDePasse` sans aucun `Assert`. La couverture monte-t-elle ? Ce test peut-il trouver un bug ?

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les **3 captures**.
:::
