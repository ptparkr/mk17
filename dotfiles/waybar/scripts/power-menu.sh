#!/usr/bin/env bash
set -euo pipefail

config="$HOME/.config/rofi/power-menu.rasi"

actions=$(
  printf '%s\n' \
    "  Suspend" \
    "  Lock" \
    "  Shutdown" \
    "  Reboot" \
    "  Hibernate" \
    "󰞘  Logout"
)

# Display logout menu
selected_option="$(printf '%s' "$actions" | rofi -dmenu -i -no-custom -p "Power" -config "${config}" || true)"
[[ -z "${selected_option}" ]] && exit 0

# Perform actions based on the selected option
case "$selected_option" in
*Suspend)
  systemctl suspend
  loginctl lock-session
  ;;
*Shutdown)
  systemctl poweroff
  ;;
*Reboot)
  systemctl reboot
  ;;
*Lock)
  loginctl lock-session
  ;;
*Hibernate)
  systemctl hibernate
  ;;
*Logout)
  loginctl kill-session "$XDG_SESSION_ID"
  ;;
esac
