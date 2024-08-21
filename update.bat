@echo off
setlocal

REM Define variables
set "repoPath={{REPO_PATH}}"
set "lockFile=%repoPath%\deploy.lock"
set "logFile=%repoPath%\deploy.log"

REM Function to log messages
:WriteMessage
echo %date% %time%: %1 >> "%logFile%"


REM Log start of script execution
call :WriteMessage "Script started."

REM Debug: Check the paths and initial variables
call :WriteMessage "Repository Path: %repoPath%"
call :WriteMessage "Lock File: %lockFile%"
call :WriteMessage "Log File: %logFile%"

REM Check if lock file exists
if exist "%lockFile%" (
    call :WriteMessage "Lock file exists. Exiting..."
    echo Lock file exists. Exiting...
    exit /b
)

REM Create lock file
call :WriteMessage "Creating lock file..."
echo. > "%lockFile%"

REM Try block equivalent
set "errorOccurred="

REM Pull latest changes from git
call :WriteMessage "Changing directory to repository path: %repoPath%"
cd /d "%repoPath%" || (
    call :WriteMessage "Failed to change directory to %repoPath%. Exiting..."
    goto :Cleanup
)
call :WriteMessage "Fetching latest changes..."
git fetch || (
    call :WriteMessage "Failed to fetch from git repository. Exiting..."
    goto :Cleanup
)

REM Check if there are any changes by comparing the local and remote hashes
call :WriteMessage "Checking for changes..."
for /f "delims=" %%a in ('git rev-parse @') do set localHash=%%a
for /f "delims=" %%a in ('git rev-parse @{u}') do set remoteHash=%%a

if not "%localHash%" == "%remoteHash%" (
    call :WriteMessage "Changes detected. Deploying..."

    REM Pull latest changes
    call :WriteMessage "Pulling latest changes..."
    git pull || (
        call :WriteMessage "Failed to pull latest changes. Exiting..."
        goto :Cleanup
    )

    REM Build and deploy using Docker Compose
    call :WriteMessage "Building Docker images..."
    docker-compose build || (
        call :WriteMessage "Failed to build Docker images. Exiting..."
        goto :Cleanup
    )
    call :WriteMessage "Deploying Docker containers..."
    docker-compose up -d --scale app=2 || (
        call :WriteMessage "Failed to start Docker containers. Exiting..."
        goto :Cleanup
    )

    REM Sleep for 30 seconds to ensure the new container is up
    call :WriteMessage "Waiting for 30 seconds..."
    timeout /t 30 /nobreak >nul

    REM Scale down the old container
    call :WriteMessage "Scaling down old containers..."
    docker-compose down --remove-orphans || (
        call :WriteMessage "Failed to scale down old containers. Exiting..."
    )

    call :WriteMessage "Deployment completed."
) else (
    call :WriteMessage "No changes detected."
)

:Cleanup
REM Finally block equivalent: Remove lock file
call :WriteMessage "Cleaning up: Removing lock file..."
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
