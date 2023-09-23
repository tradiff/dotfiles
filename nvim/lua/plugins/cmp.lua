return {
  "hrsh7th/nvim-cmp",
  enabled = true,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function ()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")

    local has_words_before = function ()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = " ",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = " ",
      Misc = " ",
      Copilot = " ",
    }

    local mapping = {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<Up>"] = cmp.mapping.select_prev_item(),
      ["<Down>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c", }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c", }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c", }),
      ["<C-y>"] = cmp.config.disable, -- remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      ["<esc>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm { select = true, },
      ["<Tab>"] = cmp.mapping(function (fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function (fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    }

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function (args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = mapping,
      sources = {
        { name = "copilot", },
        { name = "luasnip", },
        { name = "nvim_lsp", },
        { name = "path", },
        { name = "buffer", },
      },

      formatting = {
        fields = { "kind", "abbr", "menu", },
        format = function (entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          vim_item.menu = ({
            copilot = "[copilot]",
            luasnip = "[snippet]",
            nvim_lsp = "[lsp]",
            path = "[path]",
            buffer = "[buffer]",
          })[entry.source.name]
          return vim_item
        end,
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
    })

    cmp.setup.cmdline(":", {
      mapping = mapping,
      sources = cmp.config.sources({
        { name = "path", },
      }, {
        { name = "cmdline", },
      }),
    })
  end,
}
