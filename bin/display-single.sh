#!/bin/sh

xrandr --dpi 96 \
  --output eDP-1 --primary --mode 3456x2160 --pos 0x0 --rotate normal --scale 0.5x0.5 \
  --output DP-1 --off \
  --output HDMI-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output DP-4 --off
