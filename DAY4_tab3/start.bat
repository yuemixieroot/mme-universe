@echo off
chcp 65001 >nul 2>&1
cd /d "%~dp0"
title Manifest-Tool Launcher

echo.
echo  ========================================
echo    Manifest-Tool - Starting...
echo  ========================================
echo.

where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo  [OK] Found Python
    echo  Starting server in a new window...
    start "Manifest-Tool-Server" python -m http.server 8090
    goto :wait
)

where python3 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo  [OK] Found Python3
    echo  Starting server in a new window...
    start "Manifest-Tool-Server" python3 -m http.server 8090
    goto :wait
)

where node >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo  [OK] Found Node.js
    echo  Starting server in a new window...
    start "Manifest-Tool-Server" node -e "var h=require('http'),fs=require('fs'),p=require('path');h.createServer(function(q,r){var u=q.url==='/'?'/index.html':q.url;var f=p.join(__dirname,u);fs.readFile(f,function(e,d){if(e){r.writeHead(404);r.end('Not found');}else{var ext=p.extname(f).slice(1);var ct={'html':'text/html; charset=utf-8','js':'application/javascript','css':'text/css','json':'application/json','svg':'image/svg+xml','png':'image/png'}[ext]||'application/octet-stream';r.writeHead(200,{'Content-Type':ct});r.end(d);}});}).listen(8090);"
    goto :wait
)

echo  [ERROR] Python or Node.js not found.
echo.
echo  Please install one of:
echo    1. Python:  https://www.python.org/downloads/
echo    2. Node.js: https://nodejs.org/
echo.
echo  Or just double-click index.html to use directly
echo  (PWA features need the server, basic features work without it)
echo.
pause
goto :eof

:wait
echo  Waiting for server...
timeout /t 3 /nobreak >nul
echo  Opening browser...
start "" http://localhost:8090
echo.
echo  ========================================
echo    Server is running in another window.
echo    Close that window to stop the server.
echo  ========================================
echo.
timeout /t 5 /nobreak >nul
