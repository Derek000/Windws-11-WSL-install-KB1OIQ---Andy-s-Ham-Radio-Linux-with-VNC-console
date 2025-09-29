#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update -y
sudo apt-get install -y yaru-theme-gtk yaru-theme-icon fonts-ubuntu
xfconf-query -c xsettings -p /Net/ThemeName -s "Yaru" || true
xfconf-query -c xsettings -p /Net/IconThemeName -s "Yaru" || true
xfconf-query -c xsettings -p /Gtk/FontName -s "Ubuntu 10" || true
echo "Applied Yaru theme."
