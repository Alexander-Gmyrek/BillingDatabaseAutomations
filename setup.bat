@echo off
setlocal enabledelayedexpansion

REM Read config.ini and set variables
for /f "tokens=1,* delims== " %%a in ('type config.ini ^| findstr /r "^[^;]"') do (
    set "%%a=%%b"
)

REM Write the read values to a temporary file for verification
(
    echo MySQL User: %user%
    echo MySQL Password: %password%
    echo MySQL Database: %database%
    echo Backup Directory: %backup_dir%
    echo Docker Compose Directory: %docker_compose_dir%
    echo Repository Path: %repo_path%
    echo Restore Prompt Message: %prompt_message%
) > temp_values.txt

REM Display the content of the temporary file
type temp_values.txt
pause

REM Replace placeholders in the batch files
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
