vim.g.mapleader = " "

-- enable the mouse (I know, I'm a terrible person)
vim.o.mouse = "a"

-- show matching brackets
vim.o.showmatch = true

-- case insensitive matching
vim.o.ignorecase = true

-- hilight search results
vim.o.hlsearch = true

-- show match while typing
vim.opt.incsearch = true

-- indent new lines the same amount as the line just typed
vim.o.autoindent = true

-- add line numbers
vim.o.number = true
vim.o.relativenumber = true

-- vertical line
vim.o.cc = "80"

-- number of columns occupied by a tab character
vim.o.tabstop = 2

-- convert tabs to white space
vim.o.expandtab = true

-- width for autoindents
vim.o.shiftwidth = 2

-- see multiple spaces as tabstops so <BS> does the right thing
vim.o.softtabstop = 2

-- word wrapping
vim.o.wrap = false

vim.o.termguicolors = true

vim.o.splitright = true
vim.o.splitbelow = true

-- always show the signs column, even if empty
vim.o.signcolumn = "yes"

-- always show at least 7 characters around the cursor
vim.o.scrolloff = 7
vim.o.sidescrolloff = 7

vim.o.cursorline = true

vim.o.swapfile = false

-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true, })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- don't add a comment character after using o or O in normal mode
vim.cmd([[autocmd BufEnter * set formatoptions-=o]])

vim.o.modeline = false

-- don't use scrolloffset in quickfix
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "qf",
  callback = function()
    vim.wo.scrolloff = 0
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
  end,
})
