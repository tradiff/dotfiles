return {
  {
    "stevearc/conform.nvim",
    enabled = true,
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          vue = { "prettier" },
        },

        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      })
    end
  },
}
