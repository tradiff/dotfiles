#!/bin/bash

# Move all floating windows to desktop 7, and ensure they are not off-screen

floating_workspace=7
floating_windows=$(hyprctl clients -j | jq -r '.[] | select(.floating == true) | .address')

# Loop through each floating window and move it to the floating workspace
for window in $floating_windows; do
  hyprctl dispatch movetoworkspace "$floating_workspace,address:$window"
  
  # Ensure the window is not off-screen
  hyprctl dispatch movewindowpixel exact 15 50,address:$window
done

