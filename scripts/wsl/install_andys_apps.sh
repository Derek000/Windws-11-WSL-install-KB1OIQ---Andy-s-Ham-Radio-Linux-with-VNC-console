#!/usr/bin/env bash
# install_andys_apps.sh — Post-setup installer for common ham apps on Ubuntu (WSL)
set -euo pipefail
PROFILE="${1:-full}"   # lite | full | sdr-only
log(){ printf '[%s] %s\n' "$(date -Iseconds)" "$*"; }

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script targets Ubuntu (apt). Exiting."
  exit 1
fi

sudo apt-get update -y

common=( \
  hamlib sox multimon-ng \
  libvolk2-bin \
  qsstv \
  )
sdr=( \
  rtl-sdr gqrx-sdr gnuradio gr-osmosdr \
  )
lite=( \
  fldigi flrig wsjtx direwolf \
  )
full=( \
  "${lite[@]}" \
  xastir pat \
  chirp \
  )

case "$PROFILE" in
  sdr-only)   pkgs=("${common[@]}" "${sdr[@]}");;
  lite)       pkgs=("${common[@]}" "${sdr[@]}" "${lite[@]}");;
  full)       pkgs=("${common[@]}" "${sdr[@]}" "${full[@]}");;
  *)          echo "Unknown profile: $PROFILE (use: lite | full | sdr-only)"; exit 2;;
fi

log "Installing profile '$PROFILE' packages…"
sudo apt-get install -y "${pkgs[@]}" || true

log "Done. Review Andy's site for newer versions or extra tools:"
log "  https://sourceforge.net/projects/kb1oiq-andysham/"
