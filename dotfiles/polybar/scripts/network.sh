#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E "^e|^w" | head -n1 || true)
if [ -n "$iface" ]; then
  state=$(cat /sys/class/net/$iface/operstate 2>/dev/null || echo down)
  if [ "$state" = "up" ]; then
    ipaddr=$(ip -4 addr show dev $iface | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n1)
    echo "Net: $iface $ipaddr"
  else
    echo "Net: $iface down"
  fi
else
  echo "Net: N/A"
fi
