return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    vim.filetype.add({
      pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
    })
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      ensure_installed = { "lua", "ruby", "vim", "typescript", "css", "scss", "kdl", "hyprlang" },
      highlight = { enable = true, },
      indent = { enable = true, },
      incremental_selection = {
        enable = false,
      },
      matchup = {
        enable = true,
      },
    })
  end,
}
