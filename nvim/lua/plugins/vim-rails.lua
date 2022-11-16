-- alternate file
-- create the file if it's missing
vim.keymap.set('n', '<leader>a', ':execute "e " . eval("rails#buffer().alternate()")<cr>', { noremap = true })
