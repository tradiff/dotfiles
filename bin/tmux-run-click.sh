#!/bin/bash

pane_id="$1"
mouse_x="$2"
# mouse_line needs to be passed via env var to avoid issues with special characters
mouse_line="$MOUSE_LINE"

# Optional: Set DEBUG to 1 to enable debug logging
DEBUG=1
DEBUG_LOG="$HOME/tmux-run-click-output.txt"

log_debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "$1" >> "$DEBUG_LOG"
    fi
}

log_debug "Running pane_id: $pane_id, mouse_x: $mouse_x, mouse_line: $mouse_line"

# Get pane height and scroll position
pane_height=$(tmux display-message -p -F "#{pane_height}" -t "$pane_id")
scroll_position=$(tmux display-message -p -F "#{scroll_position}" -t "$pane_id")

log_debug "Pane height: $pane_height, Scroll position: $scroll_position"

# Capture the visible content of the pane
tmux capture-pane -p -J -t "$pane_id" -S - > /tmp/tmux_pane_content.txt

# Find the full line that contains the mouse_line
line=$(tac /tmp/tmux_pane_content.txt | grep -F "$mouse_line" | head -n 1)

log_debug "Line: $line"

if [ -z "$line" ]; then
    exit 0
fi

# Find the position of mouse_line within the full line
position_in_line=$(awk -v full_line="$line" -v partial_line="$mouse_line" 'BEGIN { print index(full_line, partial_line) }')

if [ "$position_in_line" -eq 0 ]; then
    exit 0
fi

char_index=$(( position_in_line + mouse_x - 1 ))

log_debug "Position in line: $position_in_line, Mouse X: $mouse_x, Character index: $char_index"

file_path=""
line_number=""

# Regex to match file path and optional line number
regex='([^ ]+\.[a-zA-Z0-9]+)(:[0-9]+)?'

# Loop through all matches in the line
while [[ $line =~ $regex ]]; do
    match="${BASH_REMATCH[0]}"
    file_candidate="${BASH_REMATCH[1]}"
    line_number_candidate="${BASH_REMATCH[2]:1}"  # Remove leading colon

    # Calculate match positions
    prefix="${line%%${match}*}"
    match_start=${#prefix}
    match_length=${#match}
    match_end=$(( match_start + match_length - 1 ))

    # Check if char_index falls within this match
    if (( char_index >= match_start && char_index <= match_end )); then
        file_path="$file_candidate"
        line_number="$line_number_candidate"
        break
    fi

    # Remove the matched portion from the line and continue
    line="${line#*${match}}"
done

if [ -z "$file_path" ]; then
    log_debug "No valid file path found at character index: $char_index"
    exit 0
fi

log_debug "File path: $file_path, Line number: $line_number"

# Get the current working directory of the pane
pane_cwd=$(tmux display-message -p -F "#{pane_current_path}" -t "$pane_id")
log_debug "Current working directory: $pane_cwd"

absolute_path="$pane_cwd/$file_path"

if [ ! -f "$absolute_path" ]; then
    log_debug "File does not exist: $absolute_path"
    exit 0
fi

server_name="$pane_cwd/.nvim.socket"
log_debug "Neovim server name: $server_name"

if [ -n "$line_number" ]; then
    remote_cmd="<C-\\><C-N>:e $file_path<CR>:${line_number}<CR>"
else
    remote_cmd="<C-\\><C-N>:e $file_path<CR>"
fi

nvim --server "$server_name" --remote-send "$remote_cmd"

