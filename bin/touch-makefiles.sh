#!/usr/bin/env bash

# Recursively find all files named "Makefile" and append a comment.
# This is to force deployments to dev environments that do change detection.

find . -type f -name "Makefile" | while read -r file; do
  echo "Updating $file"
  echo -e "\n# force deployment" >> "$file"
done
