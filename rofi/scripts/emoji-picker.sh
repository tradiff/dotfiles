#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
ANNOTATIONS_URL="https://raw.githubusercontent.com/unicode-org/cldr-json/refs/heads/main/cldr-json/cldr-annotations-full/annotations/en/annotations.json"
EMOJI_TEST_URL="https://unicode.org/Public/emoji/latest/emoji-test.txt"
EMOJI_TXT="$SCRIPT_DIR/emoji.txt"
EMOJI_HISTORY_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/emoji-picker"
EMOJI_HISTORY_TXT="$EMOJI_HISTORY_DIR/history.txt"

ensure_history_file() {
  mkdir -p "$EMOJI_HISTORY_DIR"
  touch "$EMOJI_HISTORY_TXT"
}

refresh_data() {
  local tmp_annotations_json
  local tmp_emoji_test_txt
  local variation_selector

  printf 'Downloading CLDR annotations...\n'
  tmp_annotations_json="$(mktemp)"
  tmp_emoji_test_txt="$(mktemp)"
  # U+FE0F forces emoji presentation; CLDR often omits it from annotation keys.
  variation_selector=$'\uFE0F'
  trap 'rm -f "$tmp_annotations_json" "$tmp_emoji_test_txt"' RETURN

  curl -fsSL "$ANNOTATIONS_URL" -o "$tmp_annotations_json"

  printf 'Downloading Unicode emoji list...\n'
  curl -fsSL "$EMOJI_TEST_URL" -o "$tmp_emoji_test_txt"

  printf 'Regenerating %s...\n' "$(basename "$EMOJI_TXT")"
  jq -r '
    .annotations.annotations
    | to_entries[]
    | select(.key | length > 0)
    | select(.value.tts and .value.default)
    | [
        .key,
        (.value.tts[0]),
        (.value.default | join(" "))
      ]
    | join(" ")
  ' "$tmp_annotations_json" | awk -v vs="$variation_selector" '
    function normalized(value) {
      gsub(vs, "", value)
      return value
    }

    NR == FNR {
      emoji[normalized($0)] = $0
      next
    }

    {
      key = normalized($1)
      if (key in emoji) {
        $1 = emoji[key]
        print
      }
    }
  ' <(
    sed -n 's/^.*; fully-qualified[[:space:]]*# \([^ ]\+\) .*$/\1/p' "$tmp_emoji_test_txt"
  ) - > "$EMOJI_TXT"

  printf 'Done.\n'
}

update_history() {
  local entry="$1"
  local tmp_file

  ensure_history_file
  tmp_file="$(mktemp)"

  {
    printf '%s\n' "$entry"
    grep -Fvx "$entry" "$EMOJI_HISTORY_TXT" || true
  } | sed -n '1,10p' > "$tmp_file"

  mv "$tmp_file" "$EMOJI_HISTORY_TXT"
}

select_emoji() {
  local selection

  ensure_history_file
  selection="$({
    awk 'NF' "$EMOJI_HISTORY_TXT"
    awk 'NF' "$EMOJI_TXT"
  } | rofi -p "✨ Emoji" -dmenu -i)"

  [[ -n "$selection" ]] || exit 0

  EMOJI="${selection%% *}"
  update_history "$selection"
  wl-copy "$EMOJI"
}


case "${1:-}" in
"refresh")
  refresh_data
  ;;
"select")
  select_emoji
  ;;
*)
  echo "Usage: $(basename "$0") [refresh|select]"
  exit 1
  ;;
esac
