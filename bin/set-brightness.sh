#!/bin/bash

ICON_DIR="$HOME/.config/dunst/icons"

get_brightness() {
  brightnessctl -m | cut -d, -f4 | sed 's/%//'
}

get_icon() {
  current=$(get_brightness)
  if [ "$current" -le "20" ]; then
    echo "$ICON_DIR/brightness-20.png"
  elif [ "$current" -le "40" ]; then
    echo "$ICON_DIR/brightness-40.png"
  elif [ "$current" -le "60" ]; then
    echo "$ICON_DIR/brightness-60.png"
  elif [ "$current" -le "80" ]; then
    echo "$ICON_DIR/brightness-80.png"
  else
    echo "$ICON_DIR/brightness-100.png"
  fi
}

notify_user() {
  notify-send --replace-id=91190 --transient --urgency=low --icon "$(get_icon)" --app-name="volume" --expire-time=1000 --hint int:value:"$(get_brightness)" "Brightness"
}

increase_brightness() {
  brightnessctl -e set 5%+
  notify_user
}

decrease_brightness() {
  brightnessctl -e set 5%-
  notify_user
}

case "$1" in
"--increase")
  increase_brightness
  ;;
"--decrease")
  decrease_brightness
  ;;
*)
  echo "Error: Invalid parameter. Usage: $(basename "$0") [--increase|--decrease]" >&2
  exit 1
  ;;
esac
