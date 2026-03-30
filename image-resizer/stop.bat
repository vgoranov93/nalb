@echo off
REM
REM  NALB Image Resizer - Stop
REM  Double-click this file to stop the app
REM

set CONTAINER_NAME=nalb-resizer

docker ps --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Stopping NALB Image Resizer...
    docker stop %CONTAINER_NAME% >nul 2>&1
    docker rm %CONTAINER_NAME% >nul 2>&1
    echo Stopped.
) else (
    echo NALB Image Resizer is not running.
)

pause
