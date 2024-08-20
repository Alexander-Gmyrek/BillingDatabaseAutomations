# Create Scheduled Tasks in Windows Task Scheduler

## Open Windows Task Scheduler:
1. Type **Task Scheduler** in the Windows search bar and open it.

## Create a Task for Deployment:
1. Go to **Action > Create Task**.
2. Name it **Deploy Docker Containers**.
3. Under the **Triggers** tab, create a new trigger to run **At startup**.
4. Under the **Actions** tab, create a new action to **Start a program** and select the `deploy.bat` file.
5. Save the task.

## Create a Task for Updating Containers:
1. Go to **Action > Create Task**.
2. Name it **Update Docker Containers**.
3. Under the **Triggers** tab, create a new trigger to run **Daily**, and set the interval to **Repeat task every 30 minutes**.
4. Under the **Actions** tab, create a new action to **Start a program** and select the `update.bat` file.
5. Save the task.

## Create a Task for Backing Up SQL Server:
1. Go to **Action > Create Task**.
2. Name it **Backup SQL Server**.
3. Under the **Triggers** tab, create a new trigger to run **Daily**, and set the interval to **Repeat task every 30 minutes**.
4. Under the **Actions** tab, create a new action to **Start a program** and select the `backup.bat` file.
5. Save the task.
