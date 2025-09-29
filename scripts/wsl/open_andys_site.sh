#!/usr/bin/env bash
# Open Andy's SourceForge page in the Windows default browser from WSL
set -euo pipefail
URL="https://sourceforge.net/projects/kb1oiq-andysham/"
if command -v wslview >/dev/null 2>&1; then
  wslview "$URL"
else
  /mnt/c/Windows/explorer.exe "$URL"
fi
