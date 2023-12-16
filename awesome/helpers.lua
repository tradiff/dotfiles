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

return helpers
