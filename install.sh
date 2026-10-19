#!/usr/bin/env bash
set -e

REPO_DIR=""
BIN_DIR="/home/mike/.local/bin"
ICON_DIR="/home/mike/.local/share/cosmic-caps-lock-indicator/icons"
HICOLOR_DIR="/home/mike/.local/share/icons/hicolor"
DESKTOP_DIR="/home/mike/.local/share/applications"
AUTOSTART_DIR="/home/mike/.config/autostart"
SYSTEMD_USER_DIR="/home/mike/.config/systemd/user"

echo "==> Installing COSMIC Caps Lock Indicator..."

# 1. Directories
mkdir -p "" "" "" "" ""
mkdir -p "/scalable/status"

# 2. Binary
echo "  -> Installing executable to /cosmic-caps-lock-indicator"
install -m 755 "/bin/cosmic-caps-lock-indicator" "/cosmic-caps-lock-indicator"

# 3. Icons
echo "  -> Installing icons..."
cp ""/icons/scalable/*.svg "/"
cp ""/icons/scalable/*.svg "/scalable/status/"

python3 - << 'EOF'
import os, gi
try:
    gi.require_version('GdkPixbuf', '2.0')
    from gi.repository import GdkPixbuf

    hicolor = os.path.expanduser('~/.local/share/icons/hicolor')
    scalable = f'{hicolor}/scalable/status'

    for size in [16, 22, 24, 32, 48]:
        out_dir = f'{hicolor}/{size}x{size}/status'
        os.makedirs(out_dir, exist_ok=True)
        for svg_file in os.listdir(scalable):
            if svg_file.endswith('.svg'):
                name = svg_file[:-4]
                try:
                    loader = GdkPixbuf.PixbufLoader.new_with_type('svg')
                    loader.set_size(size, size)
                    with open(f'{scalable}/{svg_file}', 'rb') as f:
                        loader.write(f.read())
                    loader.close()
                    pb = loader.get_pixbuf()
                    pb.savev(f'{out_dir}/{name}.png', 'png', [], [])
                except Exception:
                    pass
except Exception:
    pass
EOF

if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q -t "" 2>/dev/null || true
fi

# 4. Desktop & Autostart
echo "  -> Installing desktop shortcut and autostart..."
cp "/data/cosmic-caps-lock-indicator.desktop" "/"
cp "/data/cosmic-caps-lock-indicator.desktop" "/"

# 5. Systemd User Service
echo "  -> Installing systemd user service..."
cp "/data/cosmic-caps-lock-indicator.service" "/"
systemctl --user daemon-reload
systemctl --user enable --now cosmic-caps-lock-indicator.service

echo "==> Done! The indicator is now active in your COSMIC top panel."
