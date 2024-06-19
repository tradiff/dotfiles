#!/bin/bash

# Detect the distribution
if grep -qi "arch" /etc/os-release; then
  echo '{"text": "", "class": "arch", "tooltip": "Arch Linux"}'
elif grep -qi "opensuse-tumbleweed" /etc/os-release; then
  echo '{"text": "", "class": "tumbleweed", "tooltip": "OpenSUSE Tumbleweed"}'
else
  echo '{"text": "", "class": "unknown", "tooltip": "Unknown Distribution"}'
fi

