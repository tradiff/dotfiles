-- LSP loading indicator
return {
  'j-hui/fidget.nvim',
  config = function()
    require('fidget').setup({
      text = {
        spinner = 'line'
      }
    })
  end
}
