@echo off

REM Set MySQL credentials and database information
set MYSQL_USER={{MYSQL_USER}}
set MYSQL_PASSWORD={{MYSQL_PASSWORD}}
set MYSQL_DATABASE={{MYSQL_DATABASE}}

REM Set the backup directory and file name with timestamp
set BACKUP_DIR={{BACKUP_DIR}}
set BACKUP_FILE=%BACKUP_DIR%\sql_backup_%DATE:~-10,2%-%DATE:~-7,2%-%DATE:~-4,4%_%TIME:~0,2%%TIME:~3,2%.sql

REM Create backup directory if it doesn't exist
if not exist %BACKUP_DIR% mkdir %BACKUP_DIR%

REM Perform MySQL backup
mysqldump -u %MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DATABASE% > %BACKUP_FILE%

if %ERRORLEVEL% NEQ 0 (
    echo There was an error during the backup process.
    goto :EOF
)

echo Backup created successfully: %BACKUP_FILE%

REM Get the current date in YYYYMMDD format
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set curdatetime=%%a
set CUR_DATE=%curdatetime:~0,8%

REM Get the current time in minutes since midnight
set /a cur_minutes=%curdatetime:~8,2% * 60 + %curdatetime:~10,2%

REM Define the threshold for 31 minutes before and after midnight
set /a before_midnight_threshold=1439 - 30
set /a after_midnight_threshold=1

REM Check if the current time is within 31 minutes of midnight
if %cur_minutes% GEQ %before_midnight_threshold% goto :DeleteOldBackups
if %cur_minutes% LEQ %after_midnight_threshold% goto :DeleteOldBackups

goto :EOF

:DeleteOldBackups
REM Purge all but the latest backup for the day
for /f "skip=1 delims=" %%a in ('dir /b /o:-d "%BACKUP_DIR%\sql_backup_%DATE:~-10,2%-%DATE:~-7,2%-%DATE:~-4,4%*.sql"') do del "%BACKUP_DIR%\%%a"

:EOF
