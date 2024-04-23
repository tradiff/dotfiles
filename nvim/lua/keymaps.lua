local map = require("map")

-- escape out of insert mode
map("i", "jj", "<ESC>")

-- <leader>w writes the current buffer to disk
map("n", "<leader>w", ":w!<CR>")

-- <leader>Q quits all windows
map("n", "<leader>Q", ":qa!<CR>")

-- <leader>s for vertical split, <leader>S for horizontal split
map("n", "<leader>s", ":vs<CR><C-W>l")
map("n", "<leader>S", ":sp<CR><C-W>j")
-- <leader>x to close a split
map("n", "<leader>x", ":close<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- reload vim config with <leader>V
map("n", "<leader>V", ":so ~/.config/nvim/init.lua<CR>", "Reload vim config")

-- Hit escape twice to clear highlights
map("n", "<Esc><Esc>", ":nohls<CR>")
map("n", "<C-@><C-@>", ":nohls<CR>")
map("n", "<C-Space><C-Space>", ":nohls<CR>")

-- delete without copying to a register
for _, mode in pairs({ "n", "x", }) do
  for _, key in pairs({ "c", "C", "s", "S", "d", "D", }) do
    map(mode, key, string.format('"_%s', key))
  end
end

-- 'x' is the new "cut"
map("n", "x", "d")
map("x", "x", "d")
map("n", "xx", "dd")
map("n", "X", "D")
map("x", "X", "D")

-- paste without copying to a register
map("x", "p", "pgvy")
map("i", "<C-p>", "<ESC>pa")


-- navigate windows
map("n", "<Leader><Left>", "<C-W>h")
map("n", "<Leader><Down>", "<C-W>j")
map("n", "<Leader><Up>", "<C-W>k")
map("n", "<Leader><Right>", "<C-W>l")

-- OS clipboard
map("x", "<leader>y", '"+y')
map("n", "<leader>Y", '"+yg_')
map("n", "<leader>y", '"+y')

-- don't clear selection after indent
map("v", ">", ">gv")
map("v", "<", "<gv")
map("v", "<tab>", ">gv")
map("v", "<s-tab>", "<gv")

map("n", "U", "<C-R>", "Redo last change")


local function toggle_relative_line_numbers()
  vim.o.relativenumber = not vim.o.relativenumber
end

map("n", "<leader>rn", toggle_relative_line_numbers, "Toggle relative line numbers")
