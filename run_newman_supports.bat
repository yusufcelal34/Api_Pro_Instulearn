@echo off
setlocal enabledelayedexpansion

REM ----------------------------------------------
REM Run all Postman *.postman_collection.json files
REM under src\test\java\PostmanCollections (recursively)
REM Generate HTML+JSON reports to src\test\java\newman-reports
REM ----------------------------------------------

REM Go to repo root (this script should be placed anywhere; we cd to project root by probing)
REM If you keep this script in project root, comment out next two lines.
cd /d "%~dp0"
for %%I in (.) do set CURRENTDIR=%%~nxI

set COLL_DIR=src\test\java\PostmanCollections
set REPORT_DIR=src\test\java\newman-reports

if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

REM Try to detect an environment file (optional). Prefer *qa.postman_environment.json then any *.postman_environment.json
set ENV_FILE=
for /f "delims=" %%E in ('dir /b "%COLL_DIR%\*qa.postman_environment.json" 2^>nul') do set ENV_FILE=%COLL_DIR%\%%E
if "%ENV_FILE%"=="" (
  for /f "delims=" %%E in ('dir /s /b "%COLL_DIR%\*.postman_environment.json" 2^>nul') do (
    if "%%~aE" NEQ "" (
      set ENV_FILE=%%E
      goto :ENV_FOUND
    )
  )
)
:ENV_FOUND

echo.
echo ==============================================
echo Running Newman for collections under: %COLL_DIR%
if not "%ENV_FILE%"=="" (
  echo Using environment: %ENV_FILE%
) else (
  echo No environment file found. Running without -e.
)
echo Reports: %REPORT_DIR%
echo ==============================================
echo.

REM Loop collections recursively
for /r "%COLL_DIR%" %%F in (*.postman_collection.json) do (
  set "COLL=%%F"
  for %%~nF in ("%%F") do set NAME=%%~nF

  echo ---- Running: !COLL!
  if not "%ENV_FILE%"=="" (
    npx newman run "!COLL!" -e "%ENV_FILE%" -r cli,html,json --reporter-html-export "%REPORT_DIR%\!NAME!.html" --reporter-json-export "%REPORT_DIR%\!NAME!.json"
  ) else (
    npx newman run "!COLL!" -r cli,html,json --reporter-html-export "%REPORT_DIR%\!NAME!.html" --reporter-json-export "%REPORT_DIR%\!NAME!.json"
  )
  echo.
)

echo All done. Open HTML reports from: %REPORT_DIR%
pause
endlocal
