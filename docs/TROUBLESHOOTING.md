# Troubleshooting

## VNC black screen
- Use `~/vnc_up` (we call `tigervncserver`, not the fragile `/usr/bin/vncserver` wrapper).
- RealVNC Viewer → set **Colour level = Full (True color)**; disable “Auto/Adapt to network speed”.
- Clear session/locks: `~/vnc_down && rm -rf ~/.cache/sessions/* && ~/vnc_up`.

## ICE/X11 permissions
```
sudo mkdir -p /tmp/.ICE-unix /tmp/.X11-unix
sudo chown root:root /tmp/.ICE-unix /tmp/.X11-unix
sudo chmod 1777 /tmp/.ICE-unix /tmp/.X11-unix
```

## usbipd “Device busy (exported)”
- Close Windows SDR apps (SDR#, SDR++, rtl_tcp, USBPcap).
- Run: `usbipd bind --busid <BUSID> --force` then `usbipd attach --wsl "<DistroName>" --busid <BUSID>`.
- If you see “reboot may be required”, reboot Windows once.

## Attach to non‑default distro
Use: `usbipd attach --wsl "<DistroName>" --busid <BUSID>` (or `--distribution "<DistroName>"` depending on version).

## Prove the pipeline
`tigervncserver -xstartup /usr/bin/xterm :2` → if xterm appears, the VNC path is good; desktop startup was at fault.
