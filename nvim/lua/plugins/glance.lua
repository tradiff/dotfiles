return {
  'dnlhc/glance.nvim',
  config = function()
    local glance = require('glance')
    glance.setup({
      height = 30,
      detached = true,
      border = {
        enable = true,
        top_char = '―',
        bottom_char = '―',
      },
      list = {
        position = 'left',
        width = 0.4,
      },
      theme = {
        enable = true,   -- Will generate colors for the plugin based on your current colorscheme
        mode = 'darken', -- 'brighten'|'darken'|'auto', 'auto'
      },
    })
  end
}
