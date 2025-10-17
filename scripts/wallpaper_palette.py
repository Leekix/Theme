#!/usr/bin/env python3
"""
Generate a simple color palette from an image using Pillow.
Outputs 4 hex colors: bg, fg, primary, accent
"""
import sys
from collections import Counter
try:
    from PIL import Image
except Exception:
    print('ERROR: Pillow not installed', file=sys.stderr)
    sys.exit(2)

def hexify(rgb):
    return '#%02x%02x%02x' % rgb

def dominant_colors(img_path, n=4):
    im = Image.open(img_path).convert('RGB')
    im = im.resize((200, 200))
    pixels = list(im.getdata())
    cnt = Counter(pixels)
    common = [c for c, _ in cnt.most_common(n*3)]
    # take distinct
    uniq = []
    for c in common:
        if c not in uniq:
            uniq.append(c)
        if len(uniq) >= n:
            break
    while len(uniq) < n:
        uniq.append((0,0,0))
    return [hexify(c) for c in uniq[:n]]

def average_color(img_path):
    im = Image.open(img_path).convert('RGB')
    im = im.resize((50,50))
    pixels = list(im.getdata())
    r = sum(p[0] for p in pixels)//len(pixels)
    g = sum(p[1] for p in pixels)//len(pixels)
    b = sum(p[2] for p in pixels)//len(pixels)
    return hexify((r,g,b))

def main():
    if len(sys.argv) < 2:
        print('Usage: wallpaper_palette.py /path/to/wallpaper.jpg', file=sys.stderr)
        sys.exit(1)
    path = sys.argv[1]
    try:
        cols = dominant_colors(path, 4)
    except Exception:
        cols = ['#0f1117','#d7dae0','#8bd5ca','#c792ea']
    # Output JSON-like simple lines
    print('BG=%s' % cols[0])
    print('FG=%s' % cols[1])
    print('PRIMARY=%s' % cols[2])
    print('ACCENT=%s' % cols[3])

if __name__ == '__main__':
    main()
