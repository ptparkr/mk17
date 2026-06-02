#!/usr/bin/env bash
set -euo pipefail

WAYBAR_CSS_DIR="$HOME/.config/waybar/themes/css"
WAYBAR_CSS_FILE="$HOME/.config/waybar/style.css"
WAYBAR_JSONC_DIR="$HOME/.config/waybar/themes/jsonc"
WAYBAR_JSONC_FILE="$HOME/.config/waybar/config.jsonc"
ROFI_THEMES_DIR="$HOME/.config/rofi/themes"
ROFI_THEME_FILE="$HOME/.config/rofi/theme.rasi"
CURRENT_THEME_FILE="$HOME/.config/waybar/themes/current-theme"

for dir in "$WAYBAR_CSS_DIR" "$WAYBAR_JSONC_DIR" "$ROFI_THEMES_DIR"; do
  [[ ! -d "$dir" ]] && echo "Error: $dir not found" && exit 1
done

# Build a list of theme names available in all three places.
themes=()
for css in "$WAYBAR_CSS_DIR"/*.css; do
  name="$(basename "$css" .css)"
  [[ -f "$WAYBAR_JSONC_DIR/$name.jsonc" ]] || continue
  [[ -f "$ROFI_THEMES_DIR/$name.rasi" ]] || continue
  themes+=("$name")
done

if [[ ${#themes[@]} -eq 0 ]]; then
  echo "Error: No matching themes found (waybar css/jsonc + rofi rasi)"
  exit 1
fi

# Get the current theme
current_theme="$(<"$CURRENT_THEME_FILE" 2>/dev/null || true)"
current_theme="$(basename "$current_theme")"
current_theme="${current_theme%.css}"
current_theme="${current_theme%.jsonc}"
current_theme="${current_theme%.rasi}"

# Find the index of the current theme
next_theme_index=0
for i in "${!themes[@]}"; do
  [[ "${themes[$i]}" == "$current_theme" ]] && next_theme_index=$(((i + 1) % ${#themes[@]})) && break
done

# Get the new theme
new_theme="${themes[$next_theme_index]}"
new_waybar_css="$WAYBAR_CSS_DIR/$new_theme.css"
new_waybar_jsonc="$WAYBAR_JSONC_DIR/$new_theme.jsonc"
new_rofi_theme="$ROFI_THEMES_DIR/$new_theme.rasi"

# Save the new theme
echo "$new_theme" >"$CURRENT_THEME_FILE"

declare -A theme_files=(
  ["$new_waybar_css"]="$WAYBAR_CSS_FILE"
  ["$new_waybar_jsonc"]="$WAYBAR_JSONC_FILE"
  ["$new_rofi_theme"]="$ROFI_THEME_FILE"
)

for src in "${!theme_files[@]}"; do
  ln -sf "$src" "${theme_files[$src]}"
done

# Restart Waybar to apply changes
killall waybar || true
nohup waybar >/dev/null 2>&1 &
