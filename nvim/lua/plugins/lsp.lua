-- -- LSP config
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_instaleld = {
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
