vim.g['test#neovim#start_normal'] = 1
-- run in quickfix (display with `:copen`)
vim.g['test#strategy'] = 'asyncrun_background'

vim.keymap.set('n', '<leader>t', ':wa<CR>:TestNearest<CR>', { noremap = true })
vim.keymap.set('n', '<leader>l', ':wa<CR>:TestLast<CR>', { noremap = true })
