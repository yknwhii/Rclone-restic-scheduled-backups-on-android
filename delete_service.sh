#!/data/data/com.termux/files/usr/bin/bash

BOOT_SCRIPT="$HOME/.termux/boot/backup_service.sh"

sv-disable crond

if [ -f "$BOOT_SCRIPT" ]; then
    rm "$BOOT_SCRIPT"
fi