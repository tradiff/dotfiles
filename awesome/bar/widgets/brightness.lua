local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.brightness")

return function ()
  local brightness_widget = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "",
    buttons = gears.table.join(
      awful.button({}, helpers.mouse.MB_SCROLL_UP,
        function () helpers.change_brightness(-1) end
      ),
      awful.button({}, helpers.mouse.MB_SCROLL_DOWN,
        function () helpers.change_brightness(1) end
      )
    ),
  })


  awesome.connect_signal("evil::brightness", function (value, _icon)
    brightness_widget.markup = helpers.colorized_markup("󰌶", beautiful.yellow) .. " " .. value
  end)

  return brightness_widget
end
