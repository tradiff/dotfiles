-- -- LSP config
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "solargraph",
        "rubocop",
        "lua-ls",
      },
    },
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "onsails/lspkind.nvim",
}
