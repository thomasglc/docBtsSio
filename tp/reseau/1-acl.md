---
outline: deep
---

# TP 2 — Infrastructure réseau multi-sites & ACL

<Badge type="info" text="BTS SIO SISR 2ème année" />  <Badge type="warning" text="Bloc 2 — Sécurité réseau & Pare-feu" />  <Badge type="danger" text="Cisco Packet Tracer" />

::: info Contexte
La société **TechSolutions** possède deux sites géographiques : le **siège social** (Site A) et une **agence distante** (Site B). Les deux sites sont reliés entre eux par une liaison WAN. Une zone **DMZ** héberge les serveurs internes accessibles aux deux sites.

Votre mission est de configurer l'intégralité de l'infrastructure réseau, puis de mettre en place les règles de sécurité définies par la politique de l'entreprise.
:::

::: warning Modalités
Toutes les configurations sont à réaliser sur **Cisco Packet Tracer**. Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸. Sauvegardez votre fichier Packet Tracer régulièrement.
:::

---

## Topologie du réseau

<div style="overflow-x: auto;">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 780 400" style="width:100%; min-width:600px; font-family:'Segoe UI',Arial,sans-serif; font-size:10px;">

  <!-- Zone Site A -->
  <rect x="10" y="160" width="250" height="220" rx="10" fill="#eafaf1" stroke="#27ae60" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="20" y="175" fill="#27ae60" font-weight="bold" font-size="9">SITE A — Siège social</text>

  <!-- Zone Site B -->
  <rect x="520" y="160" width="250" height="220" rx="10" fill="#fff4ec" stroke="#e05c00" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="530" y="175" fill="#e05c00" font-weight="bold" font-size="9">SITE B — Agence distante</text>

  <!-- Zone DMZ -->
  <rect x="270" y="10" width="240" height="100" rx="10" fill="#fdf6e3" stroke="#b7770d" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="280" y="25" fill="#b7770d" font-weight="bold" font-size="9">DMZ — 10.0.100.0/24</text>

  <!-- SRV-Web -->
  <rect x="285" y="32" width="90" height="38" rx="5" fill="#fff8e1" stroke="#b7770d" stroke-width="1.5"/>
  <text x="330" y="47" fill="#7d5a00" font-weight="bold" text-anchor="middle">SRV-Web</text>
  <text x="330" y="61" fill="#555" text-anchor="middle">10.0.100.10/24</text>

  <!-- SRV-FTP -->
  <rect x="395" y="32" width="90" height="38" rx="5" fill="#fff8e1" stroke="#b7770d" stroke-width="1.5"/>
  <text x="440" y="47" fill="#7d5a00" font-weight="bold" text-anchor="middle">SRV-FTP</text>
  <text x="440" y="61" fill="#555" text-anchor="middle">10.0.100.20/24</text>

  <!-- R1 -->
  <rect x="200" y="140" width="110" height="50" rx="8" fill="#1a6fc4" stroke="#0d4a8a" stroke-width="2"/>
  <text x="255" y="161" fill="#fff" font-weight="bold" text-anchor="middle" font-size="12">R1</text>
  <text x="255" y="178" fill="#cce0ff" text-anchor="middle" font-size="8.5">Cisco 2911 — Siège</text>

  <!-- R2 -->
  <rect x="470" y="140" width="110" height="50" rx="8" fill="#e05c00" stroke="#a34200" stroke-width="2"/>
  <text x="525" y="161" fill="#fff" font-weight="bold" text-anchor="middle" font-size="12">R2</text>
  <text x="525" y="178" fill="#ffe0cc" text-anchor="middle" font-size="8.5">Cisco 2911 — Agence</text>

  <!-- Lien WAN R1 — R2 -->
  <line x1="310" y1="165" x2="470" y2="165" stroke="#6c3483" stroke-width="3"/>
  <rect x="360" y="152" width="60" height="16" rx="3" fill="#6c3483"/>
  <text x="390" y="163" fill="#fff" text-anchor="middle" font-size="8">WAN</text>
  <text x="330" y="148" fill="#6c3483" text-anchor="middle" font-size="8">10.10.12.1</text>
  <text x="458" y="148" fill="#6c3483" text-anchor="middle" font-size="8">10.10.12.2</text>

  <!-- Liens DMZ → R1 -->
  <line x1="330" y1="70" x2="255" y2="140" stroke="#b7770d" stroke-width="1.5"/>
  <line x1="440" y1="70" x2="255" y2="140" stroke="#b7770d" stroke-width="1.5"/>
  <text x="265" y="108" fill="#b7770d" font-size="8">Gi0/2</text>

  <!-- SW1 -->
  <rect x="80" y="245" width="110" height="44" rx="7" fill="#0d4a8a" stroke="#091e3a" stroke-width="1.5"/>
  <text x="135" y="263" fill="#fff" font-weight="bold" text-anchor="middle" font-size="11">SW1</text>
  <text x="135" y="279" fill="#cce0ff" text-anchor="middle" font-size="8.5">Cisco 2960</text>

  <!-- SW2 -->
  <rect x="590" y="245" width="110" height="44" rx="7" fill="#a34200" stroke="#7a3000" stroke-width="1.5"/>
  <text x="645" y="263" fill="#fff" font-weight="bold" text-anchor="middle" font-size="11">SW2</text>
  <text x="645" y="279" fill="#ffe0cc" text-anchor="middle" font-size="8.5">Cisco 2960</text>

  <!-- Lien R1 → SW1 -->
  <line x1="225" y1="190" x2="155" y2="245" stroke="#1a6fc4" stroke-width="2.5" stroke-dasharray="7,3"/>
  <text x="175" y="225" fill="#1a6fc4" font-size="8">TRUNK</text>
  <text x="215" y="215" fill="#1a6fc4" font-size="7.5">Gi0/0</text>

  <!-- Lien R2 → SW2 -->
  <line x1="555" y1="190" x2="625" y2="245" stroke="#e05c00" stroke-width="2.5" stroke-dasharray="7,3"/>
  <text x="574" y="225" fill="#e05c00" font-size="8">TRUNK</text>
  <text x="550" y="215" fill="#e05c00" font-size="7.5">Gi0/1</text>

  <!-- PC-Dir-1 -->
  <rect x="15" y="310" width="80" height="38" rx="5" fill="#eafaf1" stroke="#27ae60" stroke-width="1.5"/>
  <text x="55" y="325" fill="#1a5c38" font-weight="bold" text-anchor="middle" font-size="9">PC-Dir-1</text>
  <text x="55" y="338" fill="#555" text-anchor="middle" font-size="8">VLAN 10</text>

  <!-- PC-Dir-2 -->
  <rect x="105" y="310" width="80" height="38" rx="5" fill="#eafaf1" stroke="#27ae60" stroke-width="1.5"/>
  <text x="145" y="325" fill="#1a5c38" font-weight="bold" text-anchor="middle" font-size="9">PC-Dir-2</text>
  <text x="145" y="338" fill="#555" text-anchor="middle" font-size="8">VLAN 10</text>

  <!-- PC-Com-1 -->
  <rect x="15" y="358" width="80" height="38" rx="5" fill="#dce9f7" stroke="#1a6fc4" stroke-width="1.5"/>
  <text x="55" y="373" fill="#1a4a8a" font-weight="bold" text-anchor="middle" font-size="9">PC-Com-1</text>
  <text x="55" y="386" fill="#555" text-anchor="middle" font-size="8">VLAN 20</text>

  <!-- PC-Com-2 -->
  <rect x="105" y="358" width="80" height="38" rx="5" fill="#dce9f7" stroke="#1a6fc4" stroke-width="1.5"/>
  <text x="145" y="373" fill="#1a4a8a" font-weight="bold" text-anchor="middle" font-size="9">PC-Com-2</text>
  <text x="145" y="386" fill="#555" text-anchor="middle" font-size="8">VLAN 20</text>

  <!-- Liens PCs → SW1 -->
  <line x1="55"  y1="310" x2="105" y2="289" stroke="#27ae60" stroke-width="1.2"/>
  <line x1="145" y1="310" x2="135" y2="289" stroke="#27ae60" stroke-width="1.2"/>
  <line x1="55"  y1="358" x2="105" y2="289" stroke="#1a6fc4" stroke-width="1.2"/>
  <line x1="145" y1="358" x2="135" y2="289" stroke="#1a6fc4" stroke-width="1.2"/>

  <!-- PC-Tech-1 -->
  <rect x="530" y="310" width="80" height="38" rx="5" fill="#fff4ec" stroke="#e05c00" stroke-width="1.5"/>
  <text x="570" y="325" fill="#7a3000" font-weight="bold" text-anchor="middle" font-size="9">PC-Tech-1</text>
  <text x="570" y="338" fill="#555" text-anchor="middle" font-size="8">VLAN 30</text>

  <!-- PC-Tech-2 -->
  <rect x="620" y="310" width="80" height="38" rx="5" fill="#fff4ec" stroke="#e05c00" stroke-width="1.5"/>
  <text x="660" y="325" fill="#7a3000" font-weight="bold" text-anchor="middle" font-size="9">PC-Tech-2</text>
  <text x="660" y="338" fill="#555" text-anchor="middle" font-size="8">VLAN 30</text>

  <!-- PC-RH-1 -->
  <rect x="530" y="358" width="80" height="38" rx="5" fill="#f0e6ff" stroke="#6c3483" stroke-width="1.5"/>
  <text x="570" y="373" fill="#4a1a6a" font-weight="bold" text-anchor="middle" font-size="9">PC-RH-1</text>
  <text x="570" y="386" fill="#555" text-anchor="middle" font-size="8">VLAN 40</text>

  <!-- PC-RH-2 -->
  <rect x="620" y="358" width="80" height="38" rx="5" fill="#f0e6ff" stroke="#6c3483" stroke-width="1.5"/>
  <text x="660" y="373" fill="#4a1a6a" font-weight="bold" text-anchor="middle" font-size="9">PC-RH-2</text>
  <text x="660" y="386" fill="#555" text-anchor="middle" font-size="8">VLAN 40</text>

  <!-- Liens PCs → SW2 -->
  <line x1="570" y1="310" x2="625" y2="289" stroke="#e05c00" stroke-width="1.2"/>
  <line x1="660" y1="310" x2="655" y2="289" stroke="#e05c00" stroke-width="1.2"/>
  <line x1="570" y1="358" x2="625" y2="289" stroke="#6c3483" stroke-width="1.2"/>
  <line x1="660" y1="358" x2="655" y2="289" stroke="#6c3483" stroke-width="1.2"/>

