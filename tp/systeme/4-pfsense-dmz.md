---
outline: deep
---

# TP 4 — DMZ & Règles de pare-feu avec pfSense

<Badge type="info" text="BTS SIO SISR 1ère année" />  <Badge type="warning" text="Bloc 2 — Sécurité réseau & Pare-feu" />  <Badge type="danger" text="pfSense + VirtualBox" />

::: info Contexte
La société **InfoSecure** souhaite héberger un serveur web accessible depuis son réseau interne tout en le **isolant des postes clients**. Votre mission est de mettre en place une architecture **DMZ** (Zone démilitarisée) à l'aide de pfSense et d'y appliquer une politique de sécurité stricte contrôlant les flux entre les trois zones du réseau.
:::

::: warning Modalités
Toutes les configurations sont à réaliser sur des **machines virtuelles VirtualBox**. Vous devrez constituer un **rapport-annexe** contenant les captures d'écran demandées à chaque étape. Les captures sont indiquées par 📸. Sauvegardez vos VMs régulièrement via des snapshots.

**Prérequis :** vous avez déjà installé pfSense lors du TP précédent. Ce TP repart de cette base.
:::

---

## Qu'est-ce qu'une DMZ ?

Une **DMZ** (Demilitarized Zone) est une zone réseau intermédiaire, isolée à la fois d'Internet et du réseau local interne. Elle est utilisée pour héberger des serveurs accessibles depuis l'extérieur (web, mail…) **sans exposer le réseau interne** en cas de compromission.

```
Internet ──── [Pare-feu] ──── LAN (postes clients)
                  │
                 DMZ (serveurs exposés)
```

Le pare-feu contrôle **tous les flux** entre ces trois zones. C'est le cœur de ce TP.

---

## Topologie du réseau

<div style="overflow-x: auto;">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 420" style="width:100%; min-width:580px; font-family:'Segoe UI',Arial,sans-serif; font-size:10px;">

  <!-- Zone WAN (Internet) -->
  <rect x="270" y="10" width="220" height="70" rx="10" fill="#f0f0f0" stroke="#888" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="380" y="28" fill="#444" font-weight="bold" text-anchor="middle" font-size="9">WAN — Internet (simulé)</text>
  <ellipse cx="380" cy="52" rx="40" ry="22" fill="#ddd" stroke="#888" stroke-width="1.5"/>
  <text x="380" y="55" fill="#444" text-anchor="middle" font-size="9">NAT / DHCP</text>

  <!-- pfSense -->
  <rect x="300" y="140" width="160" height="56" rx="10" fill="#c0392b" stroke="#922b21" stroke-width="2"/>
  <text x="380" y="163" fill="#fff" font-weight="bold" text-anchor="middle" font-size="13">pfSense</text>
  <text x="380" y="182" fill="#f9d0cd" text-anchor="middle" font-size="8.5">Pare-feu 3 interfaces</text>

  <!-- Lien WAN -->
  <line x1="380" y1="80" x2="380" y2="140" stroke="#888" stroke-width="2"/>
  <rect x="348" y="101" width="64" height="16" rx="3" fill="#888"/>
  <text x="380" y="113" fill="#fff" text-anchor="middle" font-size="8">em0 — WAN</text>
  <text x="420" y="99" fill="#555" font-size="8">DHCP</text>

  <!-- Zone LAN -->
  <rect x="30" y="260" width="240" height="140" rx="10" fill="#eafaf1" stroke="#27ae60" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="42" y="277" fill="#27ae60" font-weight="bold" font-size="9">LAN — 192.168.10.0/24</text>

  <!-- Client LAN -->
  <rect x="60" y="300" width="130" height="50" rx="7" fill="#fff" stroke="#27ae60" stroke-width="1.5"/>
  <text x="125" y="320" fill="#1a5c38" font-weight="bold" text-anchor="middle" font-size="10">VM-Client</text>
  <text x="125" y="335" fill="#555" text-anchor="middle" font-size="8.5">192.168.10.10/24</text>
  <text x="125" y="347" fill="#888" text-anchor="middle" font-size="8">Debian / Windows</text>

  <!-- Lien LAN -->
  <line x1="300" y1="168" x2="190" y2="260" stroke="#27ae60" stroke-width="2"/>
  <rect x="196" y="202" width="80" height="16" rx="3" fill="#27ae60"/>
  <text x="236" y="214" fill="#fff" text-anchor="middle" font-size="8">em1 — LAN</text>
  <text x="186" y="200" fill="#27ae60" font-size="8">192.168.10.1</text>

  <!-- Zone DMZ -->
  <rect x="490" y="260" width="240" height="140" rx="10" fill="#fdf6e3" stroke="#b7770d" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="502" y="277" fill="#b7770d" font-weight="bold" font-size="9">DMZ — 10.0.50.0/24</text>

  <!-- Serveur DMZ -->
  <rect x="520" y="300" width="150" height="50" rx="7" fill="#fff" stroke="#b7770d" stroke-width="1.5"/>
  <text x="595" y="320" fill="#7d5a00" font-weight="bold" text-anchor="middle" font-size="10">VM-Serveur</text>
  <text x="595" y="335" fill="#555" text-anchor="middle" font-size="8.5">10.0.50.10/24</text>
  <text x="595" y="347" fill="#888" text-anchor="middle" font-size="8">Apache2 (HTTP)</text>

  <!-- Lien DMZ -->
  <line x1="460" y1="168" x2="570" y2="260" stroke="#b7770d" stroke-width="2"/>
  <rect x="475" y="202" width="80" height="16" rx="3" fill="#b7770d"/>
  <text x="515" y="214" fill="#fff" text-anchor="middle" font-size="8">em2 — DMZ</text>
  <text x="560" y="200" fill="#b7770d" font-size="8">10.0.50.1</text>

  <!-- Flèches de flux bloqués DMZ → LAN -->
  <line x1="490" y1="330" x2="270" y2="330" stroke="#e74c3c" stroke-width="1.5" stroke-dasharray="5,3" marker-end="url(#arrow-red)"/>
  <text x="380" y="323" fill="#e74c3c" text-anchor="middle" font-size="8">❌ BLOQUÉ</text>

  <defs>
    <marker id="arrow-red" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto">
      <path d="M0,0 L0,6 L8,3 z" fill="#e74c3c"/>
    </marker>
  </defs>

