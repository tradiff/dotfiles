#!/bin/bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
CAELNDAR_FILE_TTL=$((15 * 60))  # 15 minutes

# expects to find environment variables CALENDAR_FILE and CALENDAR_NAME
source ~/secrets.zsh

download_calendar() {
  gcalendar --account tidelift --calendar $CALENDAR_NAME --no-of-days 3 --output json > "$CALENDAR_FILE"
}

send_notification() {
  local urgency="$1"
  local summary="$2"
  local meeting_time="$3"
  notify-send -u $urgency -i calendar -a "Upcoming Meeting" "$summary" "at $meeting_time" -h "string:x-canonical-private-synchronous:$summary"
}


# Check if the calendar file exists and is within the TTL
if [[ ! -f "$CALENDAR_FILE" || $(($(date +%s) - $(stat -c %Y "$CALENDAR_FILE"))) -gt $CAELNDAR_FILE_TTL ]]; then
  download_calendar
fi

# Get the current time and parse the calendar
current_time=$(date +%s)
events=$(jq -c '.[]' "$CALENDAR_FILE")

# Loop through the events and check for upcoming meetings
echo "$events" | while read -r event; do
  summary=$(echo "$event" | jq -r '.summary')
  start_date=$(echo "$event" | jq -r '.start_date')
  start_time=$(echo "$event" | jq -r '.start_time')
  event_time=$(date -d "$start_date $start_time" +%s)
  event_time_str=$(date -d "@$event_time" +"%I:%M %p")

  time_diff=$((event_time - current_time))
  if [[ $time_diff -ge 540 && $time_diff -le 601 ]]; then # 9m - 10m1s
    send_notification "normal" "$summary" "$event_time_str"
  elif [[ $time_diff -ge 0 && $time_diff -le 121 ]]; then # 0 - 1m1s
    send_notification "critical" "$summary" "$event_time_str"
  fi
done
