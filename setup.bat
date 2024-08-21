@echo off
setlocal enabledelayedexpansion

REM Read from the config file
for /f "tokens=1,2 delims== " %%a in ('type config.ini ^| findstr /r "^[^;]"') do (
    set "%%a=%%b"
)

REM Setting up backup.bat (improved version)
set "file=backup.bat"
set "output=backup_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%file%) do (
    set "line=%%a"
    set "line=!line:MYSQL_USER=%MySQL_user%!"
    set "line=!line:MYSQL_PASSWORD=%MySQL_password%!"
    set "line=!line:MYSQL_DATABASE=%MySQL_database%!"
    set "line=!line:BACKUP_DIR=%Paths_backup_dir%!"
    set "line=!line:BACKUP_FILE=%Paths_backup_dir%\%Backup_backup_file_format%!"
    echo !line! >> "%output%"
)

REM Setting up deploy.bat (improved version)
set "file=deploy.bat"
set "output=deploy_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%file%) do (
    set "line=%%a"
    set "line=!line:C:\\path\\to\\your\\docker-compose\\files=%Paths_docker_compose_dir%!"
    echo !line! >> "%output%"
)

REM Setting up restart.bat (improved version)
set "file=restart.bat"
set "output=restart_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%file%) do (
    set "line=%%a"
    set "line=!line:C:\\path\\to\\your\\docker-compose\\files=%Paths_docker_compose_dir%!"
    echo !line! >> "%output%"
)

REM Setting up restore.bat (improved version)
set "file=restore.bat"
set "output=restore_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%file%) do (
    set "line=%%a"
    set "line=!line:MYSQL_USER=%MySQL_user%!"
    set "line=!line:MYSQL_PASSWORD=%MySQL_password%!"
    set "line=!line:MYSQL_DATABASE=%MySQL_database%!"
    set "line=!line:BACKUP_DIR=%Paths_backup_dir%!"
    set "line=!line:prompt_message=%Restore_prompt_message%!"
    echo !line! >> "%output%"
)

REM Setting up update.bat (improved version)
set "file=update.bat"
set "output=update_final.bat"

echo. > "%output%"
for /f "delims=" %%a in (%file%) do (
    set "line=%%a"
    set "line=!line:repoPath=%Paths_repo_path%!"
    set "line=!line:lockFile=%Paths_repo_path%\\deploy.lock!"
    set "line=!line:logFile=%Paths_repo_path%\\deploy.log!"
    echo !line! >> "%output%"
)

echo Setup complete. Final scripts have been generated as *_final.bat.
endlocal
exit /b 0
