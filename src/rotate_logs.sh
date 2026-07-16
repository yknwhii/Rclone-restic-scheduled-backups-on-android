#!/data/data/com.termux/files/usr/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LOG_DIR="$PROJECT_DIR/logs"
ARCHIVE_DIR="$PROJECT_DIR/logs/archive"
DATE=$(date '+%Y-%m-%d')

mkdir -p "$ARCHIVE_DIR"

notify() {
  termux-notification \
    --title "Backup" \
    --content "$1"
}

rotate() {
    local file=$1
    if [ -f "$LOG_DIR/$file" ]; then
        mv "$LOG_DIR/$file" "$ARCHIVE_DIR/${file%.log}-$DATE.log"
        touch "$LOG_DIR/$file"
    fi
}

rotate "backup.log"
rotate "backup-stats.log"
notify "Logs archived"