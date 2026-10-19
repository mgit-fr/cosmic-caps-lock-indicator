#!/usr/bin/env bash
set -e

echo "==> Uninstalling COSMIC Caps Lock Indicator..."

# 1. Stop and disable systemd service
systemctl --user stop cosmic-caps-lock-indicator.service 2>/dev/null || true
systemctl --user disable cosmic-caps-lock-indicator.service 2>/dev/null || true
rm -f "/home/mike/.config/systemd/user/cosmic-caps-lock-indicator.service"
systemctl --user daemon-reload

# 2. Remove desktop entries
rm -f "/home/mike/.local/share/applications/cosmic-caps-lock-indicator.desktop"
rm -f "/home/mike/.config/autostart/cosmic-caps-lock-indicator.desktop"

# 3. Remove binary
rm -f "/home/mike/.local/bin/cosmic-caps-lock-indicator"

# 4. Remove icons
rm -rf "/home/mike/.local/share/cosmic-caps-lock-indicator"
rm -f "/home/mike/.local/share/icons/hicolor/scalable/status/caps-lock-"*
for size in 16 22 24 32 48; do
    rm -f "/home/mike/.local/share/icons/hicolor/x/status/caps-lock-"*
done

if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q -t "/home/mike/.local/share/icons/hicolor" 2>/dev/null || true
fi

echo "==> Uninstallation complete."
