local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

return function ()
  return wibox.widget({
    widget = wibox.widget.textbox,
    markup = " ",
    buttons = gears.table.join(
      awful.button({}, helpers.mouse.MB_LEFT, helpers.switch_new_tag)
    ),
  })
end
