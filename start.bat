@echo off
setlocal DisableDelayedExpansion
cd /d "%~dp0"
where node >nul 2>&1 || (
    echo Node.js is not installed or not in PATH.
    pause
    exit /b 1
)
:menu
cls
set "count=0"
set "choice="
echo ===== Godot Project Servers =====
for /d %%D in (*) do if exist "%%D\server\package.json" call :add "%%D"
if %count%==0 echo No folders with server\package.json found.
echo   0. Exit
set /p "choice=Select a project: "
setlocal EnableDelayedExpansion
set "number="
for /l %%I in (0,1,%count%) do if "!choice!"=="%%I" set "number=%%I"
endlocal & set "number=%number%"
if not defined number goto menu
if "%number%"=="0" exit /b 0
call set "selected=%%project%number%%%"
cls
echo Starting server: %selected%
pushd "%selected%\server"
if not exist ".env" if exist ".env.example" copy ".env.example" ".env" >nul
if not exist "node_modules\" call npm install || goto stopped
call npm start
:stopped
popd
echo Server stopped: %selected%
pause
goto menu
:add
set /a count+=1
set "project%count%=%~1"
echo   %count%. %~1
exit /b