</svg>
</div>

---

## Plan d'adressage

| Machine | Interface VM | Interface pfSense | Adresse IP | Masque | Passerelle | Zone |
|---|---|---|---|---|---|---|
| **pfSense** | Adaptateur 1 (NAT) | `em0` | DHCP | — | — | WAN |
| **pfSense** | Adaptateur 2 (Réseau interne `lan`) | `em1` | 192.168.10.1 | /24 | — | LAN |
| **pfSense** | Adaptateur 3 (Réseau interne `dmz`) | `em2` | 10.0.50.1 | /24 | — | DMZ |
| **VM-Client** | Adaptateur 1 (Réseau interne `lan`) | — | 192.168.10.10 | /24 | 192.168.10.1 | LAN |
| **VM-Serveur** | Adaptateur 1 (Réseau interne `dmz`) | — | 10.0.50.10 | /24 | 10.0.50.1 | DMZ |

---

## Politique de sécurité — Règles à mettre en place

Une fois l'infrastructure montée, les règles suivantes doivent être appliquées sur pfSense :

**Règles LAN** — appliquées sur l'interface `LAN` (trafic entrant depuis les clients)

| # | Source | Destination | Service | Action |
|---|---|---|---|---|
| 1 | LAN `192.168.10.0/24` | VM-Serveur `10.0.50.10` | HTTP — TCP/80 | ✅ PERMIT |
| 2 | LAN `192.168.10.0/24` | DMZ `10.0.50.0/24` | SSH — TCP/22 | ❌ DENY |
| 3 | LAN `192.168.10.0/24` | DMZ `10.0.50.0/24` | Tout | ❌ DENY |
| 4 | LAN `192.168.10.0/24` | Toutes destinations | Tout | ✅ PERMIT |

**Règles DMZ** — appliquées sur l'interface `DMZ`

