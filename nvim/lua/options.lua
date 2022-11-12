vim.g.mapleader = ' '

-- enable the mouse (I know, I'm a terrible person)
vim.o.mouse = 'a'

-- disable compatibility with old-time vi
vim.o.nocompatible = true

-- show matching brackets
vim.o.showmatch = true

-- case insensitive matching
vim.o.ignorecase = true

-- hilight search results
vim.o.hlsearch = true

-- indent new lines the same amount as the line just typed
vim.o.autoindent = true

-- add line numbers
vim.o.number = true

-- vertical line
vim.o.cc = '80'

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

-- attempt to delay the loading of the persistance buffers until after
-- syntax hilighting is loaded. it's not working, the initial file loaded
-- doesn't have syntax hilighting. still invetigating.
local persistence_group = vim.api.nvim_create_augroup('persistence', {
  clear = true
})
vim.api.nvim_create_autocmd('UIEnter', {
  command = 'lua require("persistence").load()',
  group = persistence_group
})
