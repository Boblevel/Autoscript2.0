#!/usr/bin/env bash
# Saisie numérotée, validation stricte et confirmation. Aucun effet secondaire.
# Utilisation : choisir_compte protocole ; définit user et exp à la sortie.
choisir_compte() {
    local protocole="${1:?protocole requis}" source marque titre
    local reponse confirmation entree nom fin
    local -a liste=() dates=()
    case "$protocole" in
        ssh) source=/etc/ssh/.ssh.db; marque='#ssh#'; titre=SSH ;;
        vless) source=/etc/xray/config.json; marque='#&'; titre=VLESS ;;
        vmess) source=/etc/xray/config.json; marque='###'; titre=VMess ;;
        trojan) source=/etc/xray/config.json; marque='#!'; titre=Trojan ;;
        shadowsocks) source=/etc/xray/config.json; marque='#!#'; titre=Shadowsocks ;;
        *) echo 'Protocole inconnu.' >&2; return 1 ;;
    esac
    [ -r "$source" ] || { printf 'Fichier de comptes absent : %s\n' "$source" >&2; return 1; }
    while IFS=$'\t' read -r nom fin; do
        # Aucune interpolation d'un nom non validé dans les commandes de suppression.
        [[ "$nom" =~ ^[a-zA-Z0-9_][a-zA-Z0-9_-]*$ ]] || continue
        if [ "$protocole" != ssh ] && [[ ! "$fin" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then continue; fi
        # Les comptes SSH figurent uniquement dans la base de comptes VPN.
        if [ "$protocole" = ssh ]; then
            [ "$nom" != root ] && [ "$nom" != ubuntu ] && [ "$nom" != debian ] || continue
            getent passwd "$nom" >/dev/null || continue
            local compte_uid
            compte_uid=$(id -u "$nom" 2>/dev/null) || continue
            [ "$compte_uid" -ge 1000 ] || continue
        fi
        # Éliminer les doublons sans exécuter les champs de base de données.
        local present=0 item
        for item in "${liste[@]}"; do [ "$item" = "$nom" ] && present=1 && break; done
        [ "$present" -eq 0 ] || continue
        liste+=("$nom"); dates+=("$fin")
    done < <(awk -v m="$marque" -v p="$protocole" '$1==m {if(p=="ssh") print $2 "\t[compte SSH]"; else print $2 "\t" $3}' "$source")
    if [ "${#liste[@]}" -eq 0 ]; then
        echo "Aucun compte $titre à supprimer."
        return 1
    fi
    printf '\n┌──────────────────────────────────────────────┐\n'
    printf '│ 🗑  SUPPRESSION D’UN COMPTE %-16s │\n' "$titre"
    printf '└──────────────────────────────────────────────┘\n'
    local i
    for ((i=0;i<${#liste[@]};i++)); do
        printf '  %2d) %-22s %s\n' "$((i+1))" "${liste[i]}" "${dates[i]}"
    done
    printf '   0) Annuler\n'
    read -r -p 'Numéro du compte : ' reponse || return 1
    [[ "$reponse" =~ ^[0-9]+$ ]] || { echo 'Numéro invalide.'; return 1; }
    [ "${#reponse}" -le 6 ] || { echo "Numéro invalide."; return 1; }
    reponse=$((10#$reponse))
    [ "$reponse" -gt 0 ] && [ "$reponse" -le "${#liste[@]}" ] || { echo 'Suppression annulée.'; return 1; }
    user="${liste[reponse-1]}"; exp="${dates[reponse-1]}"
    printf 'Compte sélectionné : %s (%s)\n' "$user" "$titre"
    read -r -p 'Confirmer la suppression ? [o/N] : ' confirmation || return 1
    [ "$confirmation" = o ] || [ "$confirmation" = O ] || { echo 'Suppression annulée.'; return 1; }
    return 0
}