| # | Source | Destination | Service | Action |
|---|---|---|---|---|
| 5 | DMZ `10.0.50.0/24` | LAN `192.168.10.0/24` | Tout | ❌ DENY |
| 6 | DMZ `10.0.50.0/24` | Toutes destinations | DNS — UDP/53 | ✅ PERMIT |
| 7 | DMZ `10.0.50.0/24` | Toutes destinations | HTTP/HTTPS — TCP/80,443 | ✅ PERMIT |
| 8 | DMZ `10.0.50.0/24` | Toutes destinations | Tout | ❌ DENY |

::: info Pourquoi ces règles ?
- La règle 2 empêche un administrateur mal intentionné (ou compromis) de SSH directement sur le serveur depuis un poste client standard.
- La règle 5 est cruciale : si le serveur DMZ est piraté, il ne doit pas pouvoir atteindre les postes du LAN.
- Les règles 6 et 7 permettent au serveur de se mettre à jour (apt update) sans ouvrir tous les flux sortants.
:::

---

## Missions de configuration

::: info Rappel
Les chemins de navigation dans l'interface pfSense sont indiqués en **gras** : **Interfaces → Assignments**. En cas de blocage, relisez attentivement les captures d'exemple et les indications de chaque tâche.
:::

---

### Mission 1 — Ajout de la troisième interface réseau sur pfSense

Votre pfSense dispose actuellement de deux interfaces (WAN et LAN). Il faut lui ajouter une troisième pour la DMZ.

**Tâche 1.1 — Éteindre la VM pfSense**

Dans VirtualBox, **éteignez** la VM pfSense (clic droit → Fermer → Éteindre).

::: danger Ne jamais modifier les interfaces d'une VM allumée
Modifier les adaptateurs réseau d'une VM en cours d'exécution peut corrompre la configuration réseau de pfSense.
:::

**Tâche 1.2 — Ajouter l'adaptateur réseau DMZ**

Dans les paramètres VirtualBox de la VM pfSense :
- Allez dans **Réseau → Adaptateur 3**
- Cochez **Activer l'adaptateur réseau**
- Mode d'accès : **Réseau interne**
- Nom : `dmz` (tapez exactement ce nom, il doit correspondre à la VM-Serveur)

**Tâche 1.3 — Vérifier les adaptateurs des VMs Client et Serveur**

| VM | Adaptateur | Mode | Nom réseau interne |
|---|---|---|---|
| VM-Client | Adaptateur 1 | Réseau interne | `lan` |
| VM-Serveur | Adaptateur 1 | Réseau interne | `dmz` |

Démarrez la VM pfSense.

::: tip 📸 Capture 1
Fenêtre des paramètres VirtualBox de pfSense — onglet Réseau, montrant les 3 adaptateurs activés.
:::

---

### Mission 2 — Assignation de l'interface DMZ dans pfSense

**Tâche 2.1 — Identifier la nouvelle interface**

Dans la console pfSense (écran de la VM), vous devriez voir trois interfaces listées (`em0`, `em1`, `em2`). Si ce n'est pas le cas, choisissez l'option **1) Assign Interfaces** dans le menu et assignez `em2` comme interface supplémentaire.

**Tâche 2.2 — Assigner l'interface dans l'interface web**

Depuis la VM-Client (ou votre machine), connectez-vous à `http://192.168.10.1` puis naviguez dans **Interfaces → Assignments**.

Vous devriez voir `em2` listée comme interface disponible. Cliquez sur **+ Add** pour l'ajouter. Elle apparaît sous le nom `OPT1`.

**Tâche 2.3 — Configurer l'interface OPT1 (future DMZ)**

Cliquez sur **OPT1** dans le menu **Interfaces** pour la configurer :

| Champ | Valeur |
|---|---|
| Enable | ✅ Coché |
| Description | `DMZ` |
| IPv4 Configuration Type | Static IPv4 |
| IPv4 Address | `10.0.50.1 / 24` |

Cliquez sur **Save** puis sur **Apply Changes**.

::: tip 📸 Capture 2
Page de configuration de l'interface DMZ dans pfSense — champs remplis avant de sauvegarder.
:::

**Tâche 2.4 — Vérifier les interfaces**

Allez dans **Interfaces → Overview**. Vous devez voir trois interfaces actives :

