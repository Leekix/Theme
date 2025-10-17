#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

LOGFILE="$HOME/.local/share/auto-bspwm-theme.log"
exec > >(tee -a "$LOGFILE") 2>&1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

apply_theme() {
  echo "Applying GTK theme and icons (if supported)"
  # Use gsettings if available
  if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" || true
    gsettings set org.gnome.desktop.interface monospace-font-name "FiraCode 11" || true
  fi

  echo "Setting wallpaper (first image in assets)"
  if [ -d "$SCRIPT_DIR/assets/wallpapers" ]; then
    d="$SCRIPT_DIR/assets/wallpapers"
  elif [ -d "$SCRIPT_DIR/assets/wallpaper" ]; then
    d="$SCRIPT_DIR/assets/wallpaper"
  else
    d=""
  fi
  if [ -n "$d" ]; then
    first=$(ls "$d" | head -n1 || true)
    if [ -n "$first" ]; then
      feh --bg-scale "$d/$first" || true
    fi
  fi

  echo "Restarting picom and polybar"
  pkill -f picom || true
  picom --config "$HOME/.config/picom/picom.conf" &

  if [ -x "$HOME/.config/polybar/launch.sh" ]; then
    "$HOME/.config/polybar/launch.sh" || true
  fi
}

apply_theme

exit 0
