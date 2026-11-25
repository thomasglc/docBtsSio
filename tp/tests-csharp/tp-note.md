---
outline: deep
---

# TP noté - Le code de vérification

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Évaluation · 1h" />

::: info Contexte
Le stagiaire a codé la **vérification en deux étapes** : après son mot de passe, l'utilisateur saisit un code de 6 chiffres reçu par SMS. Votre mission : écrire les **tests** de sa classe à partir de la règle, et dresser la liste des **bugs** que vos tests révèlent. Vous ne corrigez pas son code.
:::

::: warning Modalités
- Travail **individuel**, durée **1h** (démarrage du poste et dépôt compris), dans votre solution `Authentification`.
- Collez dans le document de restitution les **captures** demandées, puis remplissez le **tableau des bugs**.
- Déposez le document au format **PDF** sur Moodle avant la fin de l'épreuve. Une partie absente du document ne peut pas être notée.

📥 <a href="/tp-note-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Barème

| Partie | Ce qui est évalué | Points |
|---|---|---|
| 1 - Le code | Les tests du constructeur | 4 |
| 2 - La saisie | Bon code, mauvais code, essais consommés | 4 |
| 3 - La durée | Les valeurs limites autour de 5 minutes, avec `[Theory]` | 4 |
| 4 - Les essais | Le comportement après 2 et après 3 erreurs | 3 |
| 5 - Les bugs | Chaque bug trouvé et décrit | 4 |
| Qualité | Noms de tests explicites, Arrange / Act / Assert | 1 |
| **Total** | | **20** |

::: tip Conseils
- Lisez **toute** la règle avant d'écrire le premier test.
- Un test rouge n'est pas une erreur de votre part : c'est peut-être un bug du stagiaire. Vérifiez d'abord votre valeur attendue dans la règle.
- Gardez **5 minutes** à la fin pour l'export PDF et le dépôt.
:::

---

## Le code du stagiaire

Dans le projet `Securite`, ajoutez la classe `CodeVerification.cs` :

```csharp
namespace Securite
{
    public class CodeVerification
    {
        public const int DureeValiditeMinutes = 5;
        public const int EssaisMax = 3;

        private string code;
        private DateTime creeLe;

        public int EssaisRestants { get; private set; }

        public CodeVerification(string code, DateTime creeLe)
        {
            if (code.Length != 6)
            {
                throw new ArgumentException("Le code doit contenir 6 chiffres.");
            }
            this.code = code;
            this.creeLe = creeLe;
            EssaisRestants = EssaisMax;
        }

        public bool Verifier(string saisie, DateTime maintenant)
        {
            if (maintenant >= creeLe.AddMinutes(DureeValiditeMinutes))
            {
                return false;
            }
            if (EssaisRestants < 0)
            {
                return false;
            }
            EssaisRestants--;
            return saisie == code;
        }
    }
}
```

## La règle

| # | Règle |
|---|---|
| R1 | Le code contient **exactement 6 chiffres**. Sinon, le constructeur lève une `ArgumentException`. |
| R2 | À la création, `EssaisRestants` vaut **3**. |
| R3 | `Verifier` renvoie `true` si la saisie est égale au code. |
| R4 | Une **mauvaise** saisie consomme un essai. Une **bonne** saisie n'en consomme pas. |
| R5 | Le code est valable **5 minutes** après sa création, **5 minutes pile comprises**. Après, `Verifier` renvoie `false`. |
| R6 | Après **3** mauvaises saisies, `Verifier` renvoie `false`, même avec le bon code. |

::: info La date dans les tests
`Verifier` reçoit l'heure en paramètre : c'est le test qui la choisit. Par exemple, avec `DateTime creeLe = new DateTime(2026, 12, 14, 10, 0, 0);`, une saisie 4 min 59 s plus tard se teste avec `creeLe.AddSeconds(299)`.
:::

---

## Partie 1 - Le code <Badge type="tip" text="4 points" />

Créez une classe `CodeVerificationTests.cs` dans `Securite.Tests`. Testez les règles **R1** et **R2** : un code correct, puis des codes incorrects de toutes sortes.

## Partie 2 - La saisie <Badge type="tip" text="4 points" />

Testez les règles **R3** et **R4**.

## Partie 3 - La durée <Badge type="tip" text="4 points" />

Testez la règle **R5** avec un seul test `[Theory]`, autour de la limite des 5 minutes.

## Partie 4 - Les essais <Badge type="tip" text="3 points" />

Testez la règle **R6**. Testez aussi le cas où l'utilisateur se trompe **2 fois** puis saisit le bon code.

## Partie 5 - Les bugs <Badge type="tip" text="4 points" />

Lancez tous vos tests. Dans le **tableau des bugs** du document de restitution, notez pour chaque test rouge :
- le **nom** du test ;
- la **règle** non respectée (R1 à R6) ;
- en une phrase, ce que fait le code du stagiaire **à tort**.

::: tip 📸 Captures
- **Capture 1** : votre fichier `CodeVerificationTests.cs` (en plusieurs captures s'il est long).
- **Capture 2** : l'Explorateur de tests, avec les tests verts et rouges.
:::

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de l'épreuve. Il doit contenir les **captures** et le **tableau des bugs**.
:::