</svg>
</div>

---

## Plan d'adressage

| Équipement | Interface | Adresse IP | Masque | Passerelle | Zone |
|---|---|---|---|---|---|
| **R1** | `Gi0/0.10` | 192.168.10.1 | /24 | — | VLAN 10 |
| **R1** | `Gi0/0.20` | 192.168.20.1 | /24 | — | VLAN 20 |
| **R1** | `Gi0/1` | 10.10.12.1 | /30 | — | WAN |
| **R1** | `Gi0/2` | 10.0.100.1 | /24 | — | DMZ |
| **R2** | `Gi0/0` | 10.10.12.2 | /30 | — | WAN |
| **R2** | `Gi0/1.30` | 172.16.30.1 | /24 | — | VLAN 30 |
| **R2** | `Gi0/1.40` | 172.16.40.1 | /24 | — | VLAN 40 |
| **SRV-Web** | `NIC` | 10.0.100.10 | /24 | 10.0.100.1 | DMZ |
| **SRV-FTP** | `NIC` | 10.0.100.20 | /24 | 10.0.100.1 | DMZ |
| PC-Dir-1 / PC-Dir-2 | `NIC` | DHCP (.10 à .100) | /24 | 192.168.10.1 | VLAN 10 |
| PC-Com-1 / PC-Com-2 | `NIC` | DHCP (.10 à .100) | /24 | 192.168.20.1 | VLAN 20 |
| PC-Tech-1 / PC-Tech-2 | `NIC` | DHCP (.10 à .100) | /24 | 172.16.30.1 | VLAN 30 |
| PC-RH-1 / PC-RH-2 | `NIC` | DHCP (.10 à .100) | /24 | 172.16.40.1 | VLAN 40 |

