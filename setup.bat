@echo off
setlocal

REM Read from the config file
for /f "tokens=1,2 delims== " %%a in ('type config.ini ^| findstr /r "^[^;]"') do (
    set %%a=%%b
)

REM Replace placeholders in the batch files using PowerShell
call :replace_placeholders backup.bat backup_final.bat
call :replace_placeholders deploy.bat deploy_final.bat
call :replace_placeholders restart.bat restart_final.bat
call :replace_placeholders restore.bat restore_final.bat
call :replace_placeholders update.bat update_final.bat

echo Setup complete. Final scripts have been generated as *_final.bat.
endlocal
exit /b 0

:replace_placeholders
set input=%1
set output=%2

powershell -Command ^
    "(Get-Content %input%) | ForEach-Object { $_ -replace 'MYSQL_USER', '$env:MySQL_user' `
                               -replace 'MYSQL_PASSWORD', '$env:MySQL_password' `
                               -replace 'MYSQL_DATABASE', '$env:MySQL_database' `
                               -replace 'BACKUP_DIR', '$env:Paths_backup_dir' `
                               -replace 'BACKUP_FILE', '$env:Backup_backup_file_format' `
                               -replace 'docker-compose_dir', '$env:Paths_docker_compose_dir' `
                               -replace 'repoPath', '$env:Paths_repo_path' `
                               -replace 'lockFile', '$env:Paths_repo_path\\deploy.lock' `
                               -replace 'logFile', '$env:Paths_repo_path\\deploy.log' `
                               -replace 'prompt_message', '$env:Restore_prompt_message' } | Set-Content %output%"
exit /b
