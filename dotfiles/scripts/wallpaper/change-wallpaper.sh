#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/wallpapers}"

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  notify-send "Wallpaper" "Directory not found: $WALLPAPER_DIR"
  exit 1
fi

set_wallpaper() {
  local image="$1"
  if command -v swww >/dev/null 2>&1 && command -v swww-daemon >/dev/null 2>&1; then
    pgrep -x swww-daemon >/dev/null || swww-daemon
    for _ in 1 2 3 4 5; do
      if swww query >/dev/null 2>&1; then
        break
      fi
      sleep 0.2
    done
    swww img "$image" --transition-type random
    return
  fi

  if command -v awww >/dev/null 2>&1 && command -v awww-daemon >/dev/null 2>&1; then
    pgrep -x awww-daemon >/dev/null || awww-daemon
    awww img "$image"
    return
  fi

  notify-send "Wallpaper" "No wallpaper backend found (swww/awww)."
  exit 1
}

WALLPAPER="$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' \) | shuf -n 1)"
if [[ -z "$WALLPAPER" ]]; then
  notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

set_wallpaper "$WALLPAPER"

