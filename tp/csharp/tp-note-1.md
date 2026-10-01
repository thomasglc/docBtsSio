---
outline: deep
---

# TP noté 1 - Les bases du C#

<Badge type="info" text="BTS SIO 1ère année" />  <Badge type="warning" text="Bloc 1 - Initiation C#" />  <Badge type="danger" text="Évaluation · 1h30" />

::: info Contexte
Le magasin d'informatique **SIO Store** vous confie le développement de plusieurs petits programmes en console. Ce TP noté évalue uniquement votre capacité à **programmer** : saisies, types, calculs, conditions et boucles. Il n'y a aucune question de cours.
:::

::: warning Modalités
- Travail **individuel**, durée **1h30** (démarrage du poste et dépôt compris).
- Pour chaque exercice, collez dans le document de restitution **une capture de votre code** et **une capture de la console** après avoir lancé le **test imposé**.
- Déposez le document au format **PDF** sur Moodle avant la fin de l'épreuve. Un exercice absent du document ne peut pas être noté.

📥 <a href="/tp-note-1-csharp-restitution.docx" download style="font-weight:600">Télécharger le document de restitution</a>
:::

---

## Barème

| Exercice | Notions évaluées | Points |
|---|---|---|
| 1 - Fiche client | Variables `string`, saisie, interpolation | 3 |
| 2 - Facture | `int`, `double`, conversions, calculs | 4 |
| 3 - Frais de livraison | `if` / `else if` / `else` | 4 |
| 4 - Avantages client | Opérateurs `&&`, `\|\|` et `!=` | 5 |
| 5 - Ticket de caisse | Boucle et accumulateur | 4 |
| **Total** | | **20** |

::: tip Conseils
- Créez un nouveau projet par exercice (`Exercice1`, `Exercice2`...) en cochant **N'utilisez pas d'instructions de niveau supérieur**. Vous pourrez ainsi revenir sur un exercice précédent.
- Les exercices sont indépendants : si vous bloquez, passez au suivant.
- Avec les valeurs du test imposé, votre programme doit afficher **exactement** le résultat attendu. Comparez avant de faire vos captures.
- Remplissez le document au fur et à mesure et gardez **5 minutes** à la fin pour l'export PDF et le dépôt.
:::

---

## Exercice 1 - Fiche client <Badge type="tip" text="3 points" />

Écrivez un programme qui demande le **prénom**, le **nom** et la **ville** d'un nouveau client, puis affiche sa fiche.

**Test imposé** : saisissez vos propres prénom, nom et ville.

Résultat attendu (exemple) :

```
Prénom : Lucie
Nom : Martin
Ville : Colmar

=== SIO Store - Fiche client ===
Client : Lucie Martin
Ville : Colmar
Bienvenue Lucie, votre compte client a bien été créé !
```

**Notation**

| Critère | Points |
|---|---|
| Les trois informations sont lues au clavier et stockées dans des variables | 1 |
| Les messages sont construits avec l'interpolation `$"..."` | 1 |
| L'affichage est conforme au résultat attendu | 1 |

---

## Exercice 2 - Facture <Badge type="tip" text="4 points" />

Écrivez un programme qui demande le **nom d'un article**, son **prix unitaire hors taxes (HT)** et la **quantité** commandée, puis affiche la facture :

- **Total HT** : prix unitaire × quantité
- **TVA** : 20 % du total HT
- **Total TTC** : total HT + TVA

**Test imposé** : article `Clavier mécanique`, prix `42,5`, quantité `4`.

Résultat attendu :

```
Article : Clavier mécanique
Prix unitaire HT : 42,5
Quantité : 4

=== Facture ===
4 x Clavier mécanique à 42,5 euros
Total HT : 170 euros
TVA (20 %) : 34 euros
Total TTC : 204 euros
```

**Notation**

| Critère | Points |
|---|---|
| Le prix est converti en `double` et la quantité en `int` | 1 |
| Le total HT est correct | 1 |
| La TVA et le total TTC sont corrects | 1 |
| L'affichage est conforme au résultat attendu | 1 |

