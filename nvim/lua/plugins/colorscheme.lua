-- colorscheme

return {
  "folke/tokyonight.nvim",
  name = "colorscheme",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "night",
      dim_inactive = true, -- dims inactive windows

      on_highlights = function(hl, _c)
        hl.DiffAdd = { bg = "#103235", }
        hl.DiffDelete = { bg = "#37222c", fg = "#1a1b26", }
        hl.Comment = { fg = "#727ca7" } -- bit more contrast
        hl.Folded = { bg = "#1a1b26" }  -- line used for closed folds
      end,

      on_colors = function(colors)
        colors.bg_float = "#1f202d"
      end
    })

    vim.cmd([[colorscheme tokyonight]])
  end,
}
