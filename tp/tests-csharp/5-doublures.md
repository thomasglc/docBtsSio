---
outline: deep
---

# TP 5 - Les doublures de test

<Badge type="info" text="BTS SIO SLAM 2ème année" />  <Badge type="warning" text="Bloc 2 - Tests unitaires" />  <Badge type="danger" text="Visual Studio 2022 · C# · xUnit · Moq" />

::: info Contexte
Le stagiaire a codé le **service de connexion**. Il cherche le compte dans la **base de données**, note l'**heure** de chaque connexion et **alerte l'administrateur** quand un compte se verrouille. Impossible de tester ça tel quel : vous allez remplacer ces trois dépendances par des **doublures**.
:::

::: warning Modalités
Ce TP se déroule **individuellement**, dans votre solution `Authentification`. Collez vos **captures d'écran** dans le **document de restitution** au fil de la séance, puis déposez-le sur Moodle **avant la fin du TP**, au format **PDF**.

📥 <a href="/tp5-tests-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Ce que vous allez apprendre

| Concept | Description |
|---|---|
| **Interface** | Un contrat : la liste des méthodes qu'une classe s'engage à fournir |
| **Faux** | Une vraie implémentation, mais simplifiée : une liste au lieu d'une base |
| **Bouchon** | Une doublure qui renvoie une réponse fixée par le test |
| **Mock (Moq)** | Une doublure créée par une bibliothèque, qui vérifie les appels reçus |

Les trois dépendances du service, et leurs doublures :

| Dépendance | Dans l'application | Dans les tests | Doublure |
|---|---|---|---|
| `IDepotComptes` | La base de données | `DepotEnMemoire` : une liste | Faux |
| `IHorloge` | L'horloge de l'ordinateur | `HorlogeFixe` : une date choisie | Bouchon |
| `IAlerte` | Un e-mail à l'administrateur | `Mock<IAlerte>` | Mock |

---

## Mission 1 - Le service et ses doublures

### Tâche 1.1 - Les interfaces

Dans `Securite`, ajoutez trois interfaces (clic droit > **Ajouter** > **Nouvel élément** > **Interface**) :

```csharp
namespace Securite
{
    public interface IDepotComptes
    {
        CompteUtilisateur? Trouver(string identifiant);
    }
}
```

```csharp
namespace Securite
{
    public interface IHorloge
    {
        DateTime Maintenant { get; }
    }
}
```

```csharp
namespace Securite
{
    public interface IAlerte
    {
        void Envoyer(string message);
    }
}
```

Puis la vraie horloge, utilisée par l'application :

```csharp
namespace Securite
{
    public class HorlogeSysteme : IHorloge
    {
        public DateTime Maintenant
        {
            get { return DateTime.Now; }
        }
    }
}
```

### Tâche 1.2 - Le service du stagiaire

Dans `CompteUtilisateur`, ajoutez cette propriété sous `EstVerrouille` :

```csharp
public DateTime? DerniereConnexion { get; set; }
```

Puis ajoutez la classe `ServiceConnexion.cs` :

```csharp
namespace Securite
{
    public class ServiceConnexion
    {
        private IDepotComptes depot;
        private IHorloge horloge;
        private IAlerte alerte;

        public ServiceConnexion(IDepotComptes depot, IHorloge horloge, IAlerte alerte)
        {
            this.depot = depot;
            this.horloge = horloge;
            this.alerte = alerte;
        }

        public bool Connecter(string identifiant, string motDePasse)
        {
            CompteUtilisateur? compte = depot.Trouver(identifiant);
            if (compte == null)
            {
                return false;
            }

            if (compte.VerifierMotDePasse(motDePasse))
            {
                compte.DerniereConnexion = horloge.Maintenant;
                return true;
            }

            if (compte.EstVerrouille)
            {
                alerte.Envoyer("Compte " + identifiant + " verrouillé");
            }
            return false;
        }
    }
}
```

La règle :

| Situation | Comportement attendu |
|---|---|
| Identifiant inconnu | `Connecter` renvoie `false` |
| Bon mot de passe | `true`, et `DerniereConnexion` reçoit l'heure de l'horloge |
| 5e échec : le compte se verrouille | L'alerte `"Compte alice verrouillé"` part **une seule fois** |
| Connexion réussie | Aucune alerte |

### Tâche 1.3 - Installer Moq

Clic droit sur `Securite.Tests` > **Gérer les packages NuGet** > onglet **Parcourir**, cherchez **Moq**, puis **Installer**.

### Tâche 1.4 - Le faux dépôt

Dans `Securite.Tests`, créez un dossier `Doublures`, puis ajoutez-y la classe `DepotEnMemoire.cs` :

