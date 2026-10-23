#!/usr/bin/env bash
set -e

BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "==> Uninstalling COSMIC Caps Lock Indicator..."

# 1. Stop and disable systemd service
systemctl --user stop cosmic-caps-lock-indicator.service 2>/dev/null || true
systemctl --user disable cosmic-caps-lock-indicator.service 2>/dev/null || true
rm -f "$CONFIG_DIR/systemd/user/cosmic-caps-lock-indicator.service"
systemctl --user daemon-reload

# 2. Remove desktop entries
rm -f "$DATA_DIR/applications/cosmic-caps-lock-indicator.desktop"
rm -f "$CONFIG_DIR/autostart/cosmic-caps-lock-indicator.desktop"

# 3. Remove binary
rm -f "$BIN_DIR/cosmic-caps-lock-indicator"

# 4. Remove icons
rm -rf "$DATA_DIR/cosmic-caps-lock-indicator"
rm -f "$DATA_DIR/icons/hicolor/scalable/status/caps-lock-"*
for size in 16 22 24 32 48; do
    rm -f "$DATA_DIR/icons/hicolor/${size}x${size}/status/caps-lock-"*
done

if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q -t "$DATA_DIR/icons/hicolor" 2>/dev/null || true
fi

echo "==> Uninstallation complete."
