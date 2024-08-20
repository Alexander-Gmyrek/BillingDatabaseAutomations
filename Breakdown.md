Breakdown

1. We need something to deploy/restart.
2. We need something that can update from the repository
3. We need backups of the sql server
4. We need the ability to restore the backups

Windows Tasks 
Run deploy on startup
Look for updates every 30 minutes
Backup sql every 30 minutes
purge all but the last backup for the day so you only have one backup per day

Files
Deploy

Update 

Restart 

Backup

Restore 