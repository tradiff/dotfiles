#!/usr/bin/env bash

# Display a GUI password prompt for sudo askpass requests from non-interactive processes

prompt=${1:-Password:}

# Suppress this useless warning about a deprecated setting that Plasma keeps regenerating.
exec 2> >(grep -Fv 'Using GtkSettings:gtk-application-prefer-dark-theme with libadwaita is unsupported.' >&2)

exec /usr/sbin/zenity \
  --entry \
  --hide-text \
  --no-markup \
  --title="sudo authentication" \
  --text="$prompt"
