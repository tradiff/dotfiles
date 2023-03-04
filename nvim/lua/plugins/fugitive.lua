return {
  'tpope/vim-fugitive',
  config = function()
    vim.api.nvim_create_user_command('Blame', 'Git blame', { nargs = 0 })
  end
}
