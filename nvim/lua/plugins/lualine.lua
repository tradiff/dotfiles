-- status bar
return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local lualine = require("lualine")
    local lualine_nightfly = require("lualine.themes.nightfly")
    local utils = require("lualine.utils.utils")


    -- new colors for theme
    local new_colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      black = "#000000",
      bg = "#2C3043",
    }

    local function search_result()
      if vim.v.hlsearch == 0 then
        return ""
      end
      local last_search = vim.fn.getreg("/")
      if not last_search or last_search == "" then
        return ""
      end
      local searchcount = vim.fn.searchcount { maxcount = 9999, }
      return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
    end

    local statusbar_sections = {
      lualine_a = {
        {
          "mode",
          separator = { left = "", right = "", },
          padding = { left = 0, right = 0, },
        },
      },
      lualine_b = {
        "MatchupStatusOffscreen",
      },
      lualine_c = { "branch", search_result, },
      lualine_x = {},
      lualine_y = { "progress", },
      lualine_z = {
        {
          "location",
          separator = { left = "", right = "", },
          padding = { left = 0, right = 0, },
        },
      },
    }

    local winbar_sections = {
      lualine_a = {},
      lualine_b = {
        {
          "require('arrow.statusline').text_for_statusline_with_icons()",
          color = { fg = new_colors.blue },
          padding = { right = 1, left = 1, },
        },
        {
          "filetype",
          colored = true,
          icon_only = true,
          icon = { align = "right", },
          padding = { right = 1, left = 1, },
        },
        {
          "filename",
          file_status = true,
          newfile_status = false,
          path = 1,
          shorting_target = 40,
          symbols = {
            modified = "[[]]",
            readonly = "[-]",
            unnamed = "[No Name]",
            newfile = "[New]",
          },
          padding = { right = 0, left = 0, },
        },
        {
          "vim.bo.modified and [[●]] or [[]]",
          color = { fg = new_colors.yellow, },
          padding = { right = 1, left = 0, },
        },
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic", "vim_lsp", },
          sections = { "error", "warn", "info", "hint", },
          diagnostics_color = {
            -- These highlight groups don't contain a bg color, so we're doing this
            -- complicated stuff to build a color based on the highlight group.
            error = {
              bg = new_colors.bg,
              fg = utils.extract_highlight_colors("DiagnosticError", "fg"),
            },
            warn = {
              bg = new_colors.bg,
              fg = utils.extract_highlight_colors("DiagnosticWarn", "fg"),
            },
            info = {
              bg = new_colors.bg,
              fg = utils.extract_highlight_colors("DiagnosticInfo", "fg"),
            },
            hint = {
              bg = new_colors.bg,
              fg = utils.extract_highlight_colors("DiagnosticHint", "fg"),
            },
          },
          symbols = { error = " ", warn = " ", info = " ", hint = " ", },
          colored = true,
          update_in_insert = false,
          always_visible = false,
          padding = { left = 0, right = 0, },
        },
        {
          "diff",
          symbols = { added = "+", modified = "~", removed = "-", },
          padding = { left = 2, right = 1, },
        },
      },
      lualine_z = {},
    }
    lualine.setup({
      options = {
        theme = lualine_nightfly,
        globalstatus = true,
        component_separators = { left = "", right = "", },
        section_separators = { left = "", right = "", },
        disabled_filetypes = {
          statusline = {},
          winbar = {
            "qf",
            "neo-tree",
          },
        },
      },
      sections = statusbar_sections,
      winbar = winbar_sections,
      inactive_winbar = winbar_sections,
      extensions = {
        "quickfix",
        "neo-tree",
      },
    })
  end,
}
