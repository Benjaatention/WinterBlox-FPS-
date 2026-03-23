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
echo            WinterBlox Launcher (Benjaatention)             
echo                           1.2
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

:: ===== MENU =====
:MENU
cls
echo ==========================================
echo          WinterBlox Launcher 1.2
echo ==========================================
echo.

echo     [ 1 ]  [+] Optimizacion EXTREMA
echo.
echo     [ 2 ]  [+] Optimizacion NORMAL (Recomendada)
echo.
echo     [ 3 ]  [x] Salir
echo.

set /p op=Selecciona una opcion ^> 

if "%op%"=="1" goto EXTREMA
if "%op%"=="2" goto NORMAL
if "%op%"=="3" exit

goto MENU

:: =================================
:: ===== OPTIMIZACION EXTREMA =====
:: =================================
:EXTREMA
cls
echo [>] Esperando a que abras %GAME%...
echo.

:WAIT_START_E
cls
echo.
echo   ====================================
echo.
echo    [...] Esperando a que abras %GAME%
echo.
echo   ====================================
echo.

tasklist | find /i "%EXE%" >nul
if errorlevel 1 (
    timeout /t 2 >nul
    goto WAIT_START_E
)
cls
echo %GAME% detectado
echo.

:: ===== RESOLUCION =====
cd /d "%~dp0data"
QRes.exe /x 800 /y 600 >nul 2>&1

echo [~] Aplicando optimizacion extrema...
echo.

:: ===== SERVICIOS =====
for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    echo Deteniendo %%S...
    net stop %%S /y >nul 2>&1
)

echo.
echo ===============================
echo   [OK] Optimizacion aplicada
echo ===============================
timeout /t 2 >nul

wmic process where name="%EXE%" CALL setpriority "32768" >nul

:: ===== ESPERAR CIERRE =====
:WAIT_CLOSE_E
tasklist | find /i "%EXE%" >nul
if not errorlevel 1 (
    timeout /t 3 >nul
    goto WAIT_CLOSE_E
)

:: ===== RESTAURAR =====
cls
echo [+] Restaurando sistema...

QRes.exe /x 1366 /y 768 >nul 2>&1

for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    net start %%S >nul 2>&1
)

echo.
echo ===============================
echo   [OK] Sistema restaurado
echo ===============================
pause
goto MENU

:: =================================
:: ===== OPTIMIZACION NORMAL =====
:: =================================
:NORMAL
cls
echo [...] Esperando a que abras %GAME%...
echo.

:WAIT_START_N
cls
echo.
echo   ====================================
echo.
echo    [...] Esperando a que abras %GAME%
echo.
echo   ====================================
echo.

:LOOP_WAIT_N
tasklist | find /i "%EXE%" >nul
if not errorlevel 1 goto CONTINUE_NORMAL

timeout /t 2 >nul
goto LOOP_WAIT_N

:CONTINUE_NORMAL
cls
echo %GAME% detectado
echo.

echo [~] Aplicando optimizacion normal...
echo.

:: ===== SERVICIOS =====
for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    echo Deteniendo %%S...
    net stop %%S /y >nul 2>&1
)

echo.
echo ===============================
echo   [OK] Optimizacion aplicada
echo ===============================
timeout /t 2 >nul

wmic process where name="%EXE%" CALL setpriority "32768" >nul

:: ===== ESPERAR CIERRE =====
:WAIT_CLOSE_N
tasklist | find /i "%EXE%" >nul
if not errorlevel 1 (
    timeout /t 3 >nul
    goto WAIT_CLOSE_N
)

:: ===== RESTAURAR =====
cls
echo [+] Restaurando servicios...

for %%S in (
    uxsms SysMain DiagTrack Themes WSearch wuauserv WinDefend
    FontCache UevAgentService TabletInputService ShellHWDetection
    shpamsvc RemoteRegistry AJRouter AssignedAccessManagerSvc
    MapsBroker DPS
) do (
    net start %%S >nul 2>&1
)

echo.
echo ===============================
echo   [OK] Sistema restaurado
echo ===============================
pause
goto MENU