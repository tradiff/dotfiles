#!/bin/sh

xrandr --dpi 96 \
  --output eDP-1 --primary --mode 1920x1440 --pos 0x0 --rate 60.00 --rotate normal --scale 1x1 \
  --output DP-1 --off \
  --output HDMI-1 --off \
  --output DP-2 --off \
  --output DP-3 --off \
  --output DP-4 --off

xrandr --dpi 96 \
  --output eDP-1 --mode 3456x2160 --pos 5120x0 --rate 60.00 --rotate normal --scale 0.5x0.5 \
  --output DP-1 --off \
  --output HDMI-1 --off \
  --output DP-2 --primary --mode 5120x1440 --pos 0x0 --rate 100.00 --rotate normal --scale 0.9999x0.9999 \
  --output DP-3 --off \
  --output DP-4 --off

nitrogen --restore
