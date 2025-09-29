# FAQ

**Q: Why not GNOME Shell?**  
A: On headless WSL, Mutter/Clutter often fails due to missing systemd/logind/GPU. XFCE is reliable.

**Q: Can I use TigerVNC Viewer instead of RealVNC?**  
A: Yes. TigerVNC matches the server closely and avoids colour‑depth negotiation issues.

**Q: How do I make it start at logon?**  
A: Use `scripts/windows/register_vnc_autostart.ps1` which registers a Task Scheduler job to run `wsl.exe ~ -e bash -lc '~/vnc_up'` at user logon.
