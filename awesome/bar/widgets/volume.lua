local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.volume")

return function ()
  local volume_widget = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "",
    buttons = gears.table.join(
      awful.button({}, helpers.mouse.MB_LEFT, function ()
        awful.spawn.with_shell("killall pavucontrol; pavucontrol")
      end),
      awful.button({}, helpers.mouse.MB_SCROLL_UP,
        function () helpers.change_volume(-1) end
      ),
      awful.button({}, helpers.mouse.MB_SCROLL_DOWN,
        function () helpers.change_volume(1) end
      )
    ),
  }

  awesome.connect_signal("evil::volume", function (volume, muted)
    local icon
    local volume_display = volume
    if muted or volume == 0 then
      icon = "󰝟"
      volume_display = 0
    elseif volume <= 33 then
      icon = "󰕿"
    elseif volume <= 66 then
      icon = "󰖀"
    elseif volume <= 100 then
      icon = "󰕾"
    else
      icon = ""
    end

    volume_widget.markup = helpers.colorized_markup(icon, beautiful.blue) .. " " .. volume_display
  end)

  return volume_widget
end
