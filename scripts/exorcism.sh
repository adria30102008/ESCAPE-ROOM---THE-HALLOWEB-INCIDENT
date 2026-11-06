#!/usr/bin/env bash
# Aïlla els serveis marcats com a crítics al CSV de l'Escape Room.
set -eu

directori_script="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
aplicar=0

case "${1:-}" in
    --help|-h)
        printf 'Ús: bash scripts/exorcism.sh [--apply] [fitxer.csv]\n'
        printf 'Per defecte mostra les regles. --apply les aplica amb nftables a Linux.\n'
        exit 0
        ;;
    --apply)
        aplicar=1
        shift
        ;;
esac

if [[ $# -gt 1 || "${1:-}" == -* ]]; then
    printf 'Ús: bash scripts/exorcism.sh [--apply] [fitxer.csv]\n' >&2
    exit 2
fi

csv="${1:-$directori_script/../data/ghost_hosts.csv}"
if [[ ! -f "$csv" || ! -r "$csv" ]]; then
    printf 'No es pot llegir el CSV: %s\n' "$csv" >&2
    exit 1
fi

# Llegim el CSV simple de la pràctica i validem les dades abans de tocar el tallafoc.
regles=$(awk -F, '
function error(missatge) {
    printf "Error al CSV (línia %d): %s\n", NR, missatge > "/dev/stderr"
    exit 1
}

function ipv4_valida(ip, parts, i) {
    if (split(ip, parts, /[.]/) != 4) return 0
    for (i = 1; i <= 4; i++) {
        if (parts[i] !~ /^(0|[1-9][0-9]?[0-9]?)$/ || parts[i] > 255) return 0
    }
    return 1
}

{ sub(/\r$/, "") }

NR == 1 {
    if ($0 != "ID,Hostname,IP,Tipus_Amenaca,Nivell_Risc,Port_Infectat")
        error("la capçalera no coincideix amb el contracte de dades")

    # Substituïm només la taula de la pràctica en una transacció.
    print "add table ip exorcism_lab"
    print "delete table ip exorcism_lab"
    print "add table ip exorcism_lab"
    print "add chain ip exorcism_lab entrada { type filter hook input priority 0; policy accept; }"
    print "add chain ip exorcism_lab sortida { type filter hook output priority 0; policy accept; }"
    next
}

/^[[:space:]]*$/ { next }

{
    if (NF != 6) error("s’esperaven sis columnes")
    if ($5 !~ /^(Baix|Mitja|Alt|Critic)$/) error("nivell de risc desconegut")
    if ($5 != "Critic") next
    if (!ipv4_valida($3)) error("adreça IPv4 invàlida")
    if ($6 !~ /^[0-9]+$/ || $6 < 1 || $6 > 65535) error("port invàlid")

    port = $6 + 0
    if (vist[$3, port]++) next

    # El port pertany al servei remot: és destí a la sortida i origen a l’entrada.
    printf "add rule ip exorcism_lab sortida ip daddr %s tcp dport %d drop\n", $3, port
    printf "add rule ip exorcism_lab sortida ip daddr %s udp dport %d drop\n", $3, port
    printf "add rule ip exorcism_lab entrada ip saddr %s tcp sport %d drop\n", $3, port
    printf "add rule ip exorcism_lab entrada ip saddr %s udp sport %d drop\n", $3, port
}

END { if (NR == 0) error("el fitxer està buit") }
' < "$csv") || exit 1

if [[ "$aplicar" == 0 ]]; then
    printf '# Simulació: regles que s’aplicarien al tallafoc.\n%s\n' "$regles"
    exit 0
fi

if ! command -v nft >/dev/null 2>&1; then
    printf 'El mode --apply requereix Linux amb nftables.\n' >&2
    exit 1
fi