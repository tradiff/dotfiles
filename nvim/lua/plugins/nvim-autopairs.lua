local npairs = require('nvim-autopairs')

npairs.setup({
  -- leverage treesitter
  check_ts = true,
  ts_config = {
  }
})
require 'nvim-autopairs'.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
