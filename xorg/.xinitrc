#!/bin/sh

~/bin/display-single.sh

export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"

nm-applet &
flameshot &
nitrogen --restore &
slack &
discord &
lxpolkit &
dunst &

exec awesome &> /tmp/awesome.log

