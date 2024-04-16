local watch = require("awful.widget.watch")

local GET_CMD = "pactl get-default-sink"

watch(GET_CMD, 1, function (_, stdout, _, _, _)
  local value = stdout

  awesome.emit_signal("evil::default_sink", value)
end, nil)
