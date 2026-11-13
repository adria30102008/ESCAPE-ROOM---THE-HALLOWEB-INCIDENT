# Contracte de dades de `ghost_hosts.csv`

L’Agent 1 manté l’inventari d’amenaces a `data/ghost_hosts.csv`. L’Agent 2 fa servir aquest contracte per llegir l’inventari amb `scripts/exorcism.ps1`.

El fitxer es desa en UTF-8, amb camps separats per comes. La primera fila conté la capçalera i cada fila següent descriu una amenaça. Cal respectar els noms exactes de les columnes.

| Columna | Contingut |
| --- | --- |
| `ID` | Identificador numèric únic de la fila. |
| `Hostname` | Nom de l’equip afectat. |
| `IP` | Adreça IP de l’equip. Les dades de prova fan servir adreces de documentació. |
| `Tipus_Amenaca` | Categoria de l’amenaça, com ara `Webshell`. |
| `Nivell_Risc` | Valoració de l’amenaça: `Baix`, `Mitja`, `Alt` o `Critic`. |
| `Port_Infectat` | Port afectat, amb un valor enter entre `1` i `65535`. S’incorpora com a camp obligatori a la fase 2. |

## Capçalera de la fase 1

```csv
ID,Hostname,IP,Tipus_Amenaca,Nivell_Risc
```

## Exemple de la fase 2

```csv
ID,Hostname,IP,Tipus_Amenaca,Nivell_Risc,Port_Infectat
2,specter-web,192.0.2.20,Webshell,Critic,443
6,cursed-printer,192.0.2.60,Activitat_sospitosa,Baix,9100
```

Per a l’exercici es proposen els ports crítics `21`, `22`, `53`, `443`, `3306` i `3389`. Si l’equip confirma aquesta llista, l’script ha de seleccionar la fila amb el port `443` i descartar la del `9100` en l’exemple. El filtre es basa en `Port_Infectat`.

A la fase 2, els dos agents actualitzen el CSV i l’script a `hotfix/protocol-update` i verifiquen conjuntament que el nou camp es llegeix i es filtra correctament.
