#!/bin/bash

# expects to find an environment variable called SLACK_AUTH_HEADER
# with the value "Bearer xoxp-TOKEN-HERE"

slack_set_status() {
  local status_emoji="$1"
  local status_text="$2"
  local presence="$3"

  curl -X POST -H "Authorization: $SLACK_AUTH_HEADER" \
    -H 'Content-type: application/json; charset=utf-8' \
    --data "{
      \"profile\": {
        \"status_emoji\": \"$status_emoji\",
        \"status_text\": \"$status_text\",
        \"status_expiration\": 0
      }
    }" \
    https://slack.com/api/users.profile.set

  curl -X POST -H "Authorization: $SLACK_AUTH_HEADER" \
    -H 'Content-type: application/json; charset=utf-8' \
    --data "{\"presence\": \"$presence\"}" \
    https://slack.com/api/users.setPresence
}

case "$1" in
  lunch)
    slack_set_status ":hamburger:" "out to lunch" "away"
    ;;
  afk)
    slack_set_status ":afk:" "afk" "away"
    ;;
  back)
    slack_set_status "" "" "auto"
    ;;
  *)
    echo "Usage: $0 {lunch|afk|back}"
    exit 1
    ;;
esac

