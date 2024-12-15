return {
  {
    "stevearc/conform.nvim",
    enabled = true,
    config = function()
      vim.g.autoformat = true

      require("conform").setup({
        notify_on_error = true,
        default_format_opts = {
          timeout_ms = 1000,
          lsp_format = "fallback",
        },
        format_on_save = function()
          if vim.g.autoformat then
            -- returning a table enables format on save
            return {}
          else
            return
          end
        end,
        formatters = {
        },
        formatters_by_ft = {
        },
      })

      Snacks.toggle({
        name = "Auto Format",
        get = function() return vim.g.autoformat end,
        set = function(state) vim.g.autoformat = state end,
      }):map("<leader>uf")
    end
  },
}
