vim.cmd([[colorscheme nightfly]])

vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#103235' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#272D43' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = '#394B70' })
vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { bg = '#3F2D3D' })
vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { fg = '#3B4252' })
vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#21252A', bg = '#1A1D21' })
