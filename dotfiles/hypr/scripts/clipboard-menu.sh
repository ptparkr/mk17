#!/usr/bin/env bash
set -euo pipefail

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Clipboard" "$1"
    fi
}

ensure_tools() {
    local missing=0
    for cmd in cliphist wl-copy; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo "Missing dependency: $cmd" >&2
            missing=1
        fi
    done
    [[ $missing -eq 0 ]] || exit 1
}

pick_menu() {
    if command -v rofi >/dev/null 2>&1; then
        rofi -dmenu -i -p "$1" -theme ~/.config/rofi/styles/minimal-light.rasi
    elif command -v wofi >/dev/null 2>&1; then
        wofi --dmenu -i -p "$1"
    elif command -v fuzzel >/dev/null 2>&1; then
        fuzzel --dmenu --prompt "$1"
    elif command -v bemenu >/dev/null 2>&1; then
        bemenu -p "$1"
    else
        echo "No dmenu-compatible launcher found (rofi/wofi/fuzzel/bemenu)." >&2
        exit 1
    fi
}

pick_from_history() {
    local selected
    selected="$(cliphist list | pick_menu "Clipboard History")" || exit 0
    [[ -z "$selected" ]] && exit 0
    cliphist decode <<<"$selected" | wl-copy
    notify "Copied from history"
}

copy_latest() {
    local latest
    latest="$(cliphist list | sed -n '1p')" || exit 0
    [[ -z "$latest" ]] && exit 0
    cliphist decode <<<"$latest" | wl-copy
    notify "Copied latest item"
}

delete_entry() {
    local selected
    selected="$(cliphist list | pick_menu "Delete clipboard item")" || exit 0
    [[ -z "$selected" ]] && exit 0
    cliphist delete <<<"$selected"
    notify "Deleted selected item"
}

clear_history() {
    local confirm
    confirm="$(printf "No\nYes, clear clipboard history" | pick_menu "Confirm clear")" || exit 0
    [[ "$confirm" != "Yes, clear clipboard history" ]] && exit 0
    cliphist wipe
    notify "Clipboard history cleared"
}

ensure_tools

mode="${1:-pick}"
case "$mode" in
    pick)   pick_from_history ;;
    latest) copy_latest ;;
    delete) delete_entry ;;
    clear)  clear_history ;;
    *)
        echo "Usage: $0 [pick|latest|delete|clear]" >&2
        exit 1
        ;;
esac