---

## Politique de sécurité — ACL à mettre en place

Une fois l'infrastructure opérationnelle, les règles suivantes doivent être appliquées :

**ACL sur R1** — appliquée sur l'interface `Gi0/0.20` (VLAN 20 — Commerciaux)

| # | Source | Destination | Protocole | Action |
|---|---|---|---|---|
| 1 | VLAN 20 — Commerciaux | SRV-Web — 10.0.100.10 | HTTP — TCP/80 | ✅ PERMIT |
| 2 | VLAN 20 — Commerciaux | SRV-FTP — 10.0.100.20 | FTP — TCP/21 | ❌ DENY |
| 3 | VLAN 20 — Commerciaux | VLAN 10 — 192.168.10.0/24 | Tout trafic IP | ❌ DENY |
| 4 | VLAN 20 — Commerciaux | Toutes destinations | Tout trafic IP | ✅ PERMIT |

**ACL sur R2** — appliquée sur l'interface `Gi0/1.40` (VLAN 40 — RH)

| # | Source | Destination | Protocole | Action |
|---|---|---|---|---|
| 5 | VLAN 40 — RH | VLAN 30 — 172.16.30.0/24 | Tout trafic IP | ❌ DENY |
| 6 | VLAN 40 — RH | Toutes destinations | Tout trafic IP | ✅ PERMIT |

