#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

killall -q polybar || true
sleep 0.2
polybar -c "$SCRIPT_DIR/config" example &
