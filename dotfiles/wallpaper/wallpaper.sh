#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

WALL_DIR="$HOME/.config/Wallpaper"
if [ ! -d "$WALL_DIR" ]; then
  mkdir -p "$WALL_DIR"
fi

case "${1-}" in
  random)
    FILE=$(ls "$WALL_DIR" | shuf -n1)
    ;;
  *)
    FILE=$(ls "$WALL_DIR" | head -n1)
    ;;
esac

feh --bg-scale "$WALL_DIR/$FILE"

