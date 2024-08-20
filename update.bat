@echo off
setlocal

REM Define variables
set repoPath=C:\path\to\your\repository
set lockFile=%repoPath%\deploy.lock
set logFile=%repoPath%\deploy.log

REM Function to log messages
:WriteMessage
echo %date% %time%: %1 >> %logFile%
goto :eof

REM Check if lock file exists
if exist %lockFile% (
    call :WriteMessage "Lock file exists. Exiting..."
    exit /b
)

REM Create lock file
echo. > %lockFile%

REM Try block equivalent
set "errorOccurred="

REM Pull latest changes from git
cd /d %repoPath%
git fetch

REM Check if there are any changes by comparing the local and remote hashes
for /f "delims=" %%a in ('git rev-parse @') do set localHash=%%a
for /f "delims=" %%a in ('git rev-parse @{u}') do set remoteHash=%%a

if not "%localHash%" == "%remoteHash%" (
    call :WriteMessage "Changes detected. Deploying..."

    REM Pull latest changes
    git pull

    REM Build and deploy using Docker Compose
    docker-compose build
    docker-compose up -d --scale app=2

    REM Sleep for 30 seconds to ensure the new container is up
    timeout /t 30 /nobreak >nul

    REM Scale down the old container
    docker-compose down --remove-orphans

    call :WriteMessage "Deployment completed."
) else (
    call :WriteMessage "No changes detected."
)

REM Error handling
if defined errorOccurred (
    call :WriteMessage "An error occurred: %errorOccurred%"
)

REM Finally block equivalent: Remove lock file
del %lockFile%

endlocal
exit /b
