vim.g['test#neovim#start_normal'] = 1
vim.g['test#preserve_screen'] = 0
-- run in quickfix (display with `:copen`)
vim.g['test#strategy'] = 'kitty'

vim.keymap.set('n', '<leader>t', ':wa<CR>:TestNearest<CR>', { noremap = true })
vim.keymap.set('n', '<leader>l', ':wa<CR>:TestLast<CR>', { noremap = true })
