# Dashboard de monitoratge

## Hosts infectats

| Host | IP | Amenaça | Risc | Port infectat | Estat |
|---|---|---|---|---|---|
| phantom-server | 192.0.2.10 | Accés no autoritzat | Alt | 22 | Pendent |
| specter-web | 192.0.2.20 | Webshell | Crític | 443 | Pendent |
| haunted-db | 192.0.2.30 | Exfiltració de dades | Crític | 3306 | Pendent |
| ghost-desktop | 192.0.2.40 | Força bruta | Alt | 3389 | Pendent |
| shadow-ftp | 192.0.2.50 | Robatori de credencials | Alt | 21 | Pendent |
| cursed-printer | 192.0.2.60 | Activitat sospitosa | Baix | 9100 | Pendent |
| poltergeist-dev | 192.0.2.70 | Servei desconegut | Mitjà | 8080 | Pendent |
| nightmare-dns | 192.0.2.80 | Manipulació DNS | Crític | 53 | Pendent |

## Resum

- Total: 8 hosts.
- Risc crític: 3 hosts.
- Risc alt: 3 hosts.
- Risc mitjà: 1 host.
- Risc baix: 1 host.

## Comprovacions

- [x] Identificar els hosts i els ports infectats.
- [x] Identificar els hosts de risc crític.
- [ ] Comprovar si l'script de l'Agent 2 filtra els ports no crítics.
- [ ] Verificar si els hosts infectats han estat aïllats.