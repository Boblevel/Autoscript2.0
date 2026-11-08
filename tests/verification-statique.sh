#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
echo '[1/3] Syntaxe Bash'
for f in setup.sh slowdns/nameserver lib/*.sh menu/*; do
  [ -f "$f" ] || continue
  bash -n "$f"
done
echo '[2/3] Intégrité des références'
for f in lib/selection-compte.sh lib/preflight.sh lib/xray-fiable.sh slowdns/server media/config.json; do
  [ -s "$f" ] || { echo "Manquant : $f"; exit 1; }
done
echo '[3/3] Contrôle des défauts historiques'
! grep -q 'ExecStart=/etc/slowdns/dnstt-server.*127.0.0.1:443' slowdns/server
! grep -q '^rm -rf /root/\\*\.sh' setup.sh
! grep -q '^0 5 \* \* \* root /sbin/reboot' setup.sh
printf '[OK] Contrôles statiques terminés. Pas de test VPS effectué.\n'
