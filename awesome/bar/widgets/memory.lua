local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.ram")

return function ()
  local memory_widget = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "",
  })


  awesome.connect_signal("evil::ram", function (used, total)
    local percentage = math.floor((used / total * 100) + 0.5)
    memory_widget.markup = helpers.colorized_markup("󰍛", beautiful.magenta) .. " " .. percentage .. "%"
  end)

  return memory_widget
end
