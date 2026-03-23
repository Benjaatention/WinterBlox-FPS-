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
echo          WinterBlox Services (Benjaatention) ❄             
echo                           1.1
echo.

:: ===== AUTO ADMIN =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb runAs"
    exit
)

:: ===== CONFIG =====
set EXE=RobloxPlayerBeta.exe
set GAME=Roblox

title WinterBlox Services
echo Esperando a que abras %GAME%...

:: ===== ESPERAR INICIO =====
:WAIT_START
tasklist | find /i "%EXE%" >nul
if errorlevel 1 (
    timeout /t 2 >nul
    goto WAIT_START
)

cls
echo %GAME% detectado
echo.
echo Aplicando optimizacion...

timeout /t 3 >nul

:: ===== DETENER SERVICIOS =====
echo.
echo Desactivando servicios...

for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    net stop %%S /y >nul 2>&1
)

:: ===== CERRAR PROCESOS =====
taskkill /f /im CompatTelRunner.exe >nul 2>&1
taskkill /f /im RuntimeBroker.exe >nul 2>&1
taskkill /f /im StartMenuExperienceHost.exe >nul 2>&1
taskkill /f /im taskhostw.exe >nul 2>&1
taskkill /f /im mscorsvw.exe >nul 2>&1

:: ===== PRIORIDAD =====
wmic process where name="%EXE%" CALL setpriority "32768" >nul

cls
echo %GAME% en ejecución, Servicios Deshabilitados.
echo.

:: ===== ESPERAR CIERRE =====
:WAIT_CLOSE
tasklist | find /i "%EXE%" >nul
if not errorlevel 1 (
    timeout /t 3 >nul
    goto WAIT_CLOSE
)

cls
echo %GAME% cerrado
echo.

:: ===== RESTAURAR SERVICIOS =====
echo Restaurando servicios...

for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    net start %%S >nul 2>&1
)

:: ===== PRIORIDAD NORMAL =====
for %%P in (
    explorer.exe audiodg.exe svchost.exe csrss.exe
    winlogon.exe dwm.exe ntoskrnl.exe
) do (
    wmic process where name="%%P" CALL setpriority "32" >nul
)

echo.
echo Todo restaurado correctamente
pause