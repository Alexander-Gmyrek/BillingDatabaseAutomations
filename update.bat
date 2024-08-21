@echo off
setlocal

REM Define variables
set "repoPath={{REPO_PATH}}"
set "lockFile=%repoPath%\deploy.lock"
set "logFile=%repoPath%\deploy.log"

REM Function to log messages
:WriteMessage
echo %date% %time%: %1 >> "%logFile%"
goto :eof

REM Debug: Check the paths and initial variables
echo Repository Path: %repoPath%
echo Lock File: %lockFile%
echo Log File: %logFile%

REM Check if lock file exists
if exist "%lockFile%" (
    call :WriteMessage "Lock file exists. Exiting..."
    echo Lock file exists. Exiting...
    exit /b
)

REM Create lock file
echo Creating lock file...
echo. > "%lockFile%"

REM Try block equivalent
set "errorOccurred="

REM Pull latest changes from git
echo Changing directory to repository path: %repoPath%
cd /d "%repoPath%" || (
    echo Failed to change directory to %repoPath%. Exiting...
    call :WriteMessage "Failed to change directory to %repoPath%"
    goto :Cleanup
)
echo Fetching latest changes...
git fetch || (
    echo Failed to fetch from git repository. Exiting...
    call :WriteMessage "Failed to fetch from git repository"
    goto :Cleanup
)

REM Check if there are any changes by comparing the local and remote hashes
echo Checking for changes...
for /f "delims=" %%a in ('git rev-parse @') do set localHash=%%a
for /f "delims=" %%a in ('git rev-parse @{u}') do set remoteHash=%%a

if not "%localHash%" == "%remoteHash%" (
    call :WriteMessage "Changes detected. Deploying..."
    echo Changes detected. Deploying...

    REM Pull latest changes
    echo Pulling latest changes...
    git pull || (
        echo Failed to pull latest changes. Exiting...
        call :WriteMessage "Failed to pull latest changes"
        goto :Cleanup
    )

    REM Build and deploy using Docker Compose
    echo Building Docker images...
    docker-compose build || (
        echo Failed to build Docker images. Exiting...
        call :WriteMessage "Failed to build Docker images"
        goto :Cleanup
    )
    echo Deploying Docker containers...
    docker-compose up -d --scale app=2 || (
        echo Failed to start Docker containers. Exiting...
        call :WriteMessage "Failed to start Docker containers"
        goto :Cleanup
    )

    REM Sleep for 30 seconds to ensure the new container is up
    echo Waiting for 30 seconds...
    timeout /t 30 /nobreak >nul

    REM Scale down the old container
    echo Scaling down old containers...
    docker-compose down --remove-orphans || (
        echo Failed to scale down old containers. Exiting...
        call :WriteMessage "Failed to scale down old containers"
    )

    call :WriteMessage "Deployment completed."
    echo Deployment completed.
) else (
    call :WriteMessage "No changes detected."
    echo No changes detected.
)

:Cleanup
REM Finally block equivalent: Remove lock file
echo Cleaning up: Removing lock file...
del "%lockFile%"

if defined errorOccurred (
    call :WriteMessage "Script completed with errors."
    echo Script completed with errors.
    endlocal
    exit /b 1
)

call :WriteMessage "Script completed successfully."
echo Script completed successfully.
endlocal
exit /b 0
