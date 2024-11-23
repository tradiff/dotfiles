return {
  {
    "stevearc/conform.nvim",
    enabled = true,
    config = function()
      require("conform").setup({
        notify_on_error = true,
        default_format_opts = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
        -- enables format on save
        format_on_save = {},
        formatters = {
          rubocop = {
            inherit = true,
            append_args = {
              "-x",
            }
          },
        },
        formatters_by_ft = {
          ruby = { "rubocop" },
        },
      })
    end
  },
}
