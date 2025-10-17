#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

killall -q polybar || true
sleep 0.2
if [ -f "$HOME/.config/auto_theme_colors.sh" ]; then
	. "$HOME/.config/auto_theme_colors.sh"
	export BG FG PRIMARY ACCENT
fi

# render template if present
if [ -f "$SCRIPT_DIR/config.template" ]; then
	if command -v envsubst >/dev/null 2>&1 && [ -f "$HOME/.config/auto_theme_colors.sh" ]; then
		. "$HOME/.config/auto_theme_colors.sh"
		export BG FG PRIMARY ACCENT
		envsubst < "$SCRIPT_DIR/config.template" > "$HOME/.config/polybar/config"
	else
		cp -f "$SCRIPT_DIR/config.template" "$HOME/.config/polybar/config"
	fi
fi

polybar -c "$HOME/.config/polybar/config" top &
