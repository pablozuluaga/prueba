#!/usr/bin/env bash
# Levanta un Postgres temporal, aplica stub + migraciones + seed y corre las pruebas.
set -euo pipefail
cd "$(dirname "$0")/.."
BIN=$(ls -d /usr/lib/postgresql/*/bin | tail -1)
DIR=$(mktemp -d)
trap '"$BIN/pg_ctl" -D "$DIR/data" stop -m immediate >/dev/null 2>&1 || true; rm -rf "$DIR"' EXIT
chmod 777 "$DIR"
run() { if [ "$(id -u)" = 0 ]; then su postgres -s /bin/bash -c "$*"; else bash -c "$*"; fi; }
run "'$BIN/initdb' -D '$DIR/data' -A trust >/dev/null"
run "'$BIN/pg_ctl' -D '$DIR/data' -o '-k $DIR -p 54329 -c listen_addresses= -c wal_level=logical' -l '$DIR/log' start -w >/dev/null"
PSQL="psql -h $DIR -p 54329 -U postgres -d postgres -v ON_ERROR_STOP=1 -q"
$PSQL -f pruebas/stub_supabase.sql
for f in supabase/migrations/*.sql; do $PSQL -f "$f"; done
$PSQL -f supabase/seed.sql
$PSQL -f pruebas/pruebas.sql 2>&1 | sed 's/^psql:[^:]*:[0-9]*: //'
