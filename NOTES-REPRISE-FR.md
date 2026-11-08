# AutoScript VIP — version de travail française

## Statut

**Version de travail non validée sur VPS. Ne pas déployer en production.**
La présence de commandes fonctionnelles ne prouve pas la compatibilité d'une image fournisseur.

## Changements ciblés

- Pré-vérification Ubuntu 20.04/22.04/24.04/26.04 et Debian 11/12/13 (amd64 uniquement). Versions non testées en réel : statut expérimental.
- Xray : archive officielle épinglée, vérification SHA-256 et vérification d'exécution ; permissions du journal réparées.
- SlowDNS : destination DNSTT mise sur SSH :22 ; conservation des clés existantes lors d'une relance.
- Suppression numérotée confirmée par `o` pour SSH, VLESS, VMess, Trojan, Shadowsocks ; sauvegarde Xray avant suppression.
- Traduction française de la navigation principale et des sous-menus principaux, plus des messages courants.
- Menus terminal visuellement réorganisés et pictogrammes.
- Suppression des nettoyages sauvages de `/root/*.sh`, du redémarrage automatique quotidien et de l'upgrade système imposé.

## Points restant à valider ou adapter

1. Les binaires fournis (DNSTT, NoobzVPN, UDP, WS) sont disponibles seulement pour x86_64 et ne sont pas vérifiés contre une source de confiance.
2. Les scripts hérités imposent des configurations Nginx, HAProxy, SSH, OpenVPN et pare-feu potentiellement incompatibles avec certains fournisseurs.
3. Une partie des dépendances `apt` diffère selon Debian/Ubuntu. La pré-vérification d'OS ne vaut pas certification de compatibilité.
4. Le mode numéroté de suppression NoobzVPN dépend de son format de sortie utilisateur non fourni ; l'ancien comportement est conservé.
5. SlowDNS requiert une délégation NS fonctionnelle, un UDP 53 accessible et un compte SSH valide.
6. Les scripts de menus secondaires restent partiellement multilingues. Traduction complète à faire après tests unitaires.
7. L'installateur du projet d'origine ne possède pas encore de vraie reprise atomique par étape.
8. Aucun test de service réel n'a été effectué dans cet environnement isolé.
9. Le dépôt d'origine n'affiche pas de licence de redistribution : obtenir l'autorisation de l'auteur avant de publier un fork dérivé.

## Vérifications de lecture seule recommandées avant chaque essai

```bash
cat /etc/os-release
uname -m
systemd-detect-virt
ss -lntup
systemctl is-active ssh nginx haproxy xray server.service
```

## Vérifications fonctionnelles pour un VPS de test *vierge*

- Installation sur Ubuntu 22.04, Ubuntu 24.04, Debian 12 puis Debian 13 (une image par essai).
- Création/import d'un vrai VLESS WS TLS et connexion Internet effective.
- DNS public et service DNSTT UDP 53, puis connexion SSH via SlowDNS.
- Création de deux comptes par protocole, suppression uniquement du numéro sélectionné, annulation avec `n`, vérification du compte restant.
- Sauvegarde/restauration, réinstallation contrôlée et interruption/reprise.
- Tests de non-régression de SSH, pare-feu, accès VPS et redémarrage.

**Ne pas publier cette archive telle quelle : droits amont non éclaircis et composants binaires non audités.**
