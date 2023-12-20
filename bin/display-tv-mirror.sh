#!/bin/sh

xrandr --dpi 96 \
  --output eDP-1 --primary --mode 1920x1080  --pos 0x0 --rotate normal --scale 1.0x1.0 \
  --output DP-1 --off \
  --output HDMI-1 --off \
  --output DP-2 --mode 1920x1080 --pos 0x0 --rotate normal --scale 1.0x1.0 \
  --output DP-3 --off \
  --output DP-4 --off
