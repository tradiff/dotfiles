# Custom tide item. Shows the current MISE_ENV value when set.

function _tide_item_mise_env
    if test -n "$MISE_ENV"
      set item_name mise
      set item_icon '󰭼'
      set item_text $MISE_ENV
      set -fx tide_mise_color C75B7A
      set -fx tide_mise_bg_color normal
      _tide_print_item $item_name $item_icon' ' $item_text
    end
end

