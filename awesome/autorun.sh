#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "nm-applet"
run "flameshot"
run "nitrogen --restore"
run "slack"
run "discord"
