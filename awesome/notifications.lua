local naughty = require("naughty")

local function update_notification_screen()
  naughty.config.defaults.screen = screen.primary
  naughty.notify({
    title = "Primary screen changed",
  })
end

screen.connect_signal("primary_changed", update_notification_screen)
screen.connect_signal("list", update_notification_screen)
update_notification_screen()
