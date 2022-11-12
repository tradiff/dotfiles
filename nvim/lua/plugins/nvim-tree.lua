local nvim_tree = require('nvim-tree')

nvim_tree.setup({
  remove_keymaps = { '-' }
})

-- use - to toggle the tree
vim.api.nvim_set_keymap('n', '-', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
