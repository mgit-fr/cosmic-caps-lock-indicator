# COSMIC Caps Lock Indicator

A lightweight, real-time Caps Lock status indicator designed for **Pop!_OS** and the **COSMIC Desktop Environment**.

Displays whether **Caps Lock** is active or inactive directly in your top panel's status area. Especially useful for laptops and external keyboards lacking physical Caps Lock LEDs.

---

## Features

- **Top Panel Integration**: Appears in the COSMIC top panel (in `cosmic-applet-status-area`) via the FreeDesktop StatusNotifierItem standard.
- **Instant & Lightweight**: Reads direct kernel state from `/sys/class/leds` with virtually zero CPU overhead (~100 microseconds per poll) and an automatic fallback for XWayland.
- **Theme-Adaptive Icons**: Beautiful symbolic vector icons that dynamically match your active COSMIC light or dark theme.
- **Two Icon Styles**:
  - **Key Badge `[A]`**: Solid illuminated key badge when active, subtle outline key when inactive.
  - **Arrow Symbol `[⇪]`**: Standard ISO 9995-7 filled arrow with base bar when active, outlined arrow when inactive.
- **Hide When Inactive**: Optional setting to automatically hide the indicator when Caps Lock is OFF, keeping your panel completely clutter-free.
- **Desktop Toast Notifications**: Optional toast notifications on state changes.
- **Systemd User Service**: Starts automatically on login, restarts if needed, and is easily managed via `systemctl --user`.

---

## Installation

### Prerequisites

All dependencies are included by default in Pop!_OS 24.04 LTS:
- `python3`
- `gir1.2-gtk-3.0`
- `gir1.2-ayatanaappindicator3-0.1`
- `gir1.2-notify-0.7`

If needed on minimal installations, install them with:
```bash
sudo apt install python3 python3-gi gir1.2-gtk-3.0 gir1.2-ayatanaappindicator3-0.1 gir1.2-notify-0.7
```

### Install

1. Clone this repository:
   ```bash
   git clone https://github.com/mgit-fr/cosmic-caps-lock-indicator.git
   cd cosmic-caps-lock-indicator
   ```

2. Run the installer:
   ```bash
   ./install.sh
   ```
   *(Or run `make install`)*

The indicator will immediately appear in your top panel and will automatically start on subsequent logins.

---

## Configuration & Usage

Right-click the indicator icon in your top panel to open the settings menu:

- **Caps Lock Status**: Header displaying current state (`Caps Lock: ON` / `Caps Lock: OFF`).
- **Hide when inactive**: When checked, the icon is only visible while Caps Lock is locked ON.
- **Desktop notification on change**: Show quick desktop toast notifications when toggling Caps Lock.
- **Icon Style**: Switch between **Key Badge `[A]`** and **Arrow Symbol `[⇪]`**.
- **Quit**: Exits the indicator.

Settings are saved in `~/.config/cosmic-caps-lock-indicator/config.json`.

---

## Service Management

Manage the background service using `systemctl --user`:

```bash
# Check status
systemctl --user status cosmic-caps-lock-indicator

# Restart
systemctl --user restart cosmic-caps-lock-indicator

# Stop
systemctl --user stop cosmic-caps-lock-indicator

# View logs
journalctl --user -u cosmic-caps-lock-indicator -f
```

---

## Uninstallation

To remove the indicator, desktop entries, and user service:

```bash
cd cosmic-caps-lock-indicator
./uninstall.sh
```
*(Or run `make uninstall`)*

---

## License

[MIT](LICENSE)
