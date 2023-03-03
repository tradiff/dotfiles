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
