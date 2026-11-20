#!/bin/sh
set -eu

DEST="${HOME}/.local/bin"
mkdir -p "$DEST"
install -m 0755 monitor-input-switch "$DEST/monitor-input-switch"

echo "Installed ${DEST}/monitor-input-switch"
echo
echo "Add to ~/.config/hypr/bindings.lua:"
echo
echo "  o.bind(\"CTRL + ALT + H\", \"Monitor input: USB-C\","
echo "    \"${DEST}/monitor-input-switch 0x13\")"
echo
echo "Then run: hyprctl reload"
