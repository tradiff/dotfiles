return {
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup({
      char = '▏',
      context_char = '▏',

      show_current_context = true,

      show_first_indent_level = true,
      show_foldtext = false,
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      max_indent_increase = 1,
    })
  end
}
