local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- escape out of insert mode
map('i', 'jj', '<ESC>', opts)

-- <leader>w writes the current buffer to disk
map('n', '<leader>w', ':w!<CR>', opts)

-- <leader>Q quits all windows
map('n', '<leader>Q', ':qa!<CR>', opts)

-- <leader>s for vertical split, <leader>S for horizontal split
map('n', '<leader>s', ':vs<CR><C-W>l', opts)
map('n', '<leader>S', ':sp<CR><C-W>j', opts)
-- <leader>x to close a split
map('n', '<leader>x', ':close<CR>', opts)

-- reload vim config with <leader>V
map('n', '<leader>V', ':so ~/.config/nvim/init.lua<CR>', opts)

-- Hit escape twice to clear highlights
map('n', '<Esc><Esc>', ':nohls<CR>', opts)
map('n', '<C-@><C-@>', ':nohls<CR>', opts)
map('n', '<C-Space><C-Space>', ':nohls<CR>', opts)

-- delete without copying to a register
for _, mode in pairs({ 'n', 'x' }) do
  for _, key in pairs({ 'c', 'C', 's', 'S', 'd', 'D' }) do
    map(mode, key, string.format('"_%s', key), opts)
  end
end

-- 'x' is the new "cut"
map('n', 'x', 'd', opts)
map('x', 'x', 'd', opts)
map('n', 'xx', 'dd', opts)
map('n', 'X', 'D', opts)
map('x', 'X', 'D', opts)

-- paste without copying to a register
map('x', 'p', 'pgvy', opts)
map('i', '<C-p>', '<ESC>pa', opts)


-- navigate windows
map('n', '<Leader><Left>', '<C-W>h', opts)
map('n', '<Leader><Down>', '<C-W>j', opts)
map('n', '<Leader><Up>', '<C-W>k', opts)
map('n', '<Leader><Right>', '<C-W>l', opts)

-- OS clipboard
map('x', '<leader>y', '"+y', opts)
map('n', '<leader>Y', '"+yg_', opts)
map('n', '<leader>y', '"+y', opts)

-- don't clear selection after indent
map('v', '>', '>gv', opts)
map('v', '<', '<gv', opts)
map('v', '<tab>', '>gv', opts)
map('v', '<s-tab>', '<gv', opts)
