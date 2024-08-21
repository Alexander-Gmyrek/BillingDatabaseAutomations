@echo off

REM Set MySQL credentials and database information
set MYSQL_USER={{MYSQL_USER}}
set MYSQL_PASSWORD={{MYSQL_PASSWORD}}
set MYSQL_DATABASE={{MYSQL_DATABASE}}

REM Set the path to the backup directory
set BACKUP_DIR={{BACKUP_DIR}}

REM Prompt the user to enter the backup file name they want to restore
set /p BACKUP_FILE="{{prompt_message}}"

REM Check if the backup file exists
if not exist "%BACKUP_DIR%\%BACKUP_FILE%" (
    echo The specified backup file does not exist.
    goto :EOF
)

REM Perform the restore using the MySQL command
mysql -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% < "%BACKUP_DIR%\%BACKUP_FILE%" || (
    echo There was an error restoring the database.
    goto :EOF
)

echo Database restored successfully from "%BACKUP_FILE%".

:EOF
