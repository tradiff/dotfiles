#!/usr/bin/env bash

# Display a GUI password prompt for sudo askpass requests from non-interactive processes

prompt=${1:-Password:}

# Suppress known GTK settings warnings from Zenity.
exec 2> >(grep -Fv \
  -e 'Using GtkSettings:gtk-application-prefer-dark-theme with libadwaita is unsupported.' \
  -e 'Unknown key gtk-modules in ' >&2)

exec zenity \
  --entry \
  --hide-text \
  --no-markup \
  --title="sudo authentication" \
  --text="$prompt"
