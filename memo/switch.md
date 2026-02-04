# 📌 MÉMO – Commandes indispensables sur un switch Cisco

## 1. Commandes de base
| Tâche                                | Commande                             |
| ------------------------------------ | ------------------------------------ |
| Passer en mode privilégié            | `enable`                             |
| Passer en mode configuration globale | `configure terminal`                 |
| Sauvegarder la configuration         | `copy running-config startup-config` |
| Charger configuration sauvegardée    | `copy startup-config running-config` |
| Voir la configuration en cours       | `show running-config`                |
| Voir la configuration sauvegardée    | `show startup-config`                |
| Redémarrer le switch                 | `reload`                             |


## 2. Gestion des interfaces

| Tâche                              | Commande                  |
| ---------------------------------- | ------------------------- |
| Lister les interfaces et leur état | `show ip interface brief` |
| Voir les détails d’une interface   | `show interfaces fa0/1`   |
| Entrer dans l’interface            | `interface fa0/1`         |
| Sélectionner une plage d’interfaces | `interface range fa 0/1 - 10`         |
| Activer une interface              | `no shutdown`             |
| Désactiver une interface           | `shutdown`                |
| Vérifier les erreurs sur ports     | `show interfaces status`  |


## 3. VLAN
Création / suppression
``` bash
vlan 10
 name UTILISATEURS
exit

no vlan 10
```

Afficher les VLAN
``` bash
show vlan brief
```
Ajouter un port dans un VLAN
``` bash
interface fa0/5
 switchport mode access
 switchport access vlan 10
exit
```

Vérifier l’appartenance des ports
``` bash
show interfaces switchport
```
## 4. Trunking (802.1Q)
Configurer un trunk
``` bash
interface gi0/1
 switchport trunk encapsulation dot1q
 switchport mode trunk
```

Autoriser certains VLAN
``` bash
switchport trunk allowed vlan 10,20,30
```

Voir les trunks actifs
``` bash
show interfaces trunk
```

## 5. Spanning Tree Protocol (STP)
| Tâche                             | Commande                              |
| --------------------------------- | ------------------------------------- |
| Voir l’état spanning-tree         | `show spanning-tree`                  |
| Changer la priorité STP d’un VLAN | `spanning-tree vlan 10 priority 4096` |
| Activer PortFast sur un port      | `spanning-tree portfast`              |
| Activer BPDU Guard                | `spanning-tree bpduguard enable`      |

## 6. Adresse IP de management

Sur un switch L2, l’adresse IP se configure sur l’interface VLAN (SVI - Switched Virtual Interface) :

``` bash
interface vlan 99
 ip address 192.168.99.2 255.255.255.0
 no shutdown
exit
```

Voir l’IP :
``` bash
show ip interface brief
```

## 7. Sécurisation de ports (Port Security)
Activer Port Security
``` bash
interface fa0/10
 switchport mode access
 switchport port-security
```

Limiter le nombre d’adresses MAC
``` bash
switchport port-security maximum 2
```

Sauvegarder automatiquement la MAC
``` bash
switchport port-security mac-address sticky
```

Mode de violation
``` bash
switchport port-security violation restrict
```
Voir l’état de Port Security

``` bash
show port-security
show port-security interface fa0/10
```

## 8. Table MAC
| Tâche                | Commande                          |
| -------------------- | --------------------------------- |
| Voir la table MAC    | `show mac address-table`          |
| Effacer la table MAC | `clear mac address-table dynamic` |

## 9. NTP (sur un switch administré)
| Tâche                     | Commande                  |
| ------------------------- | ------------------------- |
| Configurer un serveur NTP | `ntp server 192.168.99.1` |
| Voir les associations     | `show ntp associations`   |
| Voir l’état NTP           | `show ntp status`         |
| Vérifier la source de l’horloge        | `show clock detail`         |

