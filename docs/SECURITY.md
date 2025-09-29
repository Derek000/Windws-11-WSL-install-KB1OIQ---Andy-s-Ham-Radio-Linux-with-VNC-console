# Security

- VNC binds to **localhost only**. For remote access, use SSH tunnels:
  ```
  ssh -L 5901:localhost:5901 user@your-host
  ```
- Set a strong VNC password: `vncpasswd`.
- Keep Windows and WSL packages patched.
