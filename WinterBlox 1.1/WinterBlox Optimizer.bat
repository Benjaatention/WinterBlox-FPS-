@echo off
chcp 65001 >nul
color 0B
setlocal enabledelayedexpansion

:: ===== LOGO =====
echo.
echo                 *         *         *
echo            *         *         *         *
echo        *      *       *       *      *
echo             \    *    ❄    *    /
echo.
echo      ██╗    ██╗██╗███╗   ██╗████████╗███████╗██████╗ 
echo      ██║    ██║██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
echo      ██║ █╗ ██║██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
echo      ██║███╗██║██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
echo      ╚███╔███╔╝██║██║ ╚████║   ██║   ███████╗██║  ██║
echo       ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
echo.
echo          WinterBlox Optimizer (Benjaatention) ❄             
echo                           1.1
echo.

:: ===== AUTO ADMIN =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb runAs"
    exit
)

:: ===== IR A CARPETA DATA =====
cd /d "%~dp0data"

:: ===== CONFIG =====
set EXE=RobloxPlayerBeta.exe
set GAME=Roblox

title WinterBlox Optimizer 1.0
echo WinterBlox esta Esperando a que abras %GAME%...

:: ===== ESPERAR INICIO =====
:WAIT_START
tasklist | find /i "%EXE%" >nul
if errorlevel 1 (
    timeout /t 2 >nul
    goto WAIT_START
)

cls
echo %GAME% Ha sido detectado...

:: ===== BAJAR RESOLUCION =====
QRes.exe /x 800 /y 600 >nul 2>&1

timeout /t 10 >nul

:: ===== DETENER SERVICIOS =====
echo WinterBlox esta Deteniendo algunos servicios...

for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    net stop SysMain /y >nul 2>&1
)

:: ===== CERRAR PROCESOS =====
taskkill /f /im CompatTelRunner.exe >nul 2>&1
taskkill /f /im RuntimeBroker.exe >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
taskkill /f /im taskhostw.exe >nul 2>&1
taskkill /f /im mscorsvw.exe >nul 2>&1

:: ===== PRIORIDADES =====
wmic process where name="%EXE%" CALL setpriority "32768" >nul

for %%P in (
    explorer.exe audiodg.exe svchost.exe csrss.exe
    winlogon.exe dwm.exe ntoskrnl.exe
) do (
    wmic process where name="%%P" CALL setpriority "64" >nul
)

cls
echo %GAME% en ejecución...

:: ===== ESPERAR CIERRE =====
:WAIT_CLOSE
tasklist | find /i "%EXE%" >nul
if not errorlevel 1 (
    timeout /t 3 >nul
    goto WAIT_CLOSE
)

cls
echo %GAME% Cerrado

:: ===== RESTAURAR RESOLUCION =====
QRes.exe /x 1366 /y 768 >nul 2>&1

:: ===== REINICIAR SERVICIOS =====
echo Restaurando servicios...

for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    net start %%S >nul 2>&1
)

:: ===== PRIORIDADES NORMALES =====
for %%P in (
    explorer.exe audiodg.exe svchost.exe csrss.exe
    winlogon.exe dwm.exe ntoskrnl.exe
) do (
    wmic process where name="%%P" CALL setpriority "32" >nul
)

echo Todo restaurado correctamente
pause