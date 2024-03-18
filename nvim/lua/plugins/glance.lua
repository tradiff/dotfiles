return {
  "dnlhc/glance.nvim",
  config = function()
    local glance = require("glance")
    glance.setup({
      height = 30,
      detached = true,
      border = {
        enable = true,
        top_char = "―",
        bottom_char = "―",
      },
      list = {
        position = "left",
        width = 0.4,
      },
      theme = {
        enable = true,   -- Will generate colors for the plugin based on your current colorscheme
        mode = "darken", -- 'brighten'|'darken'|'auto', 'auto'
      },
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then
            jump(results[1]) -- argument is optional
          else
            open(results)    -- argument is optional
          end
        end,
      },
    })
  end,
}
