#!/usr/bin/env bash
# Contrôles avant installation ; aucun changement système.
preflight_autoscript() {
    local version major
    . /etc/os-release
    case "${ID:-}" in
        ubuntu)
            case "${VERSION_ID:-}" in
                20.04|22.04|24.04|26.04) ;;
                *) echo "[ERREUR] Version Ubuntu non validée : ${VERSION_ID:-inconnue}" >&2; return 1 ;;
            esac ;;
        debian)
            case "${VERSION_ID:-}" in
                11|12|13) ;;
                *) echo "[ERREUR] Version Debian non validée : ${VERSION_ID:-inconnue}" >&2; return 1 ;;
            esac ;;
        *) echo "[ERREUR] Ubuntu ou Debian requis." >&2; return 1 ;;
    esac
    if [ "$(uname -m)" != x86_64 ]; then
        echo '[ERREUR] Modules propriétaires du dépôt disponibles uniquement en x86_64.' >&2
        return 1
    fi
    command -v systemctl >/dev/null || { echo '[ERREUR] systemd requis.' >&2; return 1; }
    [ -d /run/systemd/system ] || { echo '[ERREUR] systemd non actif.' >&2; return 1; }
    [ "${EUID}" -eq 0 ] || { echo '[ERREUR] Droits root requis.' >&2; return 1; }
    echo "[INFO] Système détecté : ${PRETTY_NAME} / $(uname -m)"
    echo '[INFO] Compatibilité préliminaire uniquement : tests VPS réels nécessaires.'
    # Préserver les comptes, services et pare-feu déjà installés.
    if [ -s /etc/xray/config.json ]; then
       echo '[ERREUR] Configuration Xray existante. Installation non vierge : arrêt de sécurité.' >&2
       return 1
    fi
}
