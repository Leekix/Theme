#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Autostart helpers for bspwm session
feh --bg-scale "$HOME/.config/Wallpaper/$(ls "$HOME/.config/Wallpaper" | head -n1 || true)" &
picom --config "$HOME/.config/picom/picom.conf" &
"$HOME/.config/polybar/launch.sh" &
