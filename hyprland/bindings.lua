-- Example Omarchy/Hyprland bindings for monitor-input-switch.
-- Copy the lines you want into ~/.config/hypr/bindings.lua and set the path
-- to the installed script (run ./install.sh first).

-- BenQ EW270Q: HDMI (this PC) -> USB-C (other PC)
o.bind("CTRL + ALT + H", "Monitor input: USB-C",
  "/home/YOUR_USER/.local/bin/monitor-input-switch 0x13")

-- Optional: switch back to HDMI-1
o.bind("CTRL + ALT + SHIFT + H", "Monitor input: HDMI",
  "/home/YOUR_USER/.local/bin/monitor-input-switch 0x11")
