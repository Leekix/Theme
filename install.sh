#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

LOGFILE="$HOME/.local/share/auto-bspwm-install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "== Auto BSPWM installer starting =="

PKGS_BASE=(bspwm sxhkd polybar picom rofi feh git curl wget)
TERMINAL_CANDIDATES=(kitty alacritty)

backup_file() {
  local f="$1"
  if [ -e "$f" ] && [ ! -L "$f" ]; then
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    mkdir -p "$HOME/.dotfiles_backup"
    mv "$f" "$HOME/.dotfiles_backup/$(basename "$f").$stamp"
    echo "Backed up $f"
  fi
}

detect_pkg_manager() {
  if command -v pacman >/dev/null 2>&1; then
    echo pacman
  elif command -v apt >/dev/null 2>&1; then
    echo apt
  elif command -v dnf >/dev/null 2>&1; then
    echo dnf
  else
    echo unknown
  fi
}

PKG_MANAGER=$(detect_pkg_manager)
echo "Detected package manager: $PKG_MANAGER"

install_packages() {
  case "$PKG_MANAGER" in
    pacman)
      sudo pacman -Sy --noconfirm "${PKGS_BASE[@]}" || true
      ;;
    apt)
      sudo apt update
      sudo apt install -y "${PKGS_BASE[@]}"
      ;;
    dnf)
      sudo dnf install -y "${PKGS_BASE[@]}"
      ;;
    *)
      echo "Unknown package manager. Please install packages: ${PKGS_BASE[*]}";
      ;;
  esac
}

link_dotfile() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  # remove stale symlink, backup real files
  if [ -L "$dst" ]; then
    echo "Removing stale symlink $dst"
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    backup_file "$dst"
    rm -rf "$dst"
  fi
  ln -s "$src" "$dst"
  echo "Linked $dst -> $src"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing packages (may require sudo)"
install_packages || true

echo "Linking dotfiles"
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
link_dotfile "$DOTFILES_DIR/bspwm/bspwmrc" "$HOME/.config/bspwm/bspwmrc"
link_dotfile "$DOTFILES_DIR/sxhkd/sxhkdrc" "$HOME/.config/sxhkd/sxhkdrc"
link_dotfile "$DOTFILES_DIR/polybar/config" "$HOME/.config/polybar/config"
link_dotfile "$DOTFILES_DIR/polybar/launch.sh" "$HOME/.config/polybar/launch.sh"
link_dotfile "$DOTFILES_DIR/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
link_dotfile "$DOTFILES_DIR/picom/picom.conf" "$HOME/.config/picom/picom.conf"
link_dotfile "$DOTFILES_DIR/wallpaper/wallpaper.sh" "$HOME/.config/wallpaper/wallpaper.sh"

# copy polybar helper scripts
mkdir -p "$HOME/.config/polybar/scripts"
cp -rn "$DOTFILES_DIR/polybar/scripts/"* "$HOME/.config/polybar/scripts/" || true

for term in "${TERMINAL_CANDIDATES[@]}"; do
  if command -v "$term" >/dev/null 2>&1; then
    echo "Found terminal: $term"
    # support common config names
    if [ -f "$DOTFILES_DIR/terminal/${term}.conf" ]; then
      link_dotfile "$DOTFILES_DIR/terminal/${term}.conf" "$HOME/.config/$term/config"
    elif [ -f "$DOTFILES_DIR/terminal/${term}.config" ]; then
      link_dotfile "$DOTFILES_DIR/terminal/${term}.config" "$HOME/.config/$term/config"
    else
      # generic link if directory exists
      link_dotfile "$DOTFILES_DIR/terminal/" "$HOME/.config/$term/"
    fi
    break
  fi
done

echo "Installing fonts (FiraCode, JetBrainsMono, NerdFonts mono)"
mkdir -p "$HOME/.local/share/fonts"
if [ ! -f "$HOME/.local/share/fonts/FiraCode-Regular.ttf" ]; then
  curl -L -o /tmp/FiraCode.zip "https://github.com/tonsky/FiraCode/releases/download/6.2/FiraCode_6.2.zip" || true
  unzip -o /tmp/FiraCode.zip -d /tmp/firacode || true
  cp -v /tmp/firacode/ttf/*.ttf "$HOME/.local/share/fonts/" || true
fi

# JetBrains Mono (official)
if [ ! -f "$HOME/.local/share/fonts/JetBrainsMono-Regular.ttf" ]; then
  echo "Downloading JetBrains Mono"
  curl -L -o /tmp/JetBrainsMono.zip "https://github.com/JetBrains/JetBrainsMono/releases/latest/download/JetBrainsMono-*.zip" || true
  unzip -o /tmp/JetBrainsMono.zip -d /tmp/jbm || true
  cp -v /tmp/jbm/ttf/*.ttf "$HOME/.local/share/fonts/" || true
fi

# Nerd Fonts (JetBrainsMono patched)
if ! ls "$HOME/.local/share/fonts" | grep -i nerd >/dev/null 2>&1; then
  echo "Downloading Nerd Fonts (JetBrainsMono patched)"
  mkdir -p /tmp/nerdfonts
  curl -L -o /tmp/nerdfonts/JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip" || true
  unzip -o /tmp/nerdfonts/JetBrainsMono.zip -d /tmp/nerdfonts/jbm || true
  cp -v /tmp/nerdfonts/jbm/*.ttf "$HOME/.local/share/fonts/" || true
fi

fc-cache -fv || true

echo "Copying assets"
mkdir -p "$HOME/.config/Wallpaper"
if [ -d "$SCRIPT_DIR/assets/wallpapers" ]; then
  cp -rn "$SCRIPT_DIR/assets/wallpapers/"* "$HOME/.config/Wallpaper/" || true
elif [ -d "$SCRIPT_DIR/assets/wallpaper" ]; then
  cp -rn "$SCRIPT_DIR/assets/wallpaper/"* "$HOME/.config/Wallpaper/" || true
else
  echo "No wallpapers found in assets/wallpapers or assets/wallpaper"
fi

echo "Linking autostart (bspwmrc)"
link_dotfile "$DOTFILES_DIR/bspwm/bspwmrc" "$HOME/.config/bspwm/bspwmrc"

# Try to install Papirus icon theme via package manager if available
case "$PKG_MANAGER" in
  pacman)
    sudo pacman -S --noconfirm papirus-icon-theme || true
    ;;
  apt)
    sudo apt install -y papirus-icon-theme || true
    ;;
  dnf)
    sudo dnf install -y papirus-icon-theme || true
    ;;
  *)
    echo "Install Papirus icon theme manually if desired"
    ;;
esac

echo "Setup complete. Please start/restart your X session and run: ~/.config/polybar/launch.sh"

exit 0
