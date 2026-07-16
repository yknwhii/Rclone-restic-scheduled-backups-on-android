#!/data/data/com.termux/files/usr/bin/bash

set -e

BOOT_DIR="$HOME/.termux/boot"
BOOT_SCRIPT="$BOOT_DIR/backup_service.sh"

sv-enable crond

if [ ! -d "$BOOT_DIR" ]; then
    mkdir -p "$BOOT_DIR"
fi

cat > "$BOOT_SCRIPT" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
sv-enable crond
EOF

chmod +x "$BOOT_SCRIPT"