| Interface | IP | État |
|---|---|---|
| WAN (em0) | Adresse DHCP obtenue | up |
| LAN (em1) | 192.168.10.1 | up |
| DMZ (em2) | 10.0.50.1 | up |

::: tip 📸 Capture 3
Page Interfaces → Overview montrant les 3 interfaces actives avec leurs adresses IP.
:::

---

### Mission 3 — Configuration du serveur DHCP pour la DMZ

pfSense peut distribuer des adresses IP aux machines en DMZ, tout comme il le fait pour le LAN.

**Tâche 3.1 — Activer le DHCP sur l'interface DMZ**

Naviguez dans **Services → DHCP Server → DMZ** et configurez :

| Champ | Valeur |
|---|---|
| Enable | ✅ Coché |
| Range — From | `10.0.50.100` |
| Range — To | `10.0.50.200` |

Cliquez sur **Save**.

::: warning
Pour ce TP, VM-Serveur aura une **adresse IP statique** (10.0.50.10), pas DHCP. Le serveur DHCP DMZ est activé pour d'éventuelles futures machines, mais VM-Serveur sera configurée manuellement.
:::

---

### Mission 4 — Configuration de VM-Serveur (DMZ)

**Tâche 4.0 — Vérifier la connectivité DHCP initiale**

Démarrez VM-Serveur (Debian). Avant toute configuration manuelle, vérifiez que la machine obtient bien une adresse IP depuis le serveur DHCP de pfSense et qu'elle peut communiquer avec lui.

Vérifiez l'adresse obtenue :

```bash
ip a
```

Vous devriez voir une adresse dans la plage `10.0.50.100 – 10.0.50.200` sur votre interface réseau.

Testez la connectivité avec pfSense :

```bash
ping -c 3 10.0.50.1
```

::: tip 📸 Capture 4
Sortie de `ip a` et résultat du ping vers 10.0.50.1 — adresse DHCP obtenue et passerelle joignable.
:::

::: warning Si vous n'obtenez pas d'adresse DHCP
- Vérifiez que le serveur DHCP est bien activé sur l'interface DMZ dans pfSense (**Services → DHCP Server → DMZ**)
- Vérifiez que l'adaptateur réseau de VM-Serveur est bien en mode **Réseau interne** avec le nom `dmz`
- Relancez la demande DHCP manuellement : `systemctl restart networking`
:::

**Tâche 4.1 — Configurer l'adresse IP statique**

Le serveur web doit toujours être joignable à la même adresse — on passe donc en IP statique. Créez un fichier dédié dans `/etc/network/interfaces.d/` :

```bash
nano /etc/network/interfaces.d/customNetwork
```

Ajoutez-y le contenu suivant :

```bash
auto enp0s3
iface enp0s3 inet static
    address 10.0.50.10
    netmask 255.255.255.0
    gateway 10.0.50.1
    dns-nameservers 8.8.8.8
```

::: tip
`/etc/network/interfaces` ne doit pas être modifié directement — il est réservé à la configuration de base du système (`lo`). Les fichiers placés dans `/etc/network/interfaces.d/` sont automatiquement inclus.
:::

Appliquez la configuration :

```bash
systemctl restart networking
```

Vérifiez :

```bash
ip a
```

::: tip 📸 Capture 5
Sortie de `ip a` sur VM-Serveur montrant l'adresse 10.0.50.10/24.
:::

**Tâche 4.2 — Installer Apache2**

```bash
apt update && apt install apache2 -y
```

Modifiez la page d'accueil pour identifier clairement le serveur :

```bash
echo "<h1>Serveur InfoSecure — DMZ</h1><p>Accès autorisé depuis le LAN uniquement.</p>" > /var/www/html/index.html
```

Vérifiez qu'Apache tourne :

```bash
systemctl status apache2
```

::: tip 📸 Capture 6
Sortie de `systemctl status apache2` sur VM-Serveur — état `active (running)`.
:::

---

### Mission 5 — Configuration de VM-Client (LAN)

**Tâche 5.1 — Configurer l'adresse IP statique**

Sur VM-Client, configurez l'adresse IP statique `192.168.10.10/24` avec la passerelle `192.168.10.1` (même méthode que VM-Serveur).

