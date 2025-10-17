#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "Verifying dotfiles and tools..."
errs=0

check_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "MISSING: $1"
    errs=$((errs+1))
  else
    echo "OK: $1"
  fi
}

for cmd in bspwm sxhkd polybar picom rofi feh; do
  check_cmd "$cmd"
done

echo "Checking symlinks"
for f in "$HOME/.config/bspwm/bspwmrc" "$HOME/.config/sxhkd/sxhkdrc" "$HOME/.config/polybar/config"; do
  if [ -L "$f" ]; then
    echo "LINK OK: $f -> $(readlink -f "$f")"
  elif [ -e "$f" ]; then
    echo "FILE OK: $f"
  else
    echo "MISSING: $f"
    errs=$((errs+1))
  fi
done

if [ $errs -eq 0 ]; then
  echo "All checks passed"
  exit 0
else
  echo "$errs issues detected"
  exit 2
fi
