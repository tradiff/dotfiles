local screens = {}

local function move_clients(old_tag, new_screen)
  local new_tag = awful.tag.find_by_name(new_screen, old_tag.name)
  if new_tag then
    -- Moving each client to the corresponding tag on the primary screen
    for _, c in ipairs(old_tag:clients()) do
      c:move_to_tag(new_tag)
    end
  else
    old_tag.screen = new_screen
  end
end

screens.gather_clients = function (new_screen)
  new_screen = new_screen or awful.screen.focused()
  local new_screen_tag_mapping = {}

  for s in screen do
    if s ~= new_screen then
      for _, tag in ipairs(s.tags) do
        move_clients(tag, new_screen)
      end
    end
  end
end

screen.connect_signal("primary_changed", function ()
  screens.gather_clients(screen.primary)
end)

tag.connect_signal("request::screen", function (t)
  -- Screen has disconnected, re-assign orphan tags to a live screen
  move_clients(tag, screen.primary)
end)

return screens
