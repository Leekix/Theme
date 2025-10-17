#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

WALL_DIR="$HOME/.config/Wallpaper"
choice=$(ls "$WALL_DIR" | rofi -dmenu -i -p "Wallpaper:")
if [ -n "$choice" ]; then
  feh --bg-scale "$WALL_DIR/$choice"
fi
