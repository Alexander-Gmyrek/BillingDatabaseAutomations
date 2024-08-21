@echo off
setlocal enabledelayedexpansion

REM Read from the config file and store each setting as a variable
for /f "tokens=1,* delims== " %%a in ('type config.ini ^| findstr /r "^[^;]"') do (
    set "%%a=%%b"
)

REM Replace placeholders in backup.bat
set "input=backup.bat"
set "output=backup_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%input%) do (
    set "line=%%a"
    set "line=!line:MYSQL_USER=%MySQL_user%!"
    set "line=!line:MYSQL_PASSWORD=%MySQL_password%!"
    set "line=!line:MYSQL_DATABASE=%MySQL_database%!"
    set "line=!line:BACKUP_DIR=%Paths_backup_dir%!"
    set "line=!line:BACKUP_FILE=%Paths_backup_dir%\%Backup_backup_file_format%!"
    echo !line! >> "%output%"
)

REM Replace placeholders in deploy.bat
set "input=deploy.bat"
set "output=deploy_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%input%) do (
    set "line=%%a"
    set "line=!line:C:\\path\\to\\your\\docker-compose\\files=%Paths_docker_compose_dir%!"
    echo !line! >> "%output%"
)

REM Replace placeholders in restart.bat
set "input=restart.bat"
set "output=restart_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%input%) do (
    set "line=%%a"
    set "line=!line:C:\\path\\to\\your\\docker-compose\\files=%Paths_docker_compose_dir%!"
    echo !line! >> "%output%"
)

REM Replace placeholders in restore.bat
set "input=restore.bat"
set "output=restore_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%input%) do (
    set "line=%%a"
    set "line=!line:MYSQL_USER=%MySQL_user%!"
    set "line=!line:MYSQL_PASSWORD=%MySQL_password%!"
    set "line=!line:MYSQL_DATABASE=%MySQL_database%!"
    set "line=!line:BACKUP_DIR=%Paths_backup_dir%!"
    set "line=!line:set /p BACKUP_FILE=Enter the backup file name to restore=%Restore_prompt_message%!"
    echo !line! >> "%output%"
)

REM Replace placeholders in update.bat
set "input=update.bat"
set "output=update_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%input%) do (
    set "line=%%a"
    set "line=!line:repoPath=%Paths_repo_path%!"
    set "line=!line:lockFile=%Paths_repo_path%\\deploy.lock!"
    set "line=!line:logFile=%Paths_repo_path%\\deploy.log!"
    echo !line! >> "%output%"
)

echo Setup complete. Final scripts have been generated as *_final.bat.
endlocal
exit /b 0
