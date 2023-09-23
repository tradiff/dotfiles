-- colorscheme

local custom_highlight = vim.api.nvim_create_augroup("CustomHighlight", {})
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "nightfly",
  group = custom_highlight,
  callback = function ()
    local set_hl = vim.api.nvim_set_hl
    local get_fg = function (name)
      return vim.api.nvim_get_hl_by_name(name, true).foreground
    end

    set_hl(0, "DiffAdd", { bg = "#103235", })
    set_hl(0, "DiffChange", { bg = "#272D43", })
    set_hl(0, "DiffText", { bg = "#394B70", })
    set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#3F2D3D", })
    set_hl(0, "DiffviewDiffDelete", { fg = "#3B4252", })
    set_hl(0, "DiffDelete", { fg = "#21252A", bg = "#1A1D21", })

    set_hl(0, "NeoTreeGitUntracked", { link = "NightflyGreyBlue", })

    set_hl(0, "MatchParen", { link = "NightflyEmeraldMode", })
    set_hl(0, "MatchWord", { link = "NightflyEmeraldMode", })
    set_hl(0, "MatchParenCur", { link = "MatchWordCur", })

    local gutter_bg = "#011322"

    set_hl(0, "LineNr", { bg = gutter_bg, fg = get_fg("LineNr"), })
    set_hl(0, "CursorLineNr", { bg = gutter_bg, fg = get_fg("NightflyOrange"), })

    set_hl(0, "SignColumn", { bg = gutter_bg, })
    set_hl(0, "GitSignsAdd", { bg = gutter_bg, fg = get_fg("NightflyEmerald"), })
    set_hl(0, "GitSignsChange", { bg = gutter_bg, fg = get_fg("NightflyMalibu"), })
    set_hl(0, "GitSignsDelete", { bg = gutter_bg, fg = get_fg("NightflyRed"), })

    set_hl(0, "FoldColumn", { bg = gutter_bg, fg = get_fg("NightflyMalibu"), })
    set_hl(0, "Folded", { link = "NightflyBlueLineActive", })

    set_hl(0, "VertSplit", { link = "NightflyMalibu", })
  end,
})

return {
  "bluz71/vim-nightfly-guicolors",
  name = "colorscheme",
  lazy = false,
  priority = 1000,
  config = function ()
    vim.g.nightflyCursorColor = true
    vim.g.nightflyVirtualTextColor = false

    -- split separators
    vim.g.nightflyWinSeparator = 2
    vim.diagnostic.config({
      underline = false,
    })

    vim.cmd([[colorscheme nightfly]])
  end,
}
