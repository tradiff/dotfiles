local screens = {}

screens.gather_clients = function ()
  local focused_screen = awful.screen.focused()
  local tag_mapping = {}

  for i, tag in ipairs(focused_screen.tags) do
    tag_mapping[i] = tag
  end

  for s in screen do
    if s ~= awful.screen.focused() then
      for i, tag in ipairs(s.tags) do
        local focused_tag = tag_mapping[i]
        if focused_tag then
          -- Moving each client to the corresponding tag on the primary screen
          for _, c in ipairs(tag:clients()) do
            c:move_to_tag(focused_tag)
          end
        end
      end
    end
  end
end

return screens
