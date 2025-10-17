#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Download sample wallpapers from unsplash (small curated set)
OUTDIR="${1:-$HOME/.config/Wallpaper}"
mkdir -p "$OUTDIR"

urls=(
  "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1920"
  "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1920"
  "https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d?w=1920"
)

i=1
for u in "${urls[@]}"; do
  out="$OUTDIR/wallpaper_$i.jpg"
  curl -sL "$u" -o "$out" || true
  i=$((i+1))
done

echo "Downloaded sample wallpapers to $OUTDIR"
