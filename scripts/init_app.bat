@echo off
setlocal

rem Go to repo root (this file lives in scripts\)
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%.."

echo [0/7] Working dir: %CD%"

set "PYTHON=python"
set "VENV_PY=.venv\Scripts\python.exe"
set "RESET=0"

rem Parse args
if /I "%~1"=="--reset-db" set RESET=1

if not exist "%VENV_PY%" (
  echo [1/7] Creating venv
  %PYTHON% -m venv .venv
  if errorlevel 1 goto :error
)

echo [2/7] Upgrade pip
"%VENV_PY%" -m pip install --upgrade pip
if errorlevel 1 goto :error

echo [3/7] Install requirements
"%VENV_PY%" -m pip install -r requirements.txt
if errorlevel 1 goto :error

if exist setup.py (
  echo [3b/7] Editable install
  "%VENV_PY%" -m pip install -e .
)

echo [4/7] Set FLASK_APP
set "FLASK_APP=.\start.py"

if "%RESET%"=="1" (
  echo [5/7] Resetting database
  if exist app\autman.db cmd /c del /f /q app\autman.db 2>nul
)

echo [5b/7] Initialize database if missing
if not exist app\autman.db (
  "%VENV_PY%" -m flask initdb
  if errorlevel 1 goto :error
)

echo [6/7] Migrate passwords
"%VENV_PY%" -m flask migrate_passwords

echo [7/7] Start app at http://localhost:5000
start "" http://localhost:5000
"%VENV_PY%" start.py

endlocal
goto :eof

:error
echo Failed with errorlevel %errorlevel%.
endlocal
exit /b 1
