local naughty = require("naughty")

naughty.config.defaults.timeout = 3
local MAX_NOTIFICATION_LENGTH = 150

-- Register a callback to preprocess all notifications
naughty.config.notify_callback = function (args)
  if args.text and string.len(args.text) > MAX_NOTIFICATION_LENGTH then
    args.text = args.text:sub(0, MAX_NOTIFICATION_LENGTH) .. "…"
  end

  return args
end

local function update_notification_screen()
  naughty.config.defaults.screen = screen.primary
  naughty.notify({
    title = "Primary screen changed",
  })
end

screen.connect_signal("primary_changed", update_notification_screen)
screen.connect_signal("list", update_notification_screen)
update_notification_screen()
