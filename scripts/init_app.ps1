Param(
  [switch]$ResetDb = $false,
  [string]$Python = "python"
)
$ErrorActionPreference = "Stop"

Write-Host "[1/6] Creating venv (if needed)..."
if (!(Test-Path .venv)) {
  & $Python -m venv .venv
}
$venvPy = Join-Path ".venv" "Scripts\python.exe"

Write-Host "[2/6] Upgrading pip and installing requirements..."
& $venvPy -m pip install --upgrade pip
& $venvPy -m pip install -r requirements.txt
# Editable install for local package (optional)
if (Test-Path setup.py) { & $venvPy -m pip install -e . }

Write-Host "[3/6] Setting FLASK_APP..."
$env:FLASK_APP = "./start.py"

if ($ResetDb -or -not (Test-Path "app/autman.db")) {
  if (Test-Path "app/autman.db") { Remove-Item "app/autman.db" -Force }
  Write-Host "[4/6] Initializing database (flask initdb)..."
  & $venvPy -m flask initdb
}

Write-Host "[5/6] Migrating passwords (flask migrate_passwords)..."
& $venvPy -m flask migrate_passwords

Write-Host "[6/6] Starting app on http://localhost:5000 ..."
Start-Process "http://localhost:5000"
& $venvPy start.py