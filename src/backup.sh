#!/data/data/com.termux/files/usr/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source "$PROJECT_DIR/config/.env"
LOG_FILE="$PROJECT_DIR/logs/backup.log"

export RESTIC_REPOSITORY="$RESTIC_PATH"
export RESTIC_PASSWORD_FILE="$RESTIC_PASSWORD_PATH"

GLOBAL_STATUS=0
rclone_backup() {
    local source="$1"
    local dest="$2"

    rclone sync "$source" "$dest" 2>&1
    return $?
}

restic_backup() {
    timeout 5m restic backup "$@" --skip-if-unchanged 2>&1
}


write_log() {
    local type="$1"
    local source="$2"
    local dest="$3"
    local code="$4"
    local output="$5"
    local started="$6"
    local ended="$7"

    # JSON log-object
    echo "{\"timestamp_start\":\"$started\",\"timestamp_end\":\"$ended\",\"type\":\"$type\",\"source\":\"$source\",\"dest\":\"$dest\",\"exit_code\":$code,\"output\":\"$output\"}" >> "$LOG_FILE"
}

run_backup() {
    local type="$1"
    local source="$2"
    local dest="$3"

    local start_time
    local end_time
    local output
    local code

    start_time=$(date '+%Y-%m-%d %H:%M:%S')

    if [ "$type" == "rclone" ]; then
        output=$(rclone_backup "$source" "$dest")
        code=$?
    else
        output=$(restic_backup "$source" "$dest")
        code=$?
    fi

    end_time=$(date '+%Y-%m-%d %H:%M:%S')

    output=$(echo "$output" | tr '\n' ' ' | sed 's/"/\\"/g')
        
    write_log "$type" "$source" "$dest" "$code" "$output" "$start_time" "$end_time"
    if [ $code -ne 0 ]; then
    GLOBAL_STATUS=1
    fi
    return $code
}


# rclone backup task example:
#run_backup "rclone" "/storage/emulated/0/Pictures" "google_1:Pictures/"

# restic backup task example:
#run_backup "restic" "/storage/emulated/0/Documents/KeepassDX" "/storage/emulated/0/Documents/Obsidian/Vault"



exit $GLOBAL_STATUS
