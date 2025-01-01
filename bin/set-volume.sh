#!/bin/bash

ICON_DIR="$HOME/.config/dunst/icons"

get_muted() {
  [ "$(pamixer --get-mute)" == "true" ]
}

get_volume() {
  if get_muted; then
    echo "Muted"
  else
    volume=$(pamixer --get-volume)
    echo "$volume"
  fi
}

get_icon() {
  current=$(get_volume)
  if [[ "$current" == "Muted" ]]; then
    echo "$ICON_DIR/volume-mute.png"
  elif [[ "$current" -le 30 ]]; then
    echo "$ICON_DIR/volume-low.png"
  elif [[ "$current" -le 60 ]]; then
    echo "$ICON_DIR/volume-mid.png"
  else
    echo "$ICON_DIR/volume-high.png"
  fi
}

notify_user() {
  if get_muted; then
    notify-send --replace-id=91190 --transient --urgency=low --icon "$(get_icon)" --app-name="volume" --expire-time=1000 "Volume: Muted"
  else
    notify-send --replace-id=91190 --transient --urgency=low --icon "$(get_icon)" --app-name="volume" --expire-time=1000 --hint int:value:"$(get_volume)" "Volume"
  fi
}

increase_volume() {
  if get_muted; then
    toggle_mute
  else
    pamixer -i 5 --allow-boost --set-limit 150
    notify_user
  fi
}

decrease_volume() {
  if get_muted; then
    toggle_mute
  else
    pamixer -d 5
    notify_user
  fi
}

toggle_mute() {
  if get_muted; then
    pamixer -u
    notify_user
  else
    pamixer -m
    notify_user
  fi
}

case "$1" in
"--increase")
  increase_volume
  ;;
"--decrease")
  decrease_volume
  ;;
"--toggle-mute")
  toggle_mute
  ;;
*)
  echo "Error: Invalid parameter. Usage: $(basename "$0") [--increase|--decrease|--toggle-mute]" >&2
  exit 1
  ;;
esac
