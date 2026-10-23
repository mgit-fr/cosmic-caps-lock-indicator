#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

ICON_DIR="$DATA_DIR/cosmic-caps-lock-indicator/icons"
HICOLOR_DIR="$DATA_DIR/icons/hicolor"
DESKTOP_DIR="$DATA_DIR/applications"
AUTOSTART_DIR="$CONFIG_DIR/autostart"
SYSTEMD_USER_DIR="$CONFIG_DIR/systemd/user"

echo "==> Installing COSMIC Caps Lock Indicator..."

# 1. Ensure target directories exist
mkdir -p "$BIN_DIR" "$ICON_DIR" "$DESKTOP_DIR" "$AUTOSTART_DIR" "$SYSTEMD_USER_DIR"
mkdir -p "$HICOLOR_DIR/scalable/status"

# 2. Install executable
echo "  -> Installing executable to $BIN_DIR/cosmic-caps-lock-indicator"
install -m 755 "$REPO_DIR/bin/cosmic-caps-lock-indicator" "$BIN_DIR/cosmic-caps-lock-indicator"

# 3. Install icons
echo "  -> Installing icons..."
cp "$REPO_DIR"/icons/scalable/*.svg "$ICON_DIR/"
cp "$REPO_DIR"/icons/scalable/*.svg "$HICOLOR_DIR/scalable/status/"

# Render PNG sizes if python and GdkPixbuf are available
HICOLOR_TARGET="$HICOLOR_DIR" python3 - << 'EOF'
import os, gi
try:
    gi.require_version('GdkPixbuf', '2.0')
    from gi.repository import GdkPixbuf

    hicolor = os.environ.get('HICOLOR_TARGET', os.path.expanduser('~/.local/share/icons/hicolor'))
    scalable = os.path.join(hicolor, 'scalable', 'status')

    for size in [16, 22, 24, 32, 48]:
        out_dir = os.path.join(hicolor, f'{size}x{size}', 'status')
        os.makedirs(out_dir, exist_ok=True)
        if os.path.isdir(scalable):
            for svg_file in os.listdir(scalable):
                if svg_file.endswith('.svg') and svg_file.startswith('caps-lock-'):
                    name = svg_file[:-4]
                    try:
                        loader = GdkPixbuf.PixbufLoader.new_with_type('svg')
                        loader.set_size(size, size)
                        with open(os.path.join(scalable, svg_file), 'rb') as f:
                            loader.write(f.read())
                        loader.close()
                        pb = loader.get_pixbuf()
                        pb.savev(os.path.join(out_dir, f'{name}.png'), 'png', [], [])
                    except Exception:
                        pass
except Exception:
    pass
EOF

if command -v gtk-update-icon-cache &>/dev/null; then
    gtk-update-icon-cache -f -q -t "$HICOLOR_DIR" 2>/dev/null || true
fi

# 4. Install desktop entry and autostart
echo "  -> Installing desktop shortcut and autostart..."
sed "s|Exec=.*|Exec=$BIN_DIR/cosmic-caps-lock-indicator|g" "$REPO_DIR/data/cosmic-caps-lock-indicator.desktop" > "$DESKTOP_DIR/cosmic-caps-lock-indicator.desktop"
cp "$DESKTOP_DIR/cosmic-caps-lock-indicator.desktop" "$AUTOSTART_DIR/"

# 5. Install and enable systemd user service
echo "  -> Installing systemd user service..."
cp "$REPO_DIR/data/cosmic-caps-lock-indicator.service" "$SYSTEMD_USER_DIR/"
systemctl --user daemon-reload
systemctl --user enable --now cosmic-caps-lock-indicator.service

echo "==> Done! The indicator is now active in your COSMIC top panel."
