#!/data/data/com.termux/files/usr/bin/bash
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pkg update && pkg upgrade -y
pkg install rclone restic cronie termux-api termux-services -y

if [ ! -f "$SCRIPT_DIR/config/.env" ]; then
    if [ -f "$SCRIPT_DIR/config/.env.example" ]; then
        cp "$SCRIPT_DIR/config/.env.example" "./config/.env"
    fi
fi

if [ ! -f "$SCRIPT_DIR/config/.password" ]; then
    touch "$SCRIPT_DIR/touch/.password"
fi

find . -type f -name "*.sh" -exec chmod +x {} +
