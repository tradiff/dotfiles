#!/bin/bash

monitor_count=$(hyprctl monitors -j | jq length)

laptop_monitor="eDP-1"
current_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Move workspace 9 to the laptop monitor
hyprctl dispatch moveworkspacetomonitor 9 "$laptop_monitor"

# Move other workspaces to current monitor
for ws in 1 2 3 4 5 6 7 8 10; do
    hyprctl dispatch moveworkspacetomonitor $ws "$current_monitor"
done

# Move floating windows to workspace 7 and reposition them
floating_workspace=7

monitor_info=$(hyprctl monitors -j | jq -r ".[] | select(.name == \"$current_monitor\")")
monitor_x=$(echo "$monitor_info" | jq -r '.x')
monitor_y=$(echo "$monitor_info" | jq -r '.y')
monitor_width=$(echo "$monitor_info" | jq -r '.width')
monitor_height=$(echo "$monitor_info" | jq -r '.height')
margin=50

floating_windows=$(hyprctl clients -j | jq -r '.[] | select(.floating == true) | .address')
for window in $floating_windows; do
    hyprctl dispatch movetoworkspace "$floating_workspace,address:$window"

    window_info=$(hyprctl clients -j | jq ".[] | select(.address == \"$window\")")
    window_x=$(echo "$window_info" | jq -r '.at[0]')
    window_y=$(echo "$window_info" | jq -r '.at[1]')
    window_width=$(echo "$window_info" | jq -r '.size[0]')
    window_height=$(echo "$window_info" | jq -r '.size[1]')

    if ! ([ "$window_x" -ge "$((monitor_x + margin))" ] &&
        [ "$window_y" -ge "$((monitor_y + margin))" ] &&
        [ "$((window_x + window_width))" -le "$((monitor_x + monitor_width - margin))" ] &&
        [ "$((window_y + window_height))" -le "$((monitor_y + monitor_height - margin))" ]); then

        # Calculate new window position
        x_pos=$((window_x < monitor_x + margin ? monitor_x + margin : window_x))
        y_pos=$((window_y < monitor_y + margin ? monitor_y + margin : window_y))

        # Make sure window isn't positioned beyond right/bottom edges (minus margin)
        max_x=$((monitor_x + monitor_width - window_width - margin))
        max_y=$((monitor_y + monitor_height - window_height - margin))
        x_pos=$((x_pos > max_x ? max_x : x_pos))
        y_pos=$((y_pos > max_y ? max_y : y_pos))

        hyprctl dispatch movewindowpixel exact $x_pos $y_pos,address:$window
    fi
done
