-- <leader><leader> is a shortcut for commands
vim.keymap.set('n', '<leader><leader>', ':')

-- escape out of insert mode
vim.keymap.set('i', 'jj', '<ESC>')

-- <leader>w writes the current buffer to disk
vim.keymap.set('n', '<leader>w', ':w!<CR>')

-- <leader>Q quits all windows
vim.keymap.set('n', '<leader>Q', ':qa!<CR>')

-- <leader>s for vertical split, <leader>S for horizontal split
vim.keymap.set('n', '<leader>s', ':vs<CR><C-W>l')
vim.keymap.set('n', '<leader>S', ':sp<CR><C-W>j')
-- <leader>x to close a split
vim.keymap.set('n', '<leader>x', ':close<CR>')

-- reload vim config with <leader>V
vim.keymap.set('n', '<leader>V', ':so ~/.config/nvim/init.lua<CR>')

-- Hit escape twice to clear highlights
vim.keymap.set('n', '<Esc><Esc>', ':nohls<CR>', { silent = true })
vim.keymap.set('n', '<C-@><C-@>', ':nohls<CR>', { silent = true })
vim.keymap.set('n', '<C-Space><C-Space>', ':nohls<CR>', { silent = true })

-- delete without copying to a register
vim.keymap.set('x', 'x', '"_x')
-- delete line without copying to a register
vim.keymap.set('n', 'xx', 'V"_x')

-- paste without copying to a register
vim.keymap.set('x', 'p', 'pgvy')

-- <Leader>h/j/k/l navigates windows
vim.keymap.set('n', '<Leader>h', '<C-W>h')
vim.keymap.set('n', '<Leader>j', '<C-W>j')
vim.keymap.set('n', '<Leader>k', '<C-W>k')
vim.keymap.set('n', '<Leader>l', '<C-W>l')
vim.keymap.set('n', '<Leader><Left>', '<C-W>h')
vim.keymap.set('n', '<Leader><Down>', '<C-W>j')
vim.keymap.set('n', '<Leader><Up>', '<C-W>k')
vim.keymap.set('n', '<Leader><Right>', '<C-W>l')

-- OS clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true })
vim.keymap.set('n', '<leader>Y', '"+yg_', { noremap = true })
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true })
