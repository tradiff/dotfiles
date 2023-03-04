-- sticky scroll
return {
  'nvim-treesitter/nvim-treesitter-context',
  config = function()
    require('treesitter-context').setup({
      mode = 'topline',
      patterns = {
        ruby = {
          'module',
          'class',
          'method',
          'block',
        }
      }
    })
  end,
}
