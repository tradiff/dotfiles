return {
  {
    "junegunn/fzf",
    run = "./install --bin",
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "junegunn/fzf",
      "nvim-tree/nvim-web-devicons",
    },
    config = function ()
      local fzflua = require("fzf-lua")
      local utils = require("fzf-lua").utils

      local function hl_validate(hl)
        return not utils.is_hl_cleared(hl) and hl or nil
      end

      local map = vim.keymap.set
      local opts = { noremap = true, silent = true, }

      map("n", "<leader><space>", function () fzflua.buffers() end, opts)
      map("n", "<leader>ff", function () fzflua.files() end, opts)
      map("n", "<leader>fg", function () fzflua.live_grep() end, opts)
      map("n", "<leader>fd", function () fzflua.git_status() end, opts)

      fzflua.setup({
        winopts = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│", },
          fullscreen = true,
          hl = {
            normal = hl_validate "TelescopeNormal",
            border = hl_validate "TelescopeBorder",
            help_normal = hl_validate "TelescopeNormal",
            help_border = hl_validate "TelescopeBorder",
            -- builtin preview only
            cursor = hl_validate "Cursor",
            cursorline = hl_validate "TelescopePreviewLine",
            cursorlinenr = hl_validate "TelescopePreviewLine",
            search = hl_validate "IncSearch",
            title = hl_validate "TelescopeTitle",
          },
          preview = {
            wrap = "wrap",
          },
        },
        fzf_colors = {
          ["fg"] = { "fg", "TelescopeNormal", },
          ["bg"] = { "bg", "TelescopeNormal", },
          ["hl"] = { "fg", "TelescopeMatching", },
          ["fg+"] = { "fg", "TelescopeSelection", },
          ["bg+"] = { "bg", "TelescopeSelection", },
          ["hl+"] = { "fg", "TelescopeMatching", },
          ["info"] = { "fg", "TelescopeMultiSelection", },
          ["border"] = { "fg", "TelescopeBorder", },
          ["gutter"] = { "bg", "TelescopeNormal", },
          ["prompt"] = { "fg", "TelescopePromptPrefix", },
          ["pointer"] = { "fg", "TelescopeSelectionCaret", },
          ["marker"] = { "fg", "TelescopeSelectionCaret", },
          ["header"] = { "fg", "TelescopeTitle", },
        },
        files = {
          fzf_opts = {
            ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-files-history",
          },
          rg_opts = "--color=never --files --hidden --follow -g '!.git' -j1 --sort=path --sort-files",
        },
        grep = {
          fzf_opts = {
            ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-grep-history",
          },
        },
        buffers = {
          no_header = true,
          fzf_opts = {
            ["--header"] = [['<ctrl-x> delete unselected']],
          },
          actions = {
            -- delete the unselected buffers
            ["ctrl-x"] = { fn = fzflua.actions.buf_del, reload = true, prefix = "toggle-all+", },
          },
        },
      })
    end,
  },
}
