local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
require("evil.battery")
require("evil.volume")
local gears = require("gears")
local helpers = require("helpers")
local key_binds = require("key_binds")
require("layouts")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local modkey = key_binds.modkey

local function create_widget_container(body)
  return wibox.widget {
    widget = wibox.container.margin,
    left = beautiful.useless_gap * 2,
    right = beautiful.useless_gap * 2,
    {
      widget = wibox.container.background,
      bg = beautiful.segment_bg,
      shape = helpers.rrect(beautiful.segment_radius),
      shape_border_color = beautiful.segment_border_color,
      shape_border_width = beautiful.segment_border_width,
      {
        widget = wibox.container.margin,
        top = beautiful.segment_border_width + beautiful.useless_gap,
        bottom = beautiful.segment_border_width + beautiful.useless_gap,
        left = dpi(15),
        right = dpi(15),
        body,
      },
    },
  }
end

-- Taglist widget
-- ===================================================================
local function create_taglist_widget(screen)
  awful.tag(
    { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", },
    screen,
    awful.layout.layouts[1]
  )
  return create_widget_container(
    awful.widget.taglist {
      screen = screen,
      filter = function (t) return t.selected or #t:clients() > 0 end,
      style = {
        shape = helpers.rrect(beautiful.segment_radius),
        shape_border_width = 0,
      },

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
        awful.button({}, 3, awful.tag.viewtoggle)
      ),
    }
  )
end

-- Battery widget
-- ===================================================================
local battery_widget = wibox.widget {
  widget = wibox.widget.textbox,
  markup = "",
  align = "center",
  valign = "center",
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

  battery_percentage_text = helpers.colorized_markup(icon, beautiful.green) .. " " .. percentage
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

-- Volume widget
-- ===================================================================
local volume_widget = wibox.widget {
  widget = wibox.widget.textbox,
  markup = "",
  align = "center",
  valign = "center",
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

  volume_widget.markup = helpers.colorized_markup(icon, beautiful.blue) .. " " .. volume_display
end)

-- Layout widget
-- ===================================================================
local function create_layout_widget(screen)
  return {
    awful.widget.layoutbox(screen),
    forced_height = beautiful.layout_image_size,
    forced_width = beautiful.layout_image_size,
    valign = "center",
    layout = wibox.container.place,
    buttons = gears.table.join(
      awful.button({}, 1, function () awful.layout.inc(1) end),
      awful.button({}, 3, function () awful.layout.inc(-1) end)
    ),
  }
end


-- PUt it all together
-- ===================================================================
awful.screen.connect_for_each_screen(function (screen)
  local bar = awful.wibar({
    height = dpi(32) + (beautiful.useless_gap * 3) + (beautiful.segment_border_width * 2),
    position = "top",
    screen = screen,
  })

  -- Add widgets to the wibox
  bar:setup {
    widget = wibox.container.margin,
    top = beautiful.useless_gap,
    {
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
        create_widget_container(
          {
            widget = wibox.container.margin,
            left = dpi(15),
            {
              layout = wibox.layout.fixed.horizontal,
              battery_widget,
              volume_widget,
            },
          }),

        create_widget_container(
          {
            widget = wibox.container.margin,
            margins = dpi(4),

            {
              widget = wibox.widget.systray,
              base_size = beautiful.systray_icon_size,
              forced_width = 170, -- hack
            },
          }
        ),

        create_widget_container(
          wibox.widget.textclock(
            "%a %b %d   %I:%M %p"
          )
        ),

        create_widget_container(
          create_layout_widget(screen)
        ),
      },
    },
  }
end)
