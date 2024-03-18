local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local map = require("map")

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
  map("n", "K", vim.lsp.buf.hover, bufopts)
  map("i", "<C-k>", vim.lsp.buf.hover, bufopts)
  map("n", "gr", "<CMD>Glance references<CR>", bufopts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.solargraph.setup({
  init_options = {
    formatting = false,
  },
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.rubocop.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = { "bundle", "exec", "rubocop", "--lsp", }
  end,
  init_options = {
    layoutMode = true,
  },
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
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

local lsp_formatting_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true, })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = lsp_formatting_group,
  pattern = "*.*",
  callback = function()
    local success, error_message = pcall(function()
      vim.lsp.buf.format({ async = false, })
    end)

    if not success then
      print("An error occurred:", error_message)
    end
  end,
})
