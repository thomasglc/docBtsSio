---
outline: deep
---

# TP 4 - Le TDD en binôme

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Visual Studio 2022 · C# · xUnit" />

::: info Contexte
Nouvelle règle de sécurité : un utilisateur ne peut pas reprendre **l'un de ses 3 derniers mots de passe**. Cette fois, pas de code du stagiaire : vous écrivez la classe vous-même, en **TDD**. Le test d'abord, le code ensuite.
:::

::: warning Modalités
Ce TP se déroule **en binôme, sur un seul poste**, dans la solution `Authentification` de l'un des deux. À la fin, copiez les deux fichiers créés dans le projet de l'autre. Chacun dépose **son** document de restitution sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp4-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Rouge** ❌ | Écrire un test qui échoue, pour **un seul** comportement |
| **Vert** ✅ | Écrire le code **le plus simple** qui le fait passer |
| **Refactor** 🔧 | Améliorer le code, sans casser aucun test |
| **Ping-pong** | L'un écrit le test, l'autre le code, puis on échange |

---

## Mission 1 - Un premier tour, ensemble

### Tâche 1.1 - Rouge

Dans `Securite.Tests`, ajoutez une classe `HistoriqueMotsDePasseTests.cs` :

```csharp
namespace Securite.Tests
{
    public class HistoriqueMotsDePasseTests
    {
        [Fact]
        public void HistoriqueNeuf_EstDejaUtilise_RenvoieFaux()
        {
            HistoriqueMotsDePasse historique = new HistoriqueMotsDePasse();

            bool resultat = historique.EstDejaUtilise("Securite2026");

            Assert.False(resultat);
        }
    }
}
```

Visual Studio souligne `HistoriqueMotsDePasse` en rouge : la classe n'existe pas encore. **Une erreur de compilation compte comme un test rouge.**

::: tip 📸 Capture 1
Ce premier test, avec l'erreur affichée par Visual Studio.
:::

### Tâche 1.2 - Vert

Dans `Securite`, créez la classe, avec le code **le plus simple** possible :

```csharp
namespace Securite
{
    public class HistoriqueMotsDePasse
    {
        public bool EstDejaUtilise(string motDePasse)
        {
            return false;
        }
    }
}
```

Lancez les tests : vert ✅. Oui, `return false;` est une triche : c'est voulu. Le **prochain** test l'obligera à écrire le vrai code.

### Tâche 1.3 - Le tour suivant

Ajoutez ce test, lancez-le (rouge ❌), puis complétez la classe pour le faire passer (vert ✅) :

```csharp
[Fact]
public void Ajouter_PuisMemeMotDePasse_EstDejaUtilise()
{
    HistoriqueMotsDePasse historique = new HistoriqueMotsDePasse();
    historique.Ajouter("Securite2026");

    bool resultat = historique.EstDejaUtilise("Securite2026");

    Assert.True(resultat);
}
```

::: tip Le plus simple possible
Un champ `bool`, mis à `true` dans `Ajouter`, suffit à faire passer ce test. Le test suivant vous obligera à faire mieux.
:::

---

## Mission 2 - La suite, en ping-pong

::: info Les règles du ping-pong
1. **A** écrit le test du comportement suivant. Il doit être rouge.
2. **B** écrit le code le plus simple pour le faire passer.
3. Tous les deux : on améliore le code si besoin, les tests restent verts.
4. On échange les rôles pour le comportement suivant.

Un test est vert dès le départ ? Le comportement existe déjà : gardez le test, il le protège.
:::

| # | Comportement attendu |
|---|---|
| 3 | Après `Ajouter("Securite2026")`, `"Printemps2027"` n'est **pas** déjà utilisé |
| 4 | Après 4 ajouts, le 1er est **oublié** et le 4e est **retenu** |
| 5 | La casse compte : `"securite2026"` n'est pas `"Securite2026"` |

Un comportement à la fois, dans l'ordre. Ne codez **jamais** plus que ce que le test demande.

::: tip Astuce
Une `List<string>` garde les mots de passe : `Add` pour ajouter, `Contains` pour chercher, `Count` pour compter, `RemoveAt(0)` pour retirer le plus ancien.
:::

::: tip 📸 Captures 2 et 3
- **Capture 2** : votre classe `HistoriqueMotsDePasse` terminée.
- **Capture 3** : l'Explorateur de tests, tout en vert.
:::

### Bonus 1 - Pas de doublon

`Ajouter` refuse un mot de passe déjà présent dans l'historique : il lève une `InvalidOperationException`. Le test d'abord !

### Bonus 2 - Une taille réglable

`new HistoriqueMotsDePasse(5)` retient les **5** derniers mots de passe. `new HistoriqueMotsDePasse()` en retient toujours 3, et tous vos anciens tests restent verts.

---

## Rendu

::: danger Rendu sur Moodle
Chacun dépose **son document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les **3 captures**.
:::
