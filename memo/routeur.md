# 📌 MÉMO – Commandes indispensables sur un routeur Cisco

## 1. Configuration de base
Passer en mode privilégié
```bash
enable
```
Mode de configuration globale
```bash
configure terminal
```
Nom du routeur
```bash
hostname R1
```
Désactiver la recherche DNS (évite les pauses quand on tape mal une commande)
```bash
no ip domain-lookup
```

Sauvegarder la configuration
```bash
copy running-config startup-config
```
## 2. Configurer les interfaces
Configurer une interface physique
```bash
interface GigabitEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
```
## 3. Configuration VLAN & 802.1Q (trunk)
Créer des sous-interfaces pour router-on-a-stick
```bash
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0

interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
```

## 4. Configuration d’un serveur DHCP
Créer un pool DHCP
```bash
ip dhcp pool VLAN10
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 8.8.8.8
```
Exclure des adresses
```bash
ip dhcp excluded-address 192.168.10.1 192.168.10.20
```

## 5. Configuration du serveur NTP
Mettre en place le serveur NTP
```bash
ntp master 1
```
Il ne vous reste plus qu'à configurer les clients.

## 6. Configuration NAT/PAT (NAT Overload)
Déclarer les interfaces inside/outside
```bash
interface GigabitEthernet0/0 # interface d'entrée (coté LAN)
 ip nat inside

interface GigabitEthernet0/1 # interface de sortie (coté WAN)
 ip nat outside
```

Création d'une ACL sur le routeur et autorisation d'un réseau a exploiter cette ACL
```bash
ip access-list standard NAT_INTERNET_VLAN2
permit 192.168.2.0 0.0.0.255 #Le masque est inversé (0.0.0.255 = 255.255.255.0)
```
Ensuite, vous indiquez que l’interface de votre VLAN 2 est en entrée du NAT (à répéter pour chaque VLAN).
```bash
ip nat inside source list NAT_INTERNET_VLAN2 interface GigabitEthernet0/1 overload
```
Cette commande applique à l’interface WAN, le groupe que vous avez créé au début. Vous autorisez donc le VLAN 2 à utiliser le NAT en sortie sur l’interface WAN.



## 7. Port forwarding (Static NAT / PAT)
Exemple : rendre un serveur Web interne accessible (port 80)

Serveur interne : `192.168.10.50`
IP publique du routeur : `203.0.113.1`
```bash
ip nat inside source static tcp 192.168.10.50 80 203.0.113.1 80
```
Autre exemple : SSH
```bash
ip nat inside source static tcp 192.168.10.50 22 203.0.113.1 22
```
## 8. Routage
Route statique vers un réseau
```bash
# ip route | réseau | masque | passerelle
ip route 192.168.50.0 255.255.255.0 192.168.10.254
```
Route par défaut
```bash
ip route 0.0.0.0 0.0.0.0 203.0.113.254
```

## 9. Mise en place du protocole OSPF

Les commandes de bases pour la mise en place d'OSPF sur un routeur.
``` bash
router ospf 1                              # Démarrer le processus OSPF
network 192.168.1.0 0.0.0.255 area 0       # Déclarer un réseau (Masque inversé)
router-id 1.1.1.1                          # Forcer l'ID de routeur
passive-interface GigabitEthernet0/0       # Interface passive (LAN)
auto-cost reference-bandwidth 10000        # Changer la bande passante de référence
clear ip ospf process                      # Redémarrer OSPF (pour appliquer router-id)
```

Vérification OSPF 

```bash
show ip ospf neighbor                     # Voisins OSPF
show ip ospf                              # Processus, Router-ID, timers
show ip ospf interface                    # Détails OSPF par interface
show ip ospf interface brief              # Résumé avec coûts (tableau)
show ip ospf database                     # Base LSDB
```

Vérifications de routage 

```bash
show ip route                             # Table de routage complète
show ip route ospf                        # Routes apprises via OSPF uniquement
```

## 10. Commandes de vérification indispensables
Interfaces
```bash
show ip interface brief
show interfaces
```

DHCP
```bash
show ip dhcp binding
show ip dhcp pool
```

NAT
```bash
show ip nat translations
show ip nat statistics
```

Routage
```bash
show ip route
```

NTP
```bash
show ntp status
show ntp associations
```

Vérifier une interface / sous-interface
```bash
show running-config interface GigabitEthernet0/0.10
```

🔍 Vérifier le trunk 802.1Q
```bash
show interfaces trunk    (sur le switch)
show interfaces g0/0.10  (sur le routeur)
```
## 11. Dépannage rapide (troubleshooting)
Pings
```bash
ping 192.168.10.1
```
Traceroute
```bash
traceroute 8.8.8.8
```
Vérifier la table ARP
```bash
show ip arp
```