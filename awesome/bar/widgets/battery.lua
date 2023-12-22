local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.battery")

return function ()
  local battery_widget = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "",
  }

  local battery_percentage_text = ""
  local battery_plugged_text = ""

  local function update_battery_widget()
    battery_widget.markup = battery_plugged_text .. battery_percentage_text
  end

  awesome.connect_signal("evil::battery", function (percentage)
    local icon
    if percentage < 10 then
      icon = "󰁺"
    elseif percentage < 20 then
      icon = "󰁻"
    elseif percentage < 30 then
      icon = "󰁼"
    elseif percentage < 40 then
      icon = "󰁽"
    elseif percentage < 50 then
      icon = "󰁾"
    elseif percentage < 60 then
      icon = "󰁿"
    elseif percentage < 70 then
      icon = "󰂀"
    elseif percentage < 80 then
      icon = "󰂁"
    elseif percentage < 90 then
      icon = "󰂂"
    else
      icon = "󰁹"
    end

    if percentage < 20 then
      battery_percentage_text =
        '<span background="' ..
        beautiful.red .. '" foreground="' .. "#000000aa" .. '">' .. icon .. " " .. percentage .. "</span>"
    else
      battery_percentage_text = helpers.colorized_markup(icon, beautiful.green) .. " " .. percentage
    end
    update_battery_widget()
  end)

  awesome.connect_signal("evil::charger", function (plugged)
    if plugged then
      battery_plugged_text = helpers.colorized_markup(" ", beautiful.green)
    else
      battery_plugged_text = ""
    end
    update_battery_widget()
  end)

  return battery_widget
end