**Tâche 5.2 — Tests de connectivité initiaux (avant les règles de pare-feu)**

Depuis VM-Client, effectuez les tests suivants et notez les résultats dans votre rapport :

```bash
# Test 1 — Passerelle LAN
ping -c 3 192.168.10.1

# Test 2 — Interface DMZ de pfSense
ping -c 3 10.0.50.1

# Test 3 — VM-Serveur
ping -c 3 10.0.50.10

# Test 4 — Internet
ping -c 3 8.8.8.8
```

::: info À ce stade
Par défaut, pfSense autorise tout le trafic sortant depuis le LAN. Les tests 1, 2, 3 et 4 devraient réussir. Le test 3 peut échouer si aucune règle par défaut n'existe encore sur l'interface DMZ — c'est normal, notez simplement le résultat.
:::

::: tip 📸 Capture 7
Résultats des 4 commandes ping depuis VM-Client (avant configuration des règles).
:::

**Tâche 5.3 — Test HTTP initial**

Ouvrez un navigateur sur VM-Client et accédez à `http://10.0.50.10`. Si la page Apache s'affiche, notez-le dans votre rapport.

::: tip 📸 Capture 8
Navigateur de VM-Client affichant (ou non) la page Apache de VM-Serveur — avant les règles.
:::

---

### Mission 6 — Mise en place des règles de pare-feu

::: warning Avant de commencer
Relisez attentivement la politique de sécurité définie plus haut. Dans pfSense, les règles sont lues **de haut en bas** — la première règle qui correspond au trafic est appliquée. L'ordre est donc primordial.
:::

::: info Règles existantes sur l'interface LAN
En ouvrant **Firewall → Rules → LAN**, vous constaterez que pfSense a déjà créé **3 règles** :

- **Anti-Lockout Rule** — règle spéciale qui garantit que vous ne pouvez jamais vous couper l'accès à l'interface web de pfSense depuis le LAN, même si vous créez des règles trop restrictives. Elle autorise toujours l'accès aux ports 80 et 443 de pfSense depuis le LAN. Elle ne peut pas être supprimée ici (elle se désactive uniquement dans **System → Advanced**).
- **Default allow LAN to any rule (IPv4)** — autorise tout le trafic IPv4 sortant depuis le LAN vers n'importe quelle destination.
- **Default allow LAN to any rule (IPv6)** — même chose pour IPv6.

Vos nouvelles règles devront être placées **au-dessus** de ces règles par défaut pour être évaluées en premier.
:::

#### Règles sur l'interface LAN

Naviguez dans **Firewall → Rules → LAN**.

**Tâche 6.1 — Règle 1 : Autoriser HTTP du LAN vers VM-Serveur**

Cliquez sur **Add ↑** (ajouter en haut de la liste) :

| Champ | Valeur |
|---|---|
| Action | Pass |
| Interface | LAN |
| Protocol | TCP |
| Source | LAN subnets |
| Destination | Single host — `10.0.50.10` |
| Destination Port | HTTP (80) |
| Description | `LAN → DMZ : HTTP autorisé` |

Sauvegardez.

**Tâche 6.2 — Règle 2 : Bloquer SSH du LAN vers la DMZ**

Ajoutez une règle **en dessous de la règle 1** (Add ↓ depuis la règle 1) :

| Champ | Valeur |
|---|---|
| Action | Block |
| Protocol | TCP |
| Source | LAN subnets |
| Destination | DMZ subnets (`10.0.50.0/24`) |
| Destination Port | SSH (22) |
| Description | `LAN → DMZ : SSH bloqué` |

**Tâche 6.3 — Règle 3 : Bloquer tout autre trafic LAN → DMZ**

| Champ | Valeur |
|---|---|
| Action | Block |
| Protocol | Any |
| Source | LAN subnets |
| Destination | DMZ subnets (`10.0.50.0/24`) |
| Description | `LAN → DMZ : tout autre trafic bloqué` |

::: tip
La règle 4 (PERMIT tout vers toutes destinations) est déjà couverte par la règle par défaut pfSense sur le LAN. Il n'est pas nécessaire de la recréer.
:::

