local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
require("evil.battery")
require("evil.volume")
local key_binds = require("key_binds")
local modkey = key_binds.modkey
require("layouts")

-- Taglist widget
-- ===================================================================
local function create_taglist_widget(screen)
  awful.tag(
    { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", },
    screen,
    awful.layout.layouts[1]
  )

  return awful.widget.taglist {
    screen = screen,
    filter = function (t) return t.selected or #t:clients() > 0 end,
    buttons = gears.table.join(
    -- left click to view tag
      awful.button({}, 1, function (t) t:view_only() end),
      -- mod + left click to send the focused client to the tag
      awful.button({ modkey, }, 1, function (t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      -- right click to toggle
      awful.button({}, 3, awful.tag.viewtoggle),
      awful.button({}, 4, function (t) awful.tag.viewnext(t.screen) end),
      awful.button({}, 5, function (t) awful.tag.viewprev(t.screen) end)
    ),
  }
end

-- Battery widget
-- ===================================================================
local battery_widget = wibox.widget {
  text = "",
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
}
local battery_percentage_text = ""
local battery_plugged_text = ""
local function update_battery_widget()
  battery_widget.text = battery_plugged_text .. battery_percentage_text
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

  battery_percentage_text = icon .. " " .. percentage
  update_battery_widget()
end)

awesome.connect_signal("evil::charger", function (plugged)
  if plugged then
    battery_plugged_text = "  "
  else
    battery_plugged_text = ""
  end
  update_battery_widget()
end)

-- Volume widget
-- ===================================================================
local volume_widget = wibox.widget {
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
  forced_width = dpi(70),
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

  volume_widget.text = icon .. " " .. volume_display
end)

-- Layout widget
-- ===================================================================
local function create_layout_widget(screen)
  layoutbox = awful.widget.layoutbox(screen)
  layoutbox:buttons(gears.table.join(
    awful.button({}, 1, function () awful.layout.inc(1) end),
    awful.button({}, 3, function () awful.layout.inc(-1) end),
    awful.button({}, 4, function () awful.layout.inc(1) end),
    awful.button({}, 5, function () awful.layout.inc(-1) end)))

  return layoutbox
end


awful.screen.connect_for_each_screen(function (screen)
  local bar = awful.wibar({ position = "top", screen = screen, })

  -- Add widgets to the wibox
  bar:setup {
    layout = wibox.layout.align.horizontal,

    -- left
    {
      layout = wibox.layout.fixed.horizontal,
      create_taglist_widget(screen),
    },

    -- middle
    nil,

    -- right
    {
      layout = wibox.layout.fixed.horizontal,
      battery_widget,
      volume_widget,
      wibox.widget.systray({
        base_size = 10,
      }),
      wibox.widget.textclock(),
      create_layout_widget(screen),
    },
  }
end)
