#!/usr/bin/env bash
set -euo pipefail

run_cava() {
  if command -v kitty >/dev/null 2>&1; then
    exec kitty --title "Cava" sh -lc "cava"
  else
    notify-send "Cava" "kitty is required to launch cava."
    exit 1
  fi
}

if ! command -v cava >/dev/null 2>&1; then
  notify-send "Cava" "cava is not installed."
  exit 1
fi

run_cava
