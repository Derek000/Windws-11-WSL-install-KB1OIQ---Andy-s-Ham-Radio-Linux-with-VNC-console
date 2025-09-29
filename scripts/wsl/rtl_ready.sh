#!/usr/bin/env bash
set -euo pipefail
log(){ printf '[%s] %s\n' "$(date -Iseconds)" "$*"; }

log "Updating…"
sudo apt-get update -y
log "Installing usb/ip tools + rtl-sdr…"
sudo apt-get install -y "linux-tools-$(uname -r)" "linux-cloud-tools-$(uname -r)" rtl-sdr usbutils
log "Loading vhci_hcd…"
sudo modprobe vhci_hcd || true
log "lsusb (expect 0bda:2838)…"
lsusb | grep -i '0bda:2838' || echo "WARNING: RTL-SDR not visible. Use usbipd attach in Windows."
log "rtl_test -t (brief)…"
rtl_test -t || true
if ! id -nG "$USER" | grep -qw plugdev; then
  sudo usermod -aG plugdev "$USER"
  log "Added $USER to plugdev (open a new shell or run: newgrp plugdev)"
fi
cat <<'RULE' | sudo tee /etc/udev/rules.d/20-rtlsdr.rules >/dev/null
SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="2838", MODE="0666", GROUP="plugdev"
RULE
sudo udevadm control --reload-rules && sudo udevadm trigger || true
log "RTL-SDR ready."
