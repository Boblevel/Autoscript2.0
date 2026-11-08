#!/usr/bin/env bash
# Binaire officiel Xray : archive épinglée et empreinte SHA-256 publiée.
installer_xray_verifie() {
    local version="v26.10.31" empreinte="e4bd9119f50ae7c41658b1abd0679ae06f98bd864a2907ff33f2f2cf7081b214"
    local tmp paquet
    command -v unzip >/dev/null || { echo '[ERREUR] unzip manquant'; return 1; }
    tmp=$(mktemp -d) || return 1
    paquet="$tmp/Xray-linux-64.zip"
    if ! curl -fL --retry 3 -o "$paquet" "https://github.com/XTLS/Xray-core/releases/download/${version}/Xray-linux-64.zip"; then
        rm -rf "$tmp"; return 1
    fi
    if ! printf '%s  %s\n' "$empreinte" "$paquet" | sha256sum -c -; then
        rm -rf "$tmp"; return 1
    fi
    if ! unzip -p "$paquet" xray > "$tmp/xray"; then
        rm -rf "$tmp"; return 1
    fi
    chmod 755 "$tmp/xray"
    "$tmp/xray" version >/dev/null || { rm -rf "$tmp"; return 1; }
    install -m 755 "$tmp/xray" /usr/local/bin/xray
    mkdir -p /usr/local/share/xray
    local donnees
    for donnees in geoip.dat geosite.dat; do
        if unzip -p "$paquet" "$donnees" > "$tmp/$donnees" 2>/dev/null && [ -s "$tmp/$donnees" ]; then
            install -m 644 "$tmp/$donnees" "/usr/local/share/xray/$donnees"
        fi
    done
    rm -rf "$tmp"
    [ -x /usr/local/bin/xray ] || { echo '[ERREUR] Exécutable Xray absent.'; return 1; }
    echo '[OK] Xray officiel installé et vérifié.'
}
