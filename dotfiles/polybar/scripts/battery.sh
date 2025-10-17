#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if [ -d /sys/class/power_supply ]; then
  for d in /sys/class/power_supply/*; do
    if [ -f "$d/capacity" ]; then
      cap=$(cat "$d/capacity")
      stat="$(cat "$d/status" 2>/dev/null || echo Unknown)"
      echo "Battery: $cap% ($stat)"
      exit 0
    fi
  done
fi

echo "Battery: N/A"
