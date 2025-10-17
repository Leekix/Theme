# Auto BSPWM Minimal Theme

Minimal automated setup for BSPWM + sxhkd + polybar + picom + rofi + terminal themes.

Files:
- install.sh: installer and linker
- theme.sh: apply theme and restart services
- dotfiles/: bspwm, sxhkd, polybar, rofi, picom, wallpaper scripts
- assets/: wallpapers and icons

Usage:
1. Copy your wallpapers into `assets/wallpapers` or `assets/wallpaper` (both supported)
2. Make scripts executable (Linux/WSL):

```bash
chmod +x install.sh theme.sh verify.sh dotfiles/polybar/launch.sh dotfiles/rofi/wallpaper-rofi.sh scripts/wallpaper-downloader.sh
```

3. Run installer (may request sudo):

```bash
./install.sh
```

4. Apply theme/services:

```bash
./theme.sh
```

5. Verify installation:

```bash
./verify.sh
```

Troubleshooting:
- If polybar doesn't appear, run `~/.config/polybar/launch.sh` manually and check `~/.local/share/auto-bspwm-install.log` and `~/.local/share/auto-bspwm-theme.log`.
- If fonts are missing, run `fc-cache -fv` and re-run `install.sh`.

Applying wallpaper-derived palette (optional manual steps):

```bash
# Generate palette from wallpaper (assumes single image in assets/wallpapers)
python3 scripts/wallpaper_palette.py ~/.config/Wallpaper/$(ls ~/.config/Wallpaper | head -n1) > ~/.config/auto_theme_colors.sh
# or use helper
./scripts/apply_palette.sh ~/.config/Wallpaper/$(ls ~/.config/Wallpaper | head -n1)

# regenerate polybar config and launch
~/.config/polybar/launch.sh
```

