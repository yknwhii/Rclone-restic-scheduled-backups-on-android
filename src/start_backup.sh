#!/data/data/com.termux/files/usr/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
LOG_STATS="$PROJECT_DIR/logs/backup-stats.log"

echo "$(date '+%F %T') START backup" >> "$LOG_STATS"

notify() {
  termux-notification \
    --title "Backup" \
    --content "$1"
}

notify "Backup started"
#start backup script
$PROJECT_DIR/src/backup.sh
RC=$?

echo "$(date '+%F %T') RESULT code=$RC" >> "$LOG_STATS"

if [ "$RC" -eq 1 ]; then
    echo "$(date '+%F %T') Scheduling retry job" >> "$LOG_STATS"
    notify "Backup error -> start retry"
    $PROJECT_DIR/src/start_retry.sh
elif [ "$RC" -eq 0 ]; then
    notify "Backup succesfull"
fi

exit $RC