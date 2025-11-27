@echo off
REM
REM  NALB Image Resizer - Start
REM  Double-click this file to start the app
REM

set CONTAINER_NAME=nalb-resizer
set IMAGE_NAME=nalb-resizer
set OUTPUT_DIR=%USERPROFILE%\Documents\resized-images
set PORT=5000

:: Create output folder
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Check if Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

:: Stop and remove existing container if any
docker ps -a --format "{{.Names}}" | findstr /x "%CONTAINER_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Stopping existing container...
    docker stop %CONTAINER_NAME% >nul 2>&1
    docker rm %CONTAINER_NAME% >nul 2>&1
)

:: Build image if it doesn't exist
docker images --format "{{.Repository}}" | findstr /x "%IMAGE_NAME%" >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Building image for the first time, this may take a minute...
    docker build -t %IMAGE_NAME% "%~dp0"
)

:: Start the container
echo Starting NALB Image Resizer...
docker run -d --name %CONTAINER_NAME% -p %PORT%:5000 -v "%OUTPUT_DIR%:/images/destination" %IMAGE_NAME% >nul

echo.
echo ===================================
echo   NALB Image Resizer is running!
echo ===================================
echo.
echo   Open in browser: http://localhost:%PORT%
echo   Resized images:  %OUTPUT_DIR%
echo.
echo   To stop: run stop.bat or use the Stop button in the UI
echo.

:: Open browser
start http://localhost:%PORT%

pause
