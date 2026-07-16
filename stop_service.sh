#!/data/data/com.termux/files/usr/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_PATH="$SCRIPT_DIR/src/start_backup.sh"
ROTATION_PATH="$SCRIPT_DIR/src/rotate_logs.sh"

notify() {
  termux-notification \
    --title "Backup" \
    --content "$1"
}

if ! crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
    exit 0
fi

crontab -l 2>/dev/null | grep -vF "$SCRIPT_PATH" | crontab -

if ! crontab -l 2>/dev/null | grep -qF "$ROTATION_PATH"; then
    exit 0
fi

crontab -l 2>/dev/null | grep -vF "$ROTATION_PATH" | crontab -


notify "Backup service stoped"