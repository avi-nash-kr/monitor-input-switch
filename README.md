# monitor-input-switch

A tiny script + Hyprland keybinding that switches a monitor's input with
[`ddcutil`](https://github.com/rockowitz/ddcutil).

Built for a **BenQ EW270Q** connected by HDMI to one PC and by USB-C to
another, so `Ctrl + Alt + H` hands the display over to the other machine:

```
HDMI-1 (this PC)   --Ctrl+Alt+H-->   USB-C (the other PC)
```

VCP code `0x60` is the input source, and the BenQ uses `0x11` for HDMI-1 and
`0x13` for USB-C. Both are configurable, so this works with other monitors too.

## Install

```bash
git clone https://github.com/avi-nash-kr/monitor-input-switch.git
cd monitor-input-switch
./install.sh
```

`install.sh` copies `monitor-input-switch` to `~/.local/bin/` and makes it
executable. If `~/.local/bin` is not in your `PATH`, use the absolute path in
the keybinding (see below).

## Keybinding

For Omarchy / Hyprland, add this to `~/.config/hypr/bindings.lua`:

```lua
-- BenQ EW270Q: HDMI (this PC) -> USB-C (other PC)
o.bind("CTRL + ALT + H", "Monitor input: USB-C",
  "/home/YOUR_USER/.local/bin/monitor-input-switch 0x13")

-- Optional: switch back to HDMI
o.bind("CTRL + ALT + SHIFT + H", "Monitor input: HDMI",
  "/home/YOUR_USER/.local/bin/monitor-input-switch 0x11")
```

Replace `YOUR_USER`, then run:

```bash
hyprctl reload
hyprctl configerrors
```

For other window managers, bind the same command with whatever shortcut tool
you use. Nothing here is Hyprland-specific apart from the example binding.

## Usage

```bash
monitor-input-switch          # default: VCP 0x60 -> 0x13 (USB-C)
monitor-input-switch 0x11     # switch to HDMI-1
INPUT_VCP=60 monitor-input-switch 0x0f   # DisplayPort
```

Environment variables:

| Variable | Default | Meaning |
| --- | --- | --- |
| `INPUT_VCP` | `60` | VCP code for input source |
| `INPUT_VALUE` | `0x13` | Value to set when no argument is given |
| `DDCUTIL_DISPLAY` | unset | Force a specific ddcutil display number |
| `INPUT_RETRIES` | `3` | Number of times to retry if the readback does not match |
| `LOG_FILE` | unset | Append every run and ddcutil output to this file |

The script reads VCP `0x60` back after setting it, retries on failure, and
shows a desktop notification if the switch did not stick.

## Requirements

- `ddcutil` (Arch: `sudo pacman -S ddcutil`)
- Access to the monitor's I2C bus. On Arch, install `i2c-tools`, load the
  `i2c-dev` module and add your user to the `i2c` group, then log out and back
  in:

  ```bash
  sudo pacman -S i2c-tools
  echo i2c-dev | sudo tee /etc/modules-load.d/i2c-dev.conf
  sudo modprobe i2c-dev
  sudo usermod -aG i2c "$USER"
  ```

- An external monitor that supports DDC/CI (usually enabled in its OSD).

## Finding the right values

```bash
ddcutil detect                 # confirm the monitor is visible
ddcutil getvcp 60              # show the current input source
ddcutil capabilities | grep 'Feature: 60' -A5
```

The capabilities string lists the valid value codes, e.g. `60 (0F 11 13)`.
Use one of those with the script. ddcutil may print `Invalid value (sl=0x13)`
for a vendor-specific input such as BenQ's USB-C; the monitor still accepts it.

## Troubleshooting

- **`ddcutil: command not found`** — install it (see Requirements).
- **I2C permission errors** — check `ddcutil detect` as your user; re-login
  after joining the `i2c` group.
- **The keybinding does nothing** — verify the command works in a terminal
  first, check the path in `bindings.lua` is absolute, run `hyprctl reload`,
  and confirm with `omarchy menu keybindings --print`.
- **Want to debug a keybinding?** set `LOG_FILE` for the script or launch it
  through a wrapper and watch the log after pressing the keys.
- **It switches, then snaps back to HDMI after a while** — on the BenQ EW270Q,
  turn **OFF** `OSD > System > Advanced > Input Auto Switch` (the manual calls
  it "Sets to automatically detect the available input source"). While it is
  ON, the monitor can decide to go back to whichever input currently has a
  signal. Also check that the other PC is awake and its USB-C output is active.
- **The keyboard shortcut works once and never again** — if your keyboard or
  mouse follows the monitor through a KVM/USB-C dock, the keypress no longer
  reaches this PC once the screen moves; use the monitor's OSD to return.

## License

MIT — see [LICENSE](LICENSE).
