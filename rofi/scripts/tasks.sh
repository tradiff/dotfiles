#!/bin/bash

terminal="/usr/bin/wezterm start --always-new-process --"
config_file="$HOME/.config/rofi/scripts/tasks.json"
tasks=$(cat "$config_file")

if [[ $# -gt 0 ]]; then
  if [[ $ROFI_RETV -ne 1 ]]; then
    exit 2
  fi

  task=$(echo "$tasks" | jq ".[] | select(.name == \"$1\")")
  task_command=$(echo "$task" | jq ".command")
  coproc ( eval "\"$task_command\" >>/tmp/task.log 2>&1" )
  exit 0
else
  if [[ $ROFI_RETV -ne 0 ]]; then
    exit 3
  fi
  echo "$tasks" | jq -r '.[] | .name + "\u0000icon\u001f" + .icon' | awk '{ printf "%s\n", $0 }'
fi
