-- unit tests
return {
  'vim-test/vim-test',
  config = function()
    vim.g['test#neovim#start_normal'] = 1
    vim.g['test#preserve_screen'] = 0
    vim.g['test#strategy'] = 'kitty'

    vim.g['test#ruby#rspec#executable'] = 'cls; ./bin/rspec'

    vim.keymap.set('n', '<leader>t', ':wa<CR>:TestNearest<CR>', { noremap = true })
    vim.keymap.set('n', '<leader>l', ':wa<CR>:TestLast<CR>', { noremap = true })
  end
}