Cliquez sur **Apply Changes**.

::: tip 📸 Capture 9
Liste des règles LAN dans pfSense — les 3 règles créées visibles dans l'ordre correct, au-dessus des règles par défaut.
:::

#### Règles sur l'interface DMZ

Naviguez dans **Firewall → Rules → DMZ**.

::: info
Par défaut, pfSense ne crée aucune règle sur les interfaces OPT (comme DMZ). Tout le trafic initié depuis la DMZ est donc **bloqué**. Vous allez créer uniquement les règles nécessaires.
:::

**Tâche 6.4 — Règle 5 : Bloquer explicitement DMZ → LAN**

| Champ | Valeur |
|---|---|
| Action | Block |
| Protocol | Any |
| Source | DMZ subnets (`10.0.50.0/24`) |
| Destination | LAN subnets (`192.168.10.0/24`) |
| Description | `DMZ → LAN : totalement bloqué` |

**Tâche 6.5 — Règle 6 : Autoriser DNS sortant depuis la DMZ**

| Champ | Valeur |
|---|---|
| Action | Pass |
| Protocol | UDP |
| Source | DMZ subnets |
| Destination | Any |
| Destination Port | DNS (53) |
| Description | `DMZ → WAN : DNS autorisé` |

**Tâche 6.6 — Règles 7a et 7b : Autoriser HTTP et HTTPS sortants**

Créez deux règles séparées (ou une seule avec un alias) :

| Champ | Règle 7a | Règle 7b |
|---|---|---|
| Action | Pass | Pass |
| Protocol | TCP | TCP |
| Source | DMZ subnets | DMZ subnets |
| Destination | Any | Any |
| Destination Port | HTTP (80) | HTTPS (443) |
| Description | `DMZ → WAN : HTTP` | `DMZ → WAN : HTTPS` |

**Tâche 6.7 — Règle 8 : Bloquer tout le reste depuis la DMZ**

| Champ | Valeur |
|---|---|
| Action | Block |
| Protocol | Any |
| Source | DMZ subnets |
| Destination | Any |
| Description | `DMZ : tout autre trafic bloqué` |

Cliquez sur **Apply Changes**.

::: tip 📸 Capture 10
Liste des règles DMZ dans pfSense — les 5 règles créées dans l'ordre correct.
:::

---

### Mission 7 — Tests de validation

Effectuez l'ensemble des tests ci-dessous depuis VM-Client et VM-Serveur et renseignez les résultats dans votre rapport.

#### Tests depuis VM-Client (LAN)

| # | Commande / Action | Résultat attendu |
|---|---|---|
| T1 | `curl http://10.0.50.10` | ✅ Page HTML renvoyée |
| T2 | Navigateur → `http://10.0.50.10` | ✅ Page Apache visible |
| T3 | `ssh user@10.0.50.10` | ❌ Connexion refusée / timeout |
| T4 | `ping 10.0.50.10` | ❌ Timeout (ICMP non autorisé) |
| T5 | `ping 8.8.8.8` | ✅ Succès (sortie Internet LAN) |
| T6 | `curl http://192.168.10.10` (ping LAN) | ✅ Succès (trafic LAN interne) |

#### Tests depuis VM-Serveur (DMZ)

| # | Commande / Action | Résultat attendu |
|---|---|---|
| T7 | `ping 192.168.10.10` | ❌ Timeout (DMZ → LAN bloqué) |
| T8 | `ping 192.168.10.1` | ❌ Timeout (DMZ → LAN bloqué) |
| T9 | `curl http://example.com` | ✅ Contenu renvoyé (HTTP autorisé) |
| T10 | `apt update` | ✅ Succès (DNS + HTTPS autorisés) |

::: warning Si T9 ou T10 échoue
Vérifiez que le **DNS Resolver** de pfSense est actif : **Services → DNS Resolver → Enable**. Vérifiez aussi que la règle DNS de la DMZ est bien au-dessus de la règle de blocage final.
:::

::: tip 📸 Capture 11
Résultat de T1 — sortie de `curl http://10.0.50.10` depuis VM-Client (HTML visible).
:::

