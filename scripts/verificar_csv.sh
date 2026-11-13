#!/bin/bash

# Verifica el contracte de dades abans d'executar l'script d'aïllament.

CSV="${1:-data/ghost_hosts.csv}"
CAPCALERA="ID,Hostname,IP,Tipus_Amenaca,Nivell_Risc,Port_Infectat"

if [ ! -f "$CSV" ]; then
    echo "ERROR: No s'ha trobat el fitxer $CSV"
    exit 1
fi

if [ "$(head -n 1 "$CSV")" != "$CAPCALERA" ]; then
    echo "ERROR: La capçalera del CSV no coincideix amb el contracte de dades."
    exit 1
fi

echo "CSV verificat correctament."
echo "Amenaces crítiques detectades:"

awk -F',' '
NR > 1 && $5 == "Critic" {
    printf "- %s | IP: %s | Port: %s | Amenaça: %s\n", $2, $3, $6, $4
    total++
}
END {
    if (total == 0) {
        print "No s’han trobat amenaces crítiques."
    } else {
        printf "Total d’amenaces crítiques: %d\n", total
    }
}
' "$CSV"