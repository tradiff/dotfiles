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

      on_colors = function(colors)
        -- with "night" and dim_inactive, floats end up with the same color
        -- as the code window, which makes things very confusing. Override floats
        -- to something different.
        colors.bg_float = "#000000"
      end,

      on_highlights = function(hl, c)
        hl.Comment = { fg = "#727ca7" }               -- bit more contrast
        hl.Folded = { bg = "#1a1b26" }                -- line used for closed folds
        hl.DiagnosticUnnecessary = { fg = "#727ca7" } -- bit more contrast

        -- Override telescope backgrounds. The foregrounds are all original.
        -- This is because we overrode bg_float above, but since telescope is
        -- full screen, I don't want it looking like a float.
        hl.TelescopeNormal = {
          bg = c.bg,
          fg = c.fg_dark,
        }
        hl.TelescopePromptTitle = {
          bg = c.bg_dark,
          fg = c.fg,
        }
        hl.TelescopeBorder = {
          bg = c.bg_dark,
          fg = c.border_highlight,
        }
        hl.TelescopePromptBorder = {
          bg = c.bg_dark,
          fg = c.orange,
        }
      end,
    })

    vim.cmd([[colorscheme tokyonight]])
  end,
}