::: tip 📸 Capture 12
Résultat de T2 — navigateur de VM-Client affichant la page du serveur DMZ.
:::

::: tip 📸 Capture 13
Résultat de T3 — tentative SSH depuis VM-Client vers VM-Serveur (connexion refusée).
:::

::: tip 📸 Capture 14
Résultat de T7 — ping depuis VM-Serveur vers VM-Client (timeout).
:::

::: tip 📸 Capture 15
Résultat de T10 — sortie de `apt update` sur VM-Serveur (téléchargement des dépôts réussi).
:::

---

### Mission 8 — Observation des logs du pare-feu

pfSense enregistre les connexions bloquées en temps réel.

**Tâche 8.1 — Consulter les logs de filtrage**

Naviguez dans **Status → System Logs → Firewall**.

Effectuez un ping depuis VM-Client vers VM-Serveur (T4) puis observez les logs.

::: tip 📸 Capture 16
Extrait des logs du pare-feu pfSense montrant un paquet ICMP bloqué en provenance de 192.168.10.10 vers 10.0.50.10.
:::

**Tâche 8.2 — Analyser une entrée de log**

Repérez une ligne de log correspondant à un paquet bloqué et identifiez dans votre rapport :
- L'interface concernée
- L'adresse IP source et destination
- Le protocole et le port
- L'action appliquée (block)

---

## Récapitulatif — Rapport annexe à rendre

::: danger À rendre
Votre rapport annexe doit contenir les **16 captures d'écran** listées ci-dessous, dans l'ordre, avec pour chaque capture une légende indiquant ce qu'elle montre.
:::

| N° | Contenu de la capture | Mission |
|---|---|---|
| 1 | Paramètres VirtualBox — 3 adaptateurs réseau de pfSense | 1 |
| 2 | Configuration de l'interface DMZ dans pfSense (avant Save) | 2 |
| 3 | Interfaces → Overview — 3 interfaces actives | 2 |
| 4 | `ip a` sur VM-Serveur — adresse DHCP obtenue | 4 |
| 5 | `ip a` sur VM-Serveur — adresse statique 10.0.50.10 | 4 |
| 6 | `systemctl status apache2` sur VM-Serveur | 4 |
| 7 | 4 pings depuis VM-Client (avant les règles) | 5 |
| 8 | Navigateur VM-Client vers VM-Serveur (avant les règles) | 5 |
| 9 | Liste des règles LAN dans pfSense | 6 |
| 10 | Liste des règles DMZ dans pfSense | 6 |
| 11 | T1 — `curl` HTTP depuis VM-Client vers VM-Serveur | 7 |
| 12 | T2 — Navigateur VM-Client affichant la page DMZ | 7 |
| 13 | T3 — SSH refusé depuis VM-Client | 7 |
| 14 | T7 — Ping refusé depuis VM-Serveur vers VM-Client | 7 |
| 15 | T10 — `apt update` réussi depuis VM-Serveur | 7 |
| 16 | Logs du pare-feu — paquet ICMP bloqué visible | 8 |

::: warning
Vérifiez que chaque capture montre clairement le résultat (fenêtres non coupées, texte lisible). Pour les captures CLI, faites défiler si nécessaire pour montrer l'intégralité du résultat.
:::

---

## Questions de synthèse

Répondez à ces questions dans votre rapport, **en vous basant sur ce que vous avez observé** durant le TP :

1. Quel est le rôle d'une DMZ dans une infrastructure réseau ? Pourquoi ne pas simplement placer le serveur dans le LAN ?
2. Expliquez pourquoi la règle **DMZ → LAN : bloqué** (règle 5) est la plus importante de ce TP du point de vue de la sécurité.
3. Que se passerait-il si un attaquant compromettait VM-Serveur ? Quelles zones seraient protégées grâce à votre configuration ?
4. Pourquoi avez-vous autorisé HTTP/HTTPS et DNS sortants depuis la DMZ, mais bloqué le reste ?
5. Donnez deux exemples concrets d'entreprises ou de services qui utiliseraient ce type d'architecture.

::: danger Rendu sur Moodle
Déposez votre rapport (PDF) avec l'ensemble des captures d'écran et les réponses aux questions de synthèse sur Moodle.
:::