---

## Exercice 3 - Frais de livraison <Badge type="tip" text="4 points" />

Écrivez un programme qui demande le **montant de la commande**, puis affiche les frais de livraison selon les règles suivantes :

| Montant de la commande | Message à afficher |
|---|---|
| 0 ou négatif | `Montant invalide.` (et rien d'autre) |
| Moins de 30 euros | `Frais de livraison : 6 euros` |
| De 30 euros à moins de 80 euros | `Frais de livraison : 4 euros` |
| 80 euros ou plus | `Frais de livraison : offerts` |

Sauf si le montant est invalide, le programme affiche ensuite le **total à payer** (montant + frais).

**Test imposé** : montant `80`.

Résultat attendu :

```
Montant de la commande : 80

Frais de livraison : offerts
Total à payer : 80 euros
```

**Notation**

| Critère | Points |
|---|---|
| Un montant nul ou négatif affiche `Montant invalide.` | 1 |
| Les trois tranches sont gérées avec `if` / `else if` / `else` | 1 |
| Les bornes sont respectées : 30 et 80 euros appartiennent à la tranche supérieure | 1 |
| Le total à payer est correct et l'affichage est conforme | 1 |

---

## Exercice 4 - Avantages client <Badge type="tip" text="5 points" />

Écrivez un programme qui demande l'**âge** du client, le **montant** de sa commande et s'il possède une **carte de fidélité** (`o` ou `n`). Le programme indique ensuite, pour chaque avantage, si le client y a droit (`OUI`) ou non (`NON`) :

| Avantage | Le client y a droit si... |
|---|---|
| Offre de bienvenue | il **n'a pas** de carte de fidélité |
| Réduction jeune | il a **entre 18 et 25 ans** (inclus) |
| Cadeau fidélité | il a une carte de fidélité **et** sa commande est d'au moins 50 euros |
| Paiement en 3 fois | sa commande est d'au moins 80 euros **ou** il a une carte de fidélité |

**Test imposé** : âge `26`, montant `80`, carte `n`.

Résultat attendu :

```
Votre âge : 26
Montant de la commande : 80
Carte de fidélité (o/n) : n

=== Vos avantages ===
Offre de bienvenue : OUI
Réduction jeune : NON
Cadeau fidélité : NON
Paiement en 3 fois : OUI
```

::: tip Comparer du texte
Une chaîne de caractères se compare avec `==` et `!=`, comme un nombre : `if (carte == "o")`.
:::

**Notation**

| Critère | Points |
|---|---|
| L'âge est converti en `int` et le montant en `double` | 1 |
| Offre de bienvenue correcte | 1 |
| Réduction jeune correcte | 1 |
| Cadeau fidélité correct | 1 |
| Paiement en 3 fois correct | 1 |

---

## Exercice 5 - Ticket de caisse <Badge type="tip" text="4 points" />

Écrivez un programme qui demande le **nombre d'articles** achetés, puis le **prix de chaque article**, un par un, à l'aide d'une **boucle**. Il affiche ensuite le total à payer.

**Test imposé** : `3` articles, aux prix `12,5`, `7,25` et `20`.

Résultat attendu :

```
Nombre d'articles : 3
Prix de l'article 1 : 12,5
Prix de l'article 2 : 7,25
Prix de l'article 3 : 20

=== Ticket de caisse ===
Total à payer : 39,75 euros
```

**Notation**

| Critère | Points |
|---|---|
| Une boucle demande le prix autant de fois qu'il y a d'articles | 1 |
| Le numéro de l'article s'affiche dans la question (1, 2, 3) | 1 |
| Le total est calculé avec une variable accumulatrice et il est correct | 1 |
| L'affichage est conforme au résultat attendu | 1 |

---

## Rendu

::: danger Rendu sur Moodle
Déposez votre **document de restitution au format PDF** sur Moodle avant la fin de l'épreuve. Pour chaque exercice traité, il doit contenir la capture du code et la capture de la console avec le test imposé.
:::
