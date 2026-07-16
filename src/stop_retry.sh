#!/data/data/com.termux/files/usr/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
SCRIPT_PATH="$PROJECT_DIR/src/retry_backup.sh"

if ! crontab -l 2>/dev/null | grep -qF "$SCRIPT_PATH"; then
    exit 0
fi

crontab -l 2>/dev/null | grep -vF "$SCRIPT_PATH" | crontab -