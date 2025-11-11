#!/usr/bin/env bash
set -euo pipefail
RESET_DB=false
PYTHON="python"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --reset-db) RESET_DB=true; shift ;;
    --python) PYTHON="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

echo "[1/6] Creating venv (if needed)..."
if [[ ! -d .venv ]]; then
  "$PYTHON" -m venv .venv
fi
source .venv/bin/activate

echo "[2/6] Upgrading pip and installing requirements..."
pip install --upgrade pip
pip install -r requirements.txt
if [[ -f setup.py ]]; then
  pip install -e .
fi

export FLASK_APP=./start.py

if [[ "$RESET_DB" == "true" || ! -f app/autman.db ]]; then
  [[ -f app/autman.db ]] && rm app/autman.db
  echo "[4/6] Initializing database (flask initdb)..."
  flask initdb
fi

echo "[5/6] Migrating passwords (flask migrate_passwords)..."
flask migrate_passwords || echo "Comando migrate_passwords indisponivel (ignorado)"

echo "[6/6] Starting app (http://localhost:5000) ..."
python start.py