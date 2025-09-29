# Andy's Ham Radio Linux on WSL (Windows 11) — Full Desktop + RTL-SDR

**Updated:** 2025-09-29

## Why
You want a dependable, repeatable way to run the **KB1OIQ “Andy’s Ham Radio Linux” toolset** on **Windows 11** without a heavy VM. This repo gives you a stable **XFCE desktop over VNC** in **WSL2**, plus **RTL‑SDR passthrough** via **usbipd-win**. It *then* points you to the **official sites** for the **latest versions** and helps you install the apps *after* the base environment is ready.

## Who
Hams and engineers who value clarity, speed, and reproducibility on Windows 11.

## What
- **Environment first**: WSL2 + XFCE (VNC) + usbipd-win + (optional) WSL USB Manager GUI.
- **Then visit the official sites for latest**:
  - KB1OIQ / Andy’s Ham Radio Linux: <https://sourceforge.net/projects/kb1oiq-andysham/>
  - WSL USB Manager: <https://github.com/nickbeth/wsl-usb-manager>
  - usbipd-win: <https://github.com/dorssel/usbipd-win>
- **Post-setup installers**: Choose a profile (lite/full/sdr-only) and install current packages from Ubuntu repositories.

---

## 0) Visit the official sites (always current)
Before installing ham apps, **check the latest guidance** from:
- **KB1OIQ Andy’s Ham Radio Linux (SourceForge)** — release notes, package recommendations, and updates:  
  <https://sourceforge.net/projects/kb1oiq-andysham/>
- **WSL USB Manager (GUI for USB → WSL)**:  
  <https://github.com/nickbeth/wsl-usb-manager>
- **usbipd-win** (Windows USB/IP):  
  <https://github.com/dorssel/usbipd-win>

*Why?* WSL can’t boot an ISO, but we can **replicate the toolset** on Ubuntu. Checking the sites keeps you aligned with the latest versions.

---

## 1) Windows: Enable WSL + usbipd-win + (optional) WSL USB Manager

Open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
scripts\windows\01_enable_wsl.ps1
scripts\windows\02_install_usbipd_win.ps1
# Optional GUI for USB → WSL:
scripts\windows\03_install_wsl_usb_manager.ps1
```

If you prefer to open the pages first:
```powershell
Start-Process "https://sourceforge.net/projects/kb1oiq-andysham/"
Start-Process "https://github.com/nickbeth/wsl-usb-manager"
Start-Process "https://github.com/dorssel/usbipd-win"
```

---

## 2) WSL: Bootstrap the desktop environment

Open **Ubuntu (WSL)** and run:

```bash
cd scripts/wsl
sudo bash ./bootstrap_andys_xfce.sh
./theme_ubuntu_yaru.sh   # optional
```

Start/stop VNC (localhost-only):
```bash
~/vnc_up     # start :1
~/vnc_down   # stop  :1
```
Connect with **RealVNC Viewer** to `localhost:1` and set **Colour = Full (True color)**.

You can open the Andy page from WSL too:
```bash
./open_andys_site.sh
```

---

## 3) Attach your RTL‑SDR (Windows → WSL)

**Option A – GUI (WSL USB Manager)**  
Use the app to **Share/Attach** your RTL‑SDR (VID:PID `0bda:2838`) to your target distro.

**Option B – PowerShell**  
```powershell
usbipd list
usbipd bind --busid <BUSID> --force
usbipd attach --wsl "<DistroName>" --busid <BUSID>
```

**Then in WSL**:
```bash
./rtl_ready.sh
```

---

## 4) Install Andy’s ham applications (post-setup)

1. **Read Andy’s latest guidance**:  
   <https://sourceforge.net/projects/kb1oiq-andysham/>

2. **Pick a profile and install** (from Ubuntu repos):
```bash
# In WSL
./install_andys_apps.sh full     # or: lite | sdr-only
```

The script installs commonly-used packages (fldigi, flrig, wsjtx, hamlib, gqrx, gnuradio, gr-osmosdr, direwolf, multimon-ng, sox, pat, xastir, etc.). You can re-run it safely; it’s idempotent.

> For apps that Andy ships outside Ubuntu repos (or where he recommends a newer version), follow his site’s instructions. Our script aims for **stable** defaults in Ubuntu.

---

## 5) Auto-start VNC at Windows logon

```powershell
# Registers a Task Scheduler job to run:
#   wsl.exe ~ -d "<DistroName>" -e bash -lc '~/vnc_up'
scripts\windows\register_vnc_autostart.ps1 -DistroName "Ubuntu"
```

---

## Troubleshooting & Security
See `docs/TROUBLESHOOTING.md` and `docs/SECURITY.md`.

---

## What next?
- Configure your ham apps (audio devices, CAT control, PTT).
- Keep an eye on Andy’s SourceForge page for new releases.
- Prefer **XFCE** for reliability on WSL; GNOME Shell is not recommended on headless WSL.
