@echo off
setlocal enabledelayedexpansion

REM Read config.ini and set variables
for /f "tokens=1,* delims== " %%a in ('type config.ini ^| findstr /r "^[^;]"') do (
    set "%%a=%%b"
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
        set "line=!line:{{MYSQL_USER}}=%MySQL_user%!"
        set "line=!line:{{MYSQL_PASSWORD}}=%MySQL_password%!"
        set "line=!line:{{MYSQL_DATABASE}}=%MySQL_database%!"
        set "line=!line:{{BACKUP_DIR}}=%Paths_backup_dir%!"
        set "line=!line:{{DOCKER_COMPOSE_DIR}}=%Paths_docker_compose_dir%!"
        set "line=!line:{{REPO_PATH}}=%Paths_repo_path%!"
        set "line=!line:{{prompt_message}}=%Restore_prompt_message%!"
        echo !line! >> "%output%"
    )
)
exit /b
