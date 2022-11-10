nvim_tree = require('nvim-tree')

nvim_tree.setup()

-- use - to toggle the tree
vim.api.nvim_set_keymap('n', '-', ':silent NvimTreeToggle<CR>', { noremap = true })


