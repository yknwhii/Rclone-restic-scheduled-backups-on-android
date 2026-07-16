#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_PATH="$SCRIPT_DIR/src/start_backup.sh"
ROTATION_PATH="$SCRIPT_DIR/src/rotate_logs.sh"

CRON_SCHEDULE="0 7 * * * $SCRIPT_PATH"
CRON_ROTATE_LOGS="0 0 1 * * $ROTATION_PATH"

notify() {
  termux-notification \
    --title "Backup" \
    --content "$1"
}

if ! sv status crond >/dev/null 2>&1; then
    notify "Crond not started"
    exit 1
fi

if crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
    exit 0
fi

( crontab -l 2>/dev/null; echo "$CRON_SCHEDULE" ) | crontab -

if crontab -l 2>/dev/null | grep -qF "$ROTATION_PATH"; then
    exit 0
fi

( crontab -l 2>/dev/null; echo "$CRON_ROTATE_LOGS" ) | crontab -

notify "Backup service started"

