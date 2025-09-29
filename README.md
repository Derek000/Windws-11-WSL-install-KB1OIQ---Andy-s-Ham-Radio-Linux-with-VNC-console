# Andy's Ham Radio Linux on WSL (Windows 11) — Full Desktop + RTL‑SDR

**Date:** 2025-09-29

## Why
Enable a dependable way to run the KB1OIQ “Andy’s Ham Radio Linux” experience on Windows 11 using **WSL2** — with a **stable XFCE desktop via VNC** and **RTL‑SDR passthrough** using either **usbipd‑win (PowerShell)** _or_ **WSL USB Manager**.

## Who
Hams and engineers who want a reproducible, low‑friction setup on Windows 11 (Admin rights required for first‑time driver binding).

## What
This repo contains:
- Windows scripts to enable WSL, install **usbipd‑win**, optionally install **WSL USB Manager**, attach/detach RTL‑SDR, and auto‑start VNC at logon.
- WSL scripts to bootstrap **XFCE + TigerVNC**, start/stop VNC, prepare RTL‑SDR, and apply an Ubuntu‑like theme.
- Task Scheduler XML to auto‑start `wsl.exe ~ -e ~/vnc_up` at user logon.

> Note: We don’t redistribute WSL USB Manager binaries. The included script downloads the latest release directly from its GitHub repository (nickbeth/wsl-usb-manager).

---

## Quick Start

### 1) Windows (PowerShell)

Open **PowerShell as Administrator**, then run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force

# 1. Enable WSL2 (one-time)
scripts\windows\01_enable_wsl.ps1

# 2. Install/upgrade usbipd‑win (one-time)
scripts\windows\02_install_usbipd_win.ps1

# 3. (Optional) Install WSL USB Manager from GitHub releases
scripts\windows\03_install_wsl_usb_manager.ps1
```

> If you prefer the GUI path, launch **WSL USB Manager** and use it to **Share/Attach** your RTL‑SDR to your chosen WSL distro.

### 2) WSL (Ubuntu terminal)

```bash
cd ~/wsl-andys-ham-linux/scripts/wsl
sudo bash ./bootstrap_andys_xfce.sh
./theme_ubuntu_yaru.sh   # optional
```

Start and stop VNC:

```bash
~/vnc_up      # start :1
~/vnc_down    # stop  :1
```

Connect with **RealVNC Viewer** to `localhost:1` with **Colour = Full (True color)**.

### 3) RTL‑SDR to WSL

**Option A – GUI (WSL USB Manager)**  
- Open **WSL USB Manager** → Share/Attach your RTL‑SDR (VID:PID `0bda:2838`) to your target distro.

**Option B – PowerShell**  
```powershell
usbipd list
usbipd bind --busid <BUSID> --force
usbipd attach --wsl "<DistroName>" --busid <BUSID>
```
Then in WSL:
```bash
./rtl_ready.sh
```

### 4) Auto‑start VNC at Windows logon

```powershell
# Registers a Task Scheduler job that runs:
#   wsl.exe ~ -e bash -lc '~/vnc_up'
scripts\windows\register_vnc_autostart.ps1 -DistroName "Ubuntu"
```

---

## Notes
- VNC is **localhost‑only**; use SSH tunnelling for remote access.
- GNOME Shell is not recommended on headless WSL; XFCE is used for reliability.
- For the KB1OIQ image content, install packages you need inside the XFCE desktop (e.g., fldigi, wsjtx, direwolf, chirp, gnuradio).

See `docs/TROUBLESHOOTING.md` and `docs/FAQ.md` for more.
