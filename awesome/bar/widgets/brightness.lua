local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.brightness")

return function ()
  local brightness_widget = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "",
  })


  awesome.connect_signal("evil::brightness", function (value, _icon)
    brightness_widget.markup = helpers.colorized_markup("󰌶", beautiful.yellow) .. " " .. value
  end)

  return brightness_widget
end
