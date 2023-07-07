-- colorscheme

local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "nightfly",
  callback = function ()
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#103235", })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#272D43", })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#394B70", })
    vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#3F2D3D", })
    vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { fg = "#3B4252", })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#21252A", bg = "#1A1D21", })

    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { link = "NightflyGreyBlue", })

    vim.api.nvim_set_hl(0, "MatchParen", { link = "NightflyEmeraldMode", })
    vim.api.nvim_set_hl(0, "MatchWord", { link = "NightflyEmeraldMode", })
    vim.api.nvim_set_hl(0, "MatchParenCur", { link = "NightflyEmeraldMode", })
    vim.api.nvim_set_hl(0, "MatchWordCur", { link = "NightflyEmeraldMode", })
  end,
  group = custom_highlight,
})

return {
  "bluz71/vim-nightfly-guicolors",
  name = "colorscheme",
  lazy = false,
  priority = 1000,
  config = function ()
    vim.g.nightflyCursorColor = true
    vim.g.nightflyVirtualTextColor = true

    -- split separators
    vim.g.nightflyWinSeparator = 2
    vim.opt.fillchars = {
      horiz = "━",
      horizup = "┻",
      horizdown = "┳",
      vert = "┃",
      vertleft = "┫",
      vertright = "┣",
      verthoriz = "╋",
    }

    vim.cmd([[colorscheme nightfly]])
  end,
}
