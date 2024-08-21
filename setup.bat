@echo off
setlocal enabledelayedexpansion

echo Reading config.ini and setting variables...

REM Read config.ini and set variables
for /f "tokens=1,* delims== " %%a in ('type config.ini ^| findstr /r "^[^;]"') do (
    REM Skip lines that are section headers (those that start with [ and end with ])
    echo %%a | findstr /r "^\[.*\]$" >nul
    if errorlevel 1 (
        set "name=%%a"
        set "value=%%b"
        echo Setting !name! to !value!
        set "!name!=!value!"
    )
)

echo.
echo Verifying the captured variables:
echo MySQL User: %user%
echo MySQL Password: %password%
echo MySQL Database: %database%
echo Backup Directory: %backup_dir%
echo Docker Compose Directory: %docker_compose_dir%
echo Repo Path: %repo_path%
echo Restore Prompt: %prompt_message%

pause

REM If the above values are correct, continue with the placeholder replacements
if not defined user (
    echo ERROR: MySQL_user is not set. Aborting.
    exit /b 1
)
if not defined backup_dir (
    echo ERROR: Paths_backup_dir is not set. Aborting.
    exit /b 1
)

REM Function to replace placeholders in a file
call :replace_placeholders "backup.bat" "backup_final.bat"
call :replace_placeholders "deploy.bat" "deploy_final.bat"
call :replace_placeholders "restart.bat" "restart_final.bat"
call :replace_placeholders "restore.bat" "restore_final.bat"
call :replace_placeholders "update.bat" "update_final.bat"

echo Setup complete. Final scripts have been generated as *_final.bat.
exit /b 0

:replace_placeholders
set "input=%~1"
set "output=%~2"
del "%output%" 2>nul
(
    for /f "usebackq delims=" %%a in ("%input%") do (
        set "line=%%a"
        set "line=!line:{{MYSQL_USER}}=%user%!"
        set "line=!line:{{MYSQL_PASSWORD}}=%password%!"
        set "line=!line:{{MYSQL_DATABASE}}=%database%!"
        set "line=!line:{{BACKUP_DIR}}=%backup_dir%!"
        set "line=!line:{{DOCKER_COMPOSE_DIR}}=%docker_compose_dir%!"
        set "line=!line:{{REPO_PATH}}=%repo_path%!"
        set "line=!line:{{prompt_message}}=%prompt_message%!"
        echo !line! >> "%output%"
    )
)
exit /b
