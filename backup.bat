@echo off

REM Set MySQL credentials and database information
set MYSQL_USER={{MYSQL_USER}}
set MYSQL_PASSWORD={{MYSQL_PASSWORD}}
set MYSQL_DATABASE={{MYSQL_DATABASE}}

REM Set the backup directory and file name with timestamp
set "BACKUP_DIR={{BACKUP_DIR}}"  REM Quotes to avoid trailing spaces
set BACKUP_FILE=%BACKUP_DIR%\sql_backup_%DATE:~-10,2%-%DATE:~-7,2%-%DATE:~-4,4%_%TIME:~0,2%%TIME:~3,2%.sql

REM Display the variables for testing
echo MySQL User: %MYSQL_USER%
echo MySQL Password: %MYSQL_PASSWORD%
echo MySQL Database: %MYSQL_DATABASE%
echo Backup Directory: %BACKUP_DIR%
echo Backup File: %BACKUP_FILE%

pause

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" (
    echo Creating backup directory: %BACKUP_DIR%
    mkdir "%BACKUP_DIR%"
) else (
    echo Backup directory already exists: %BACKUP_DIR%
)

REM Perform MySQL backup
echo Running backup command: mysqldump -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% > "%BACKUP_FILE%"
mysqldump -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% > "%BACKUP_FILE%"

REM Check if backup was successful
if %ERRORLEVEL% NEQ 0 (
    echo There was an error during the backup process.
    goto :EOF
)

echo Backup created successfully: %BACKUP_FILE%

pause

:EOF
