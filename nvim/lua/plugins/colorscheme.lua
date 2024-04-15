-- colorscheme

return {
  "folke/tokyonight.nvim",
  name = "colorscheme",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      dim_inactive = true, -- dims inactive windows

      on_highlights = function(hl, _c)
        hl.DiffAdd = { bg = "#103235", }
        hl.DiffChange = { bg = "#272D43", }
        hl.DiffText = { bg = "#394B70", }
        hl.DiffviewDiffDelete = { fg = "#3B4252", }
        hl.Comment = { fg = "#727ca7" }     -- bit more contrast
        hl.NormalFloat = { bg = "#1f2335" } -- bit more contrast
      end,
    })

    vim.cmd([[colorscheme tokyonight-night]])
  end,
}