---

## Missions de configuration

::: info Rappel
Les commandes ne sont pas fournies — vous devez les retrouver à partir de vos notes de cours. En cas de blocage, utilisez la commande `?` dans la CLI Cisco ou consultez votre cours.
:::

---

### Mission 1 — Création de la topologie dans Packet Tracer


Ouvrez Packet Tracer et reproduisez la topologie du schéma ci-dessus.

- Ajoutez : **2 routeurs Cisco 2911** (R1 et R2), **2 switchs Cisco 2960** (SW1 et SW2), **4 PCs par site** (voir nommage du plan d'adressage), **2 serveurs génériques** (SRV-Web et SRV-FTP).
- Reliez les équipements avec le type de câble adapté.
- Nommez chaque équipement exactement comme indiqué dans le plan d'adressage.
- Configurez les adresses IP statiques de **SRV-Web** et **SRV-FTP** selon le plan d'adressage.

::: tip 📸 Capture 1
Vue d'ensemble de la topologie Packet Tracer avec tous les équipements reliés et nommés.
:::

---

### Mission 2 — Configuration des VLANs sur SW1 et SW2


#### SW1 — Site A (Siège)

**Tâche 2.1 — Création des VLANs**

Créez les deux VLANs suivants sur SW1 et attribuez-leur un nom :
- **VLAN 10** — nom : _Direction_
- **VLAN 20** — nom : _Commerciaux_

**Tâche 2.2 — Affectation des ports d'accès**

Configurez les ports du switch en mode _access_ et affectez-les aux bons VLANs :

| Port SW1 | PC connecté | VLAN |
|---|---|---|
| Fa0/1 | PC-Dir-1 | 10 |
| Fa0/2 | PC-Dir-2 | 10 |
| Fa0/3 | PC-Com-1 | 20 |
| Fa0/4 | PC-Com-2 | 20 |

**Tâche 2.3 — Lien trunk vers R1**

Configurez le port **Gi0/1** de SW1 en mode _trunk_ (liaison vers R1).

::: tip 📸 Capture 2
Sortie de `show vlan brief` sur SW1 (VLANs 10 et 20 visibles avec leurs ports).
:::

::: tip 📸 Capture 3
Sortie de `show interfaces trunk` sur SW1 (Gi0/1 en mode trunk).
:::

#### SW2 — Site B (Agence)

**Tâche 2.4 — Création des VLANs**

Créez les deux VLANs suivants sur SW2 :
- **VLAN 30** — nom : _Technique_
- **VLAN 40** — nom : _RH_

**Tâche 2.5 — Affectation des ports et trunk**

Affectez les ports de SW2 aux VLANs correspondants (PC-Tech → VLAN 30, PC-RH → VLAN 40) et configurez le port relié à R2 en mode trunk.

::: tip 📸 Capture 4
Sortie de `show vlan brief` sur SW2.
:::

---

### Mission 3 — Routage inter-VLAN et adressage des routeurs


::: tip Rappel
La technique **Router-on-a-Stick** consiste à créer une **sous-interface** par VLAN sur une seule interface physique du routeur, avec encapsulation `dot1Q`. Chaque sous-interface devient la passerelle du VLAN correspondant.
:::

#### R1 — Siège social

**Tâche 3.1 — Sous-interfaces VLAN 10 et VLAN 20**

Sur l'interface **Gi0/0** de R1, créez deux sous-interfaces :
- `Gi0/0.10` → encapsulation VLAN 10 → adresse IP : `192.168.10.1/24`
- `Gi0/0.20` → encapsulation VLAN 20 → adresse IP : `192.168.20.1/24`

N'oubliez pas d'activer l'interface physique `Gi0/0` avec `no shutdown`.

**Tâche 3.2 — Interface WAN (liaison vers R2)**

Configurez l'interface **Gi0/1** de R1 avec l'adresse `10.10.12.1/30`.

**Tâche 3.3 — Interface DMZ (vers les serveurs)**

Configurez l'interface **Gi0/2** de R1 avec l'adresse `10.0.100.1/24`. Reliez SRV-Web et SRV-FTP à R1 via un switch supplémentaire ou directement (au choix).

#### R2 — Agence distante

**Tâche 3.4 — Interface WAN et sous-interfaces VLAN 30 et VLAN 40**

Sur R2, configurez :
- **Gi0/0** → adresse IP : `10.10.12.2/30` (liaison WAN vers R1)
- `Gi0/1.30` → encapsulation VLAN 30 → adresse IP : `172.16.30.1/24`
- `Gi0/1.40` → encapsulation VLAN 40 → adresse IP : `172.16.40.1/24`

::: tip 📸 Capture 5
Sortie de `show ip interface brief` sur R1 (toutes interfaces _up/up_).
:::

::: tip 📸 Capture 6
Sortie de `show ip interface brief` sur R2 (toutes interfaces _up/up_).
:::

::: tip 📸 Capture 7
Ping depuis PC-Dir-1 vers sa passerelle (192.168.10.1) : succès attendu.
:::

---

### Mission 4 — Configuration du service DHCP sur les routeurs


**Tâche 4.1 — DHCP sur R1 pour le VLAN 10 (Direction)**

Créez un pool DHCP nommé **POOL-VLAN10** sur R1 avec :
- Réseau : `192.168.10.0/24`
- Passerelle par défaut : `192.168.10.1`
- DNS : `8.8.8.8`
- Excluez les adresses `.1` à `.9` de la distribution automatique.

**Tâche 4.2 — DHCP sur R1 pour le VLAN 20 (Commerciaux)**

Créez un pool DHCP nommé **POOL-VLAN20** sur R1 (réseau `192.168.20.0/24`, passerelle `192.168.20.1`).

**Tâche 4.3 — DHCP sur R2 pour les VLANs 30 et 40**

Créez sur R2 un pool **POOL-VLAN30** (`172.16.30.0/24`) et un pool **POOL-VLAN40** (`172.16.40.0/24`).

**Tâche 4.4 — Test d'attribution DHCP**

Passez les quatre PCs de chaque site en configuration **DHCP automatique** (_Desktop_ → _IP Configuration_ → _DHCP_) et vérifiez qu'ils obtiennent bien une adresse IP.

::: tip 📸 Capture 8
Configuration IP de PC-Dir-1 et PC-Com-1 montrant les adresses obtenues en DHCP.
:::

::: tip 📸 Capture 9
Configuration IP de PC-Tech-1 et PC-RH-1 montrant les adresses obtenues en DHCP.
:::

---

### Mission 5 — Configuration des serveurs (HTTP et FTP)


**Tâche 5.1 — Serveur web (SRV-Web)**

Sur SRV-Web, activez le service **HTTP** (onglet _Services_ → _HTTP_). Modifiez la page `index.html` pour afficher le message : _"Portail interne TechSolutions — accès réservé"_.

**Tâche 5.2 — Serveur FTP (SRV-FTP)**

Sur SRV-FTP, activez le service **FTP** (onglet _Services_ → _FTP_). Créez un utilisateur FTP : login `admin`, mot de passe `cisco123`, avec tous les droits activés.

**Tâche 5.3 — Tests d'accès initiaux (avant ACL)**

Avant de configurer les ACL, vérifiez que l'accès aux serveurs fonctionne depuis les deux sites :
- Depuis **PC-Dir-1** : accédez à `http://10.0.100.10` via Web Browser.
- Depuis **PC-Com-1** : accédez à `http://10.0.100.10` via Web Browser.
- Depuis **PC-Com-1** : connectez-vous au FTP `10.0.100.20` via Command Prompt (`ftp 10.0.100.20`).

Ces trois tests doivent réussir à ce stade.

::: tip 📸 Capture 10
Page web affichée dans le browser de PC-Dir-1.
:::

::: tip 📸 Capture 11
Connexion FTP réussie depuis PC-Com-1 vers SRV-FTP (avant ACL).
:::

---

### Mission 6 — Routage dynamique RIP version 2


::: tip Rappel
Utilisez `version 2` pour activer RIPv2 et `no auto-summary` pour désactiver la synthèse automatique des routes (indispensable avec des plages d'adresses discontinues).
:::

**Tâche 6.1 — RIP sur R1**

Activez RIP v2 sur R1 et déclarez tous les réseaux directement connectés :
- `192.168.10.0`
- `192.168.20.0`
- `10.10.12.0`
- `10.0.100.0`

Désactivez la synthèse automatique.

**Tâche 6.2 — RIP sur R2**

Activez RIP v2 sur R2 et déclarez les réseaux directement connectés :
- `10.10.12.0`
- `172.16.30.0`
- `172.16.40.0`

**Tâche 6.3 — Vérification des tables de routage**

Attendez quelques secondes que RIP converge, puis vérifiez les tables de routage sur R1 et R2. Les routes apprises via RIP sont indiquées par la lettre `R` dans la table.

**Tâche 6.4 — Test de connectivité inter-sites**

Depuis **PC-Dir-1** (VLAN 10, Site A), effectuez un ping vers **PC-Tech-1** (VLAN 30, Site B). Ce ping doit réussir si RIP et le routage inter-VLAN sont correctement configurés.

::: tip 📸 Capture 12
Sortie de `show ip route` sur R1 (routes RIP visibles avec la lettre `R`).
:::

::: tip 📸 Capture 13
Sortie de `show ip route` sur R2.
:::

::: tip 📸 Capture 14
Ping réussi depuis PC-Dir-1 vers PC-Tech-1 (adresse IP obtenue en DHCP).
:::

---

### Mission 7 — Mise en place des ACL de sécurité


::: warning Avant de commencer
Relisez attentivement la politique de sécurité définie plus haut. Identifiez pour chaque ACL : le type (étendue nommée), l'interface d'application, le sens (in/out) et l'ordre des règles. Réfléchissez aux wildcards nécessaires.
:::

#### ACL 1 — Filtrage des Commerciaux (sur R1)

**Tâche 7.1 — Création de l'ACL `SECURITE-COMMERCIAUX`**

Sur R1, créez une ACL étendue nommée **SECURITE-COMMERCIAUX** qui applique les règles 1, 2, 3 et 4 de la politique de sécurité.
- Respectez l'ordre : les règles les plus spécifiques en premier.
- Pensez à terminer par une règle autorisant le reste du trafic (règle 4).

**Tâche 7.2 — Application de l'ACL sur l'interface**

Appliquez **SECURITE-COMMERCIAUX** sur la sous-interface `Gi0/0.20` de R1, dans le bon sens (trafic entrant depuis les Commerciaux).

#### ACL 2 — Filtrage des RH (sur R2)

**Tâche 7.3 — Création de l'ACL `SECURITE-RH`**

Sur R2, créez une ACL étendue nommée **SECURITE-RH** qui applique les règles 5 et 6 de la politique de sécurité.

**Tâche 7.4 — Application de l'ACL sur l'interface**

Appliquez **SECURITE-RH** sur la sous-interface `Gi0/1.40` de R2, dans le bon sens.

#### Tests de validation

Effectuez les tests suivants et vérifiez que les résultats correspondent aux attentes :

| # | Source | Test | Résultat attendu |
|---|---|---|---|
| T1 | PC-Com-1 | Web Browser → `http://10.0.100.10` | ✅ Succès — page web visible |
| T2 | PC-Com-1 | `ftp 10.0.100.20` | ❌ Échec — connexion refusée |
| T3 | PC-Com-1 | Ping → `192.168.10.x` (PC-Dir-1) | ❌ Échec — bloqué par ACL |
| T4 | PC-Com-1 | Ping → `172.16.30.x` (PC-Tech-1, Site B) | ✅ Succès — non bloqué |
| T5 | PC-Dir-1 | Web Browser → `http://10.0.100.10` | ✅ Succès — accès total Direction |
| T6 | PC-Dir-1 | `ftp 10.0.100.20` | ✅ Succès — accès total Direction |
| T7 | PC-RH-1 | Ping → `172.16.30.x` (PC-Tech-1) | ❌ Échec — bloqué par ACL |
| T8 | PC-RH-1 | Web Browser → `http://10.0.100.10` | ✅ Succès — RH peut accéder au web |

::: tip 📸 Capture 15
`show ip access-lists SECURITE-COMMERCIAUX` sur R1 (après les tests, avec les _matches_).
:::

::: tip 📸 Capture 16
`show ip access-lists SECURITE-RH` sur R2.
:::

::: tip 📸 Capture 17
Test T1 — page web visible depuis PC-Com-1.
:::

::: tip 📸 Capture 18
Test T2 — connexion FTP refusée depuis PC-Com-1.
:::

::: tip 📸 Capture 19
Test T7 — ping refusé depuis PC-RH-1 vers PC-Tech-1.
:::

---

## Récapitulatif — Rapport annexe à rendre

::: danger À rendre
Votre rapport annexe doit contenir les **19 captures d'écran** listées ci-dessous, dans l'ordre, avec pour chaque capture une légende indiquant ce qu'elle montre.
:::

| N° | Contenu de la capture | Mission |
|---|---|---|
| 1 | Vue d'ensemble de la topologie Packet Tracer | 1 |
| 2 | `show vlan brief` sur SW1 | 2 |
| 3 | `show interfaces trunk` sur SW1 | 2 |
| 4 | `show vlan brief` sur SW2 | 2 |
| 5 | `show ip interface brief` sur R1 | 3 |
| 6 | `show ip interface brief` sur R2 | 3 |
| 7 | Ping depuis PC-Dir-1 vers 192.168.10.1 | 3 |
| 8 | Configuration IP de PC-Dir-1 et PC-Com-1 (DHCP) | 4 |
| 9 | Configuration IP de PC-Tech-1 et PC-RH-1 (DHCP) | 4 |
| 10 | Page web dans le browser de PC-Dir-1 | 5 |
| 11 | Connexion FTP réussie depuis PC-Com-1 (avant ACL) | 5 |
| 12 | `show ip route` sur R1 (routes RIP) | 6 |
| 13 | `show ip route` sur R2 (routes RIP) | 6 |
| 14 | Ping réussi PC-Dir-1 → PC-Tech-1 (inter-sites) | 6 |
| 15 | `show ip access-lists SECURITE-COMMERCIAUX` | 7 |
| 16 | `show ip access-lists SECURITE-RH` | 7 |
| 17 | Test T1 — page web depuis PC-Com-1 | 7 |
| 18 | Test T2 — FTP refusé depuis PC-Com-1 | 7 |
| 19 | Test T7 — ping refusé PC-RH-1 → PC-Tech-1 | 7 |

::: warning Attention
Vérifiez que chaque capture montre clairement le résultat (pas de fenêtre coupée, texte lisible). Numérotez chaque capture et mentionnez dans votre rapport le nom de l'équipement et la commande utilisée pour chaque capture CLI.
:::
