@echo off
setlocal

REM Define variables
set repoPath={{REPO_PATH}}
set lockFile=%repoPath%\deploy.lock
set logFile=%repoPath%\deploy.log

REM Function to log messages
:WriteMessage
echo %date% %time%: %1 >> "%logFile%"
goto :eof

REM Check if lock file exists
if exist "%lockFile%" (
    call :WriteMessage "Lock file exists. Exiting..."
    exit /b 1
)

REM Create lock file
echo. > "%lockFile%"

REM Try block equivalent
set "errorOccurred="

REM Pull latest changes from git
cd /d "%repoPath%" || (
    call :WriteMessage "Failed to change directory to %repoPath%"
    goto :Cleanup
)
git fetch || (
    call :WriteMessage "Failed to fetch from git repository"
    goto :Cleanup
)

REM Check if there are any changes by comparing the local and remote hashes
for /f "delims=" %%a in ('git rev-parse @') do set localHash=%%a
for /f "delims=" %%a in ('git rev-parse @{u}') do set remoteHash=%%a

if not "%localHash%" == "%remoteHash%" (
    call :WriteMessage "Changes detected. Deploying..."

    REM Pull latest changes
    git pull || (
        call :WriteMessage "Failed to pull latest changes"
        goto :Cleanup
    )

    REM Build and deploy using Docker Compose
    docker-compose build || (
        call :WriteMessage "Failed to build Docker images"
        goto :Cleanup
    )
    docker-compose up -d --scale app=2 || (
        call :WriteMessage "Failed to start Docker containers"
        goto :Cleanup
    )

    REM Sleep for 30 seconds to ensure the new container is up
    timeout /t 30 /nobreak >nul

    REM Scale down the old container
    docker-compose down --remove-orphans || (
        call :WriteMessage "Failed to scale down old containers"
    )

    call :WriteMessage "Deployment completed."
) else (
    call :WriteMessage "No changes detected."
)

:Cleanup
REM Finally block equivalent: Remove lock file
del "%lockFile%"

if defined errorOccurred (
    call :WriteMessage "Script completed with errors."
    endlocal
    exit /b 1
)

call :WriteMessage "Script completed successfully."
endlocal
exit /b 0
