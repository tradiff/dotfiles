local awful = require("awful")
local battery_widget = require("bar.widgets.battery")
local beautiful = require("beautiful")
local brightness_widget = require("bar.widgets.brightness")
local default_sink_widget = require("bar.widgets.default_sink")
local cpu_widget = require("bar.widgets.cpu")
local layout_widget = require("bar.widgets.layoutbox")
local memory_widget = require("bar.widgets.memory")
local new_tag_widget = require("bar.widgets.new_tag")
local systray_widget = require("bar.widgets.systray")
local taglist_widget = require("bar.widgets.taglist")
local temperature_widget = require("bar.widgets.temperature")
local volume_widget = require("bar.widgets.volume")
local wibox = require("wibox")
local widget_container = require("bar.widgets.widget_container")
local xresources = require("beautiful.xresources")
require("layouts")

local dpi = xresources.apply_dpi

local left = function (screen)
  return {
    layout = wibox.layout.fixed.horizontal,

    widget_container(
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(20),
        taglist_widget(screen),
        new_tag_widget(),
      }),
  }
end

local right = function (screen)
  return {
    layout = wibox.layout.fixed.horizontal,

    widget_container(
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(20),
        temperature_widget(),
        cpu_widget(),
        memory_widget(),
      }
    ),

    widget_container(
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(20),
        battery_widget(),
        volume_widget(),
        default_sink_widget(),
        brightness_widget(),
      }),

    widget_container(
      systray_widget()
    ),

    widget_container(
      wibox.widget.textclock(
        "%a %b %d   %I:%M %p"
      )
    ),

    widget_container(
      layout_widget(screen)
    ),
  }
end

local middle = function ()
  return nil
end

awful.screen.connect_for_each_screen(function (screen)
  local bar = awful.wibar({
    height = dpi(32) + (beautiful.useless_gap * 3) + (beautiful.widget_container_border_width * 2),
    position = "top",
    screen = screen,
  })


  bar:setup {
    widget = wibox.container.margin,
    top = beautiful.useless_gap,
    {
      layout = wibox.layout.align.horizontal,
      left(screen),
      middle(),
      right(screen),
    },
  }
end)
