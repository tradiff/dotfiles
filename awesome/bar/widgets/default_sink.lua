local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
require("evil.default_sink")

return function ()
  local default_sink_widget = wibox.widget({
    widget = wibox.widget.textbox,
    markup = "",
  })


  awesome.connect_signal("evil::default_sink", function (value, _icon)
    local laptop_sink = "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink"
    local headphones_sink = "bluez_output.80_C3_BA_58_A4_09.1"
    local earbuds_sink = "bluez_output.AC_3E_B1_A2_31_A1.1"
    local icon = ""
    value = value:gsub("%s+", "")

    if value == laptop_sink then
      icon = " "
    elseif value == headphones_sink then
      icon = " "
    elseif value == earbuds_sink then
      icon = "󱡏 "
    else
      icon = value
    end

    default_sink_widget.markup = helpers.colorized_markup(icon, beautiful.blue)
  end)

  return default_sink_widget
end
