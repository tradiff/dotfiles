return {
  "nvim-treesitter/nvim-treesitter",
  -- pinned until vim-nightfly-colors is updated for the new treesitter captures
  -- https://github.com/bluz71/vim-nightfly-colors/issues/57
  version = "0.9.2",
  build = ":TSUpdate",
  config = function ()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      ensure_installed = { "help", "lua", "ruby", "vim", },
      highlight = { enable = true, },
      indent = { enable = true, },
      incremental_selection = {
        enable = false,
      },
      matchup = {
        enable = true,
      },
    })
  end,
}
