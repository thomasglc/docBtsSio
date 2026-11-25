---
outline: deep
---

# TP 2 - La chasse aux bugs

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Visual Studio 2022 · C# · xUnit" />

::: info Contexte
Le stagiaire a codé un **évaluateur de force** : il note chaque mot de passe « Faible », « Moyen » ou « Fort ». Il a testé « quelques mots de passe à la main » et tout lui semble correct. Il reste pourtant **4 bugs** dans son code : trouvez-les avec vos tests.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre solution `Authentification` du TP 1. Collez vos **captures d'écran** dans le **document de restitution** au fil de la séance, puis déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp2-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Classes d'équivalence** | Un seul cas par famille de valeurs qui se comportent pareil |
| **Valeurs limites** | Tester juste avant, pile sur et juste après chaque seuil |
| **`[Theory]` et `[InlineData]`** | Un seul test, lancé avec plusieurs jeux de données |
| **`Assert.Throws`** | Vérifier qu'une exception est bien levée |

---

## La règle à vérifier

Chaque critère rapporte **1 point** :

| Critère | Points |
|---|---|
| 12 caractères ou plus | +1 |
| Au moins un chiffre | +1 |
| Au moins une majuscule (de A à Z) | +1 |
| Au moins une minuscule (de a à z) | +1 |
| Au moins un caractère spécial (ni lettre, ni chiffre) | +1 |

Le score donne la force :

| Score | Force |
|---|---|
| 0 à 2 | Faible |
| 3 ou 4 | Moyen |
| 5 | Fort |

Deux cas particuliers :
- moins de **8** caractères : toujours **Faible** ;
- mot de passe `null` : les deux méthodes lèvent une **`ArgumentNullException`**.

---

## Mission 1 - Deux nouveaux outils

### Tâche 1.1 - Le code du stagiaire

Dans le projet `Securite`, ajoutez une classe `EvaluateurForce.cs` (clic droit sur le projet > **Ajouter** > **Classe**), puis remplacez tout son contenu par :

```csharp
namespace Securite
{
    public static class EvaluateurForce
    {
        public static int CalculerScore(string? motDePasse)
        {
            int score = 0;
            if (motDePasse.Length >= 12)
            {
                score++;
            }

            bool chiffre = false;
            bool majuscule = false;
            bool minuscule = false;
            bool special = false;
            foreach (char c in motDePasse)
            {
                if (c >= '0' && c <= '9')
                {
                    chiffre = true;
                }
                if (c >= 'A' && c < 'Z')
                {
                    majuscule = true;
                }
                if (c >= 'a' && c <= 'z')
                {
                    minuscule = true;
                }
                if (!char.IsLetterOrDigit(c))
                {
                    special = true;
                }
            }

            if (chiffre)
            {
                score++;
            }
            if (majuscule)
            {
                score++;
            }
            if (minuscule)
            {
                score++;
            }
            if (special)
            {
                score++;
            }
            return score;
        }

        public static string Evaluer(string? motDePasse)
        {
            if (motDePasse.Length <= 8)
            {
                return "Faible";
            }

            int score = CalculerScore(motDePasse);
            if (score <= 2)
            {
                return "Faible";
            }
            if (score < 4)
            {
                return "Moyen";
            }
            return "Fort";
        }
    }
}
```

`string?` : le point d'interrogation indique que le mot de passe **peut** valoir `null`.

### Tâche 1.2 - Un test, plusieurs données

Dans `Securite.Tests`, ajoutez une classe `EvaluateurForceTests.cs` :

```csharp
namespace Securite.Tests
{
    public class EvaluateurForceTests
    {
        [Theory]
        [InlineData("abc", 1)]
        [InlineData("abc1", 2)]
        [InlineData("Abc1", 3)]
        [InlineData("Abc1!", 4)]
        [InlineData("Abcdefgh123!", 5)]
        public void CalculerScore_RenvoieLeScoreAttendu(string motDePasse, int scoreAttendu)
        {
            int score = EvaluateurForce.CalculerScore(motDePasse);

            Assert.Equal(scoreAttendu, score);
        }
    }
}
```

`[Theory]` lance le test **une fois par ligne** `[InlineData]`. Les valeurs vont dans les paramètres, dans l'ordre.

Lancez les tests : l'Explorateur affiche **5 tests** en vert ✅, un par ligne.

### Tâche 1.3 - Tester une exception

Ajoutez ce test dans `EvaluateurForceTests` :

```csharp
[Fact]
public void Evaluer_Null_LeveArgumentNullException()
{
    Assert.Throws<ArgumentNullException>(() => EvaluateurForce.Evaluer(null));
}
```

`Assert.Throws` réussit seulement si le code entre parenthèses lève **cette** exception-là.

Lancez : le test est rouge ❌. **Premier bug trouvé !**

::: tip 📸 Capture 1
Le test rouge de la tâche 1.3 et son message d'erreur.
:::

Corrigez : ajoutez ces lignes **au début des deux méthodes** du stagiaire, puis relancez.

```csharp
if (motDePasse == null)
{
    throw new ArgumentNullException(nameof(motDePasse));
}
```

---

## Mission 2 - La chasse

::: info Les questions à se poser
- Quelles longueurs sont **juste avant**, **pile sur** et **juste après** chaque seuil ?
- Quelles lettres sont **au bord** de l'alphabet ?
- Quels scores font **changer** la force ?
:::

### Exercice 1 - Le score

Ajoutez des lignes `[InlineData]` au test de `CalculerScore` : les valeurs limites de la longueur, et une majuscule à chaque bout de l'alphabet.

### Exercice 2 - La force

Écrivez un second test paramétré pour `Evaluer`. Complétez-le avec vos propres lignes :

```csharp
[Theory]
[InlineData("Ab1!", "Faible")]
public void Evaluer_RenvoieLaForceAttendue(string motDePasse, string forceAttendue)
{
    // à compléter
}
```

### Exercice 3 - Corriger

Il reste **3 bugs**. Pour chaque test rouge : lisez le message, trouvez la ligne fautive du stagiaire, corrigez-la, relancez.

::: tip 📸 Captures 2, 3 et 4
- **Capture 2** : l'Explorateur de tests avec vos tests rouges, **avant** de corriger.
- **Capture 3** : votre fichier `EvaluateurForceTests.cs`.
- **Capture 4** : l'Explorateur de tests, tout en vert, **après** vos corrections.
:::

### Bonus - Exercice 4 - Le grand ménage

Au TP 1, vous avez écrit quatre tests pour `EstValide`. Remplacez-les par **un seul** test `[Theory]`.

### Bonus - Exercice 5 - La liste noire

`Azerty123456!` et `Motdepasse1!` obtiennent 5 points, mais ils sont dans tous les dictionnaires des pirates. `Evaluer` doit les classer **Faible**.

Écrivez d'abord le test (rouge), puis le code (vert).

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les **4 captures**.
:::
