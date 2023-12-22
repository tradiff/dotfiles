#!/bin/bash

min_brightness=1

current=$(brightnessctl get)
time=0.8
fade_step_time=$(bc <<< "scale=2; $time/$current")

trap 'exit 0' TERM INT
trap 'brightnessctl -q set $current; kill %%' EXIT

for (( val=current; val>=min_brightness; val-- )); do
    brightnessctl -q set "$val"
    sleep "$fade_step_time"
done

sleep 2147483647 &
wait