```csharp
namespace Securite.Tests
{
    public class DepotEnMemoire : IDepotComptes
    {
        private List<CompteUtilisateur> comptes = new List<CompteUtilisateur>();

        public void Ajouter(CompteUtilisateur compte)
        {
            comptes.Add(compte);
        }

        public CompteUtilisateur? Trouver(string identifiant)
        {
            foreach (CompteUtilisateur compte in comptes)
            {
                if (compte.Identifiant == identifiant)
                {
                    return compte;
                }
            }
            return null;
        }
    }
}
```

`: IDepotComptes` : la classe **s'engage** à fournir la méthode `Trouver`. Le service accepte donc ce faux dépôt à la place de la base.

### Tâche 1.5 - À vous : l'horloge fixe

Dans `Doublures`, écrivez la classe `HorlogeFixe`, qui implémente `IHorloge` :
- son constructeur reçoit une date ;
- `Maintenant` renvoie **toujours** cette date.

```csharp
namespace Securite.Tests
{
    public class HorlogeFixe : IHorloge
    {
        // à compléter
    }
}
```

::: tip Astuce
Cliquez sur `IHorloge`, puis sur l'ampoule 💡 > **Implémenter l'interface** : Visual Studio écrit le squelette.
:::

::: tip 📸 Capture 1
Votre classe `HorlogeFixe`.
:::

### Tâche 1.6 - Le premier test

Ajoutez une classe `ServiceConnexionTests.cs` à la racine de `Securite.Tests` :

```csharp
using Moq;

namespace Securite.Tests
{
    public class ServiceConnexionTests
    {
        [Fact]
        public void Connecter_IdentifiantInconnu_RenvoieFaux()
        {
            DepotEnMemoire depot = new DepotEnMemoire();
            HorlogeFixe horloge = new HorlogeFixe(new DateTime(2026, 12, 7, 9, 0, 0));
            Mock<IAlerte> alerte = new Mock<IAlerte>();
            ServiceConnexion service = new ServiceConnexion(depot, horloge, alerte.Object);

            bool resultat = service.Connecter("inconnu", "Securite2026");

            Assert.False(resultat);
        }
    }
}
```

`new Mock<IAlerte>()` crée une fausse alerte sans écrire de classe. `alerte.Object` est l'objet à donner au service.

Lancez : vert ✅.

---

## Mission 2 - Exercices

::: info Conseils
- Chaque test crée son dépôt, son horloge, son mock et son service.
- Pour ajouter un compte : `depot.Ajouter(new CompteUtilisateur("alice", "Securite2026"));`
- Vérifier un appel au mock : `alerte.Verify(a => a.Envoyer("Compte alice verrouillé"), Times.Once());`
- Vérifier qu'il n'y a **aucun** appel : `alerte.Verify(a => a.Envoyer(It.IsAny<string>()), Times.Never());`
:::

### Exercice 1 - La bonne porte

Avec le bon mot de passe, `Connecter` renvoie `true`.

### Exercice 2 - L'heure de connexion

Après une connexion réussie, `DerniereConnexion` du compte vaut **exactement** la date de votre `HorlogeFixe`.

### Exercice 3 - L'alerte

Après 5 échecs, l'alerte `"Compte alice verrouillé"` est envoyée **une fois**.

### Exercice 4 - Le silence

Une connexion réussie n'envoie **aucune** alerte.

### Exercice 5 - Le bug

Après **7** échecs, l'alerte n'est toujours partie **qu'une fois**. Votre test est rouge ❌ : corrigez le service.

::: tip Indice
L'alerte ne doit partir qu'au **moment** où le compte se verrouille : retenez `compte.EstVerrouille` **avant** d'appeler `VerifierMotDePasse`.
:::

::: tip 📸 Captures 2, 3 et 4
- **Capture 2** : le test de l'exercice 5, rouge, avec son message.
- **Capture 3** : votre fichier `ServiceConnexionTests.cs`.
- **Capture 4** : l'Explorateur de tests, tout en vert.
:::

### Bonus - Exercice 6 - L'espion

Sans Moq : écrivez une classe `AlerteEspionne` qui implémente `IAlerte` et range chaque message reçu dans une `List<string>`. Réécrivez l'exercice 3 avec elle.

### Bonus - Exercice 7 - Une horloge Moq

Remplacez `HorlogeFixe` par un mock :

```csharp
Mock<IHorloge> horloge = new Mock<IHorloge>();
horloge.Setup(h => h.Maintenant).Returns(new DateTime(2026, 12, 7, 9, 0, 0));
```

Réécrivez l'exercice 2 avec ce mock. Quelle version préférez-vous ?

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution complété au format PDF** sur Moodle avant la fin de la séance. Il doit contenir les **4 captures**.
:::
