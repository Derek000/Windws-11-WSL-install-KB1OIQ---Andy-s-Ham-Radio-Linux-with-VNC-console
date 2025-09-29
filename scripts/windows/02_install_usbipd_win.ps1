# 02_install_usbipd_win.ps1
# Run in PowerShell (Admin recommended)
winget install --id Microsoft.usbipd-win -e --source winget
usbipd --version
