#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

IMG="$1"
OUT="$HOME/.config/auto_theme_colors.sh"
mkdir -p "$(dirname "$OUT")"

if command -v python3 >/dev/null 2>&1; then
  python3 "$(dirname "$0")/wallpaper_palette.py" "$IMG" > "$OUT"
else
  echo "BG=#0f1117" > "$OUT"
  echo "FG=#d7dae0" >> "$OUT"
  echo "PRIMARY=#8bd5ca" >> "$OUT"
  echo "ACCENT=#c792ea" >> "$OUT"
fi

echo "Applied palette to $OUT"
