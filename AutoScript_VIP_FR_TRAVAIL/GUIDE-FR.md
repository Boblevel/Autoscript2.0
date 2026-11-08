# AutoScript VPN Multiport — édition française (travail)

> **Version expérimentale.** Cette archive est une base de développement privée,
> ni un outil certifié compatible avec tout hébergeur, ni un installateur à déployer chez des clients.

## Objectif

Gestion via terminal SSH sans panel web : comptes SSH, VLESS, VMess, Trojan,
Shadowsocks, SlowDNS, UDP et OpenVPN selon les composants historiques disponibles.

## Menu

Lancer `menu` après installation. Menus principaux traduits en français,
pictogrammes par option. Dans les protocoles SSH, VLESS, VMess, Trojan et
Shadowsocks, la suppression affiche les comptes avec un numéro, demande
un numéro puis une confirmation explicite `o` (tout autre choix annule).

## Installer sur un VPS de test vierge

Utiliser Ubuntu 22.04 ou 24.04 x86_64 comme premiers essais.
Après extraction du ZIP :

```bash
cd AutoScript_VIP_FR_TRAVAIL
sudo bash setup.sh
```

**Ne pas lancer cette version sur le VPS de production.** Le script historique
effectue des modifications lourdes à SSH, au réseau, à Nginx et à HAProxy.
Il est nécessaire de garder un accès console de secours et un snapshot VPS.

Ubuntu 20.04/26.04 et Debian 11/12/13 sont détectés au pré-diagnostic,
mais **leur fonctionnement n'a pas été validé**. Le projet contient des
binaires `amd64` tiers non audités ; ARM64 n'est pas pris en charge.

## Correctifs

- Xray téléchargé en archive depuis la publication officielle, SHA-256 vérifié.
- Permissions des journaux Xray corrigées pour `www-data`.
- SlowDNS DNSTT redirigé vers `127.0.0.1:22` (SSH direct).
- Prévention de la suppression globale des fichiers `root` et des comptes existants.
- Redémarrage quotidien non programmé automatiquement.
- Suppression numérotée et confirmée, sauvegarde avant modification des profils Xray.
- Mise à jour des menus depuis une copie locale, pas depuis un dépôt tiers.

## Domaine SlowDNS

Si le domaine VPN est `example.com` :

```text
A   ns1.example.com  -> IP publique du VPS
NS  dns.example.com  -> ns1.example.com
```

Le port UDP 53 doit être joignable. Valider les DNS publics avant d'essayer DNSTT.
La création d'un compte SSH ne fournit aucun DNS gratuitement sans délégation.

## Limites et risques

**La distribution publique du projet en tant que fork est suspendue** : le dépôt
amont ne déclare aucune licence de redistribution. Les droits et les binaires
devront être clarifiés avec l'auteur original avant publication.

Les sous-menus secondaires restent partiellement non traduits ; les binaires tiers
restent non audités ; il faut des tests d'intégration sur chaque version Debian/Ubuntu.
La reprise d'une installation interrompue n'est pas encore automatisée.

Lire aussi `NOTES-REPRISE-FR.md` avant tout test.
