require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all"
  ensure_installed = { 'help', 'lua', 'ruby', 'vim' },

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
    },
  },
})
