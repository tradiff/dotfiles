local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.temperature")

return function ()
  local temperature_widget = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "",
  })


  awesome.connect_signal("evil::temperature", function (value)
    temperature_widget.markup = helpers.colorized_markup("󰔏", beautiful.orange) .. " " .. value .. "°C"
  end)

  return temperature_widget
end
