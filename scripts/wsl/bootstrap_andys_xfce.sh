#!/usr/bin/env bash
set -euo pipefail
log(){ printf '[%s] %s\n' "$(date -Iseconds)" "$*"; }

sudo apt-get update -y
log "Installing XFCE + TigerVNC + utils…"
sudo apt-get install -y xfce4 xfce4-goodies xfce4-terminal tigervnc-standalone-server dbus-x11 x11-xserver-utils policykit-1-gnome curl ca-certificates git

install -d -m 700 "$HOME/.vnc"
cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
set -e
unset WAYLAND_DISPLAY
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
export QT_QPA_PLATFORM=xcb
export XDG_CURRENT_DESKTOP=XFCE
export DESKTOP_SESSION=xfce
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_RUNTIME_DIR="$HOME/.xdg-runtime"
mkdir -p "$XDG_RUNTIME_DIR"; chmod 700 "$XDG_RUNTIME_DIR"
[ -r "$HOME/.Xresources" ] && xrdb "$HOME/.Xresources"
if command -v /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1; then
  /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &
fi
# vncconfig -nowin >/dev/null 2>&1 &
exec dbus-launch --exit-with-session startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"
sed -i 's/\r$//' "$HOME/.vnc/xstartup"

cp "$(dirname "$0")/vnc_up" "$HOME/vnc_up"
cp "$(dirname "$0")/vnc_down" "$HOME/vnc_down"
chmod +x "$HOME/vnc_up" "$HOME/vnc_down"

log "Done. Start with: ~/vnc_up"
