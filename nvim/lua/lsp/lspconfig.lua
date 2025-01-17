local lspconfig = require("lspconfig")
local map = require("map")
-- vim.lsp.set_log_level("debug")

-- enable keybinds for available lsp server
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = {
    noremap = true,
    silent = true,
    buffer = bufnr,
  }
  map("n", "gd", "<CMD>Glance definitions<CR>", bufopts)
  map("n", "gr", "<CMD>Glance references<CR>", bufopts)
  map("n", "ca", vim.lsp.buf.code_action, bufopts)
  map("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

require("mason-lspconfig").setup_handlers({
  -- Default handler
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

lspconfig.solargraph.setup({
  init_options = {
    formatting = false,
  },
  mason = false,
  cmd = { vim.fn.expand("~/.rbenv/shims/solargraph"), "stdio" },
  filetypes = { "ruby", "ruby.spec" },
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.rubocop.setup({
  mason = false,
  cmd = { vim.fn.expand("~/.rbenv/shims/rubocop"), "--lsp" },
  filetypes = { "ruby", "ruby.spec" },
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      format = {
        enable = true,
        defaultConfig = {
          quote_style = "double",
        },
      },
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
})

local mason_registry = require("mason-registry")
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
    .. "/node_modules/@vue/language-server"

lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Disable tsserver's formatting capability
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

-- lspconfig.volar.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- lspconfig.cssls.setup({
--   on_attach = on_attach,
--   capabilities = capabilities,
--   filetypes = { "css", "scss", "less", "sass", "vue" },
-- })
--
lspconfig.cssmodules_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "css", "scss", "less", "sass", "vue" },
})

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
