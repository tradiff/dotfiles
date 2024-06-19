return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      config = {
        kdl = { __default = "// %s", __multiline = "/* %s */", },
        hyprlang = { __default = "# %s", __multiline = "# %s", },
      },
    },
  },
  {
    "echasnovski/mini.comment",
    config = function()
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      })
    end,
  },
}
