local gears = require("gears")


local helpers = {}

helpers.rrect = function (radius)
  return function (cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius)
  end
end

-- colorize a text using pango markup
helpers.colorized_markup = function (content, fg)
  return '<span foreground="' .. fg .. '">' .. content .. "</span>"
end

helpers.key = {
  MOD = "Mod4",
  ALT = "Mod1",
  CTRL = "Control",
  SHIFT = "Shift",
}

helpers.mouse = {
  MB_LEFT = 1,
  MB_MIDDLE = 2,
  MB_RIGHT = 3,
  MB_SCROLL_UP = 4,
  MB_SCROLL_DOWN = 5,
}

return helpers
