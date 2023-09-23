return {
  "windwp/nvim-autopairs",
  enabled = false,
  config = function ()
    require("nvim-autopairs").setup({
      -- leverage treesitter
      check_ts = true,
      ts_config = {
      },
    })
    require "nvim-autopairs".add_rules(require("nvim-autopairs.rules.endwise-ruby"))
  end,
}
