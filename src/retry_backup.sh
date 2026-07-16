#!/data/data/com.termux/files/usr/bin/bash
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LOG_STATS="$PROJECT_DIR/logs/backup-stats.log"

echo "$(date '+%F %T') Retry backup" >> "$LOG_STATS"

notify() {
  termux-notification \
    --title "Backup" \
    --content "$1"
}

notify "Try backup"
#start backup script
$PROJECT_DIR/src/backup.sh
RC=$?

echo "$(date '+%F %T') Retry result code=$RC" >> "$LOG_STATS"

if [ "$RC" -eq 0 ]; then
    echo "$(date '+%F %T') Backup successful. Cancel retry job." >> "$LOG_STATS"
    notify "Backup successful"
    $PROJECT_DIR/src/stop_retry.sh
fi

exit $RC