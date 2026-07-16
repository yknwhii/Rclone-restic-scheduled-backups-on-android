# Rclone-restic backup service for android

## Overview
This tool allow you make schedule backups of your files/folders on android for copying data with rclone and for encrypted backups with restic.
## Features
- Make scheduled simple backups with rclone
- Make scheduled encrypted backups with restic
- View all backups attempts and results in logs
- Additional: scheduled logs rotation for avoiding logs clogging

## Utils
Service use:
- rclone, restic for backups
- cron for scheduling tasks
- termux-services is used to automatically start cron
- termux-api is used for notifications 

## Requirements
Service also require:
- Termux
- Termux:Boot for autorun cron service after device reboot
- Termux:API for termux-api util

## Installation
1. Install Termux, Termux:Boot, Termux:API if you already not:
	1. https://f-droid.org/packages/com.termux
	2. https://f-droid.org/packages/com.termux.boot
	3. https://f-droid.org/packages/com.termux.api
2. Clone repo
3. Move project folder to termux home path (~/ or /data/data/com.termux/files/home) or if you have **root** give -x permission for projects scripts

## Usage
1. Run setup.sh
2. Run Install_service.sh
3. Inside ./config/.env write your restic destination info from (you must have rclone config created and configured)
4. Inside ./config/.password write your restic folder password
5. In the end of ./src/backup.sh write your backup tasks by examples
6. By default scheduler set backup on 7:00 am everyday and logs rotation every first day of month,  if you want change it write your schedule in ./src/start_service.sh
7. Run start_service.sh
8. Reboot your device


# Configuration
## Backup settings
### .env
```
#./config/.env
RESTIC_PATH="rclone:[REMOTE_NAME]:[FOLDER]"
#[REMOTE_NAME] - name of your remote from rclone config
#[FOLDER] - path to selected folder in your cloud
```

### .password
```
#./config/.password
Jev|=syfd7%7%uv+f?<>f*$
#your password for restic encrypted storage
```

### backup tasks

```
#./src/backup.sh
#before "exit $GLOBAL_STATUS" line write your backup tasks in format: 
#for rclone (just syncing files):
run_backup "rclone" "PATH_TO_YOUR_FOLDER/FILE" "REMOTE_NAME:FOLDER_IN_CLOUD"
#for restic (encrypted backup):
run_backup "restic" "PATH1" "PATH2" "PATH3" "etc..."
```
**For restic task you can write a few paths - it will backup all together in single folder**
## Schedule settings
### Main
```
#./start_service.sh
CRON_SCHEDULE="0 7 * * * $SCRIPT_PATH"
CRON_ROTATE_LOGS="0 0 1 * * $ROTATION_PATH"
```
1. CRON_SCHEDULE - backup everyday at 7:00 am
2. CRON_ROTATE_LOGS - logs rotation every first day of month

### Retry

```
#./src/start_retry.sh
CRON_LINE="*/15 * * * * $SCRIPT_PATH"
```
CRON_LINE - after failed attempt of backup service will try again every 15 min

---

If you want change any schedule just rewrite "x x x x x" part according to *cron* syntax:

```
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0–7, where 0 and 7 = Sunday)
│ │ │ └──── Month (1–12)
│ │ └────── Day of month (1–31)
│ └──────── Hour (0–23)
└────────── Minute (0–59)
```

Possible values:
```
*      — Any value
*/N    — Every N units
1,5,10 — List of values
1-5    — Range of values
```
## Logs
Service note 2 logs:
1. ./logs/backup-stats.log - contain just attempts of backups and result of work 
2. ./logs/backup.log - contain detailed information about every backup task that you write in ./src/backup.sh:
	- Start time
	- End time
	- Exit code
	- Utils output

## Deletion 
If you want remove service:
1. Run ./stop_service.sh to delete backup and logs rotation crons
2. Run ./src/stop_retry.sh if retry backup cron is active
3. Run ./delete_service.sh to delete boot file that start service and disable crond
4. Reboot device

## Troubleshooting 
If you have "Backup error -> start retry" notification after backup attempt - its normal behavior. This is done if you did not have the Internet at the time of backup, the service will try to make a backup every 15 minutes (or your version) until you connect to the network and the backup is successful
If you want stop retry backup cron - run ./src/stop_retry.sh

---

If backups don’t work - view backup.log and check if some backup tasks ends with exit code=1 and if there is one, check the "output" description.
### Common problems:
- network error - check connection and vpn (if using)
- restic: incorrect password - check that the password is correct in .password
- restic: no password file exists (if you changed path) - check the path to the file with resctic password