local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

local function get_sticky_icon(client)
  if client.sticky then
    return "󰐃"
  else
    return "󰤱"
  end
end

local function get_ontop_icon(client)
  if client.ontop then
    return "󰣆 "
  else
    return "󰘔 "
  end
end

local function titlebar_button(icon, tooltip, click_fn)
  local button = wibox.widget {
    widget = wibox.container.background,
    bg = "#ffffff00",
    {
      widget = wibox.container.margin,
      left = dpi(10), right = dpi(10),
      buttons = gears.table.join(
        awful.button({}, helpers.mouse.MB_LEFT, click_fn)
      ),
      {
        widget = wibox.widget.textbox,
        text = icon,
      },
    },
  }

  awful.tooltip({
    objects = { button, },
    mode = "outside",
    timer_function = function ()
      return tooltip
    end,
    preferred_positions = { "top", "bottom", "left", "right", },
  })


  button:connect_signal("mouse::enter", function (self)
    self.bg = "#ffffff22"
  end)
  button:connect_signal("mouse::leave", function (self)
    self.bg = "#ffffff00"
  end)
  return button
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function (c)
  -- Default
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, helpers.mouse.MB_LEFT, function ()
      c:emit_signal("request::activate", "titlebar", { raise = true, })
      awful.mouse.client.move(c)
    end),
    awful.button({}, helpers.mouse.MB_RIGHT, function ()
      c:emit_signal("request::activate", "titlebar", { raise = true, })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, { size = 32, }):setup {
    widget = wibox.container.background,
    bg = beautiful.titlebar_bg,
    shape_border_color = beautiful.titlebar_border,
    shape_border_width = dpi(1),
    {
      layout = wibox.layout.align.horizontal,
      { -- Left
        widget = wibox.container.margin,
        top = dpi(5), bottom = dpi(5),
        {
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.container.margin,
            left = dpi(5), right = dpi(5),
            awful.titlebar.widget.iconwidget(c),
          },
          awful.titlebar.widget.titlewidget(c),
          buttons = buttons,
        },
      },
      { -- Middle
        layout = wibox.layout.flex.horizontal,
        buttons = buttons,
      },
      { -- Right
        layout = wibox.layout.fixed.horizontal,
        titlebar_button(
          get_sticky_icon(c),
          "Sticky",
          function () c.sticky = not c.sticky end
        ),
        titlebar_button(
          get_ontop_icon(c),
          "On Top",
          function () c.ontop = not c.ontop end
        ),
        titlebar_button(
          " ", "Close", function () c:kill() end
        ),
      },
    },
  }
end)

client.connect_signal("property::sticky", function (c)
  local tag = awful.screen.focused().selected_tag
  if tag then
    c:tags({ tag, })
  end

  c:emit_signal("request::titlebars")
end)

client.connect_signal("property::ontop", function (c)
  c:emit_signal("request::titlebars")
end)
