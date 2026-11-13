# Prova de simulació de l’aïllament

**Responsable:** Isaac — Agent 2

## Objectiu
Comprovar que el script selecciona les amenaces de risc crític.

## Prova realitzada
He executat `bash scripts/exorcism.sh` en mode simulació.

## Resultat observat
S’han generat regles per als serveis següents:

- specter-web — 192.0.2.20 — port 443.
- haunted-db — 192.0.2.30 — port 3306.
- nightmare-dns — 192.0.2.80 — port 53.

Les amenaces amb risc Alt, Mitja o Baix han quedat descartades.
