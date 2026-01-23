# 📝 TP 01 - Les conditions

## Exercice 1 : Vérification d'accès à une attraction


#### Énoncé :
Vous devez créer un programme qui demande à l'utilisateur sa taille en centimètres et qui, en fonction de sa taille, lui dira s'il peut accéder ou non à une attraction.

---

#### Instructions :
Renseigné une taille en cm dans une variable.
Utiliser une condition `if/else` pour vérifier si l'utilisateur est suffisamment grand pour accéder à l'attraction :

Si la taille est **supérieure ou égale** à 140 cm, afficher "**Accès autorisé**".
Si la taille est inférieure à 140 cm, afficher "**Accès refusé**".

Tester plusieurs valeurs, par exemple 135 cm, 140 cm, et 150 cm pour voir les différents résultats.
Le texte doit être affiché en `html`, il ne faut pas ouvrir la console.

## Exercice 2 : Calculateur d'IMC (Indice de Masse Corporelle)

#### Énoncé :
Créer un programme qui calcule l'IMC d'une personne en fonction de son poids et de sa taille. L'IMC est calculé selon la formule suivante :

`IMC = Poids (kg) / ( Taille (m) * Taille (m) )`

---

#### Instructions :
Indiquez un poids et une taille dans deux variables distinct.
Calculer son IMC en utilisant la formule.

En fonction du résultat, afficher un message indiquant si l'utilisateur est en sous-poids, a un poids normal, est en surpoids ou est obèse selon les critères suivants :
- IMC < 18.5 : sous-poids
- 18.5 ≤ IMC < 25 : poids normal
- 25 ≤ IMC < 30 : surpoids
- IMC ≥ 30 : obésité

Afficher le résultat de l'IMC avec un message correspondant à sa catégorie.

## Exercice 3 : Convertisseur de notes en appréciation
#### Énoncé :
Vous allez créer un programme qui demande à l'utilisateur d'entrer une note sur 20. Le programme doit convertir cette note en lettre selon le barème suivant :

17-20 : “Excellent travail”
14-16 : “Très bon travail”
10-14 : “Bon travail”
5-9 : “Manque de travail”
Moins de 5 : “Les bases de sont pas acquises”

Si l'utilisateur entre une note supérieure à 20 ou inférieure à 0, afficher un message d'erreur.

---

#### Instructions :
Demander à l'utilisateur d'entrer une note entre 0 et 20.
Utiliser des conditions <br> `if / elseif / else` pour déterminer l’appréciation associé a la note

Si la note est en dehors de la plage 0-20, afficher "Erreur : la note doit être comprise entre 0 et 20".
