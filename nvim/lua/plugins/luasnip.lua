return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  event = "InsertEnter",
  config = function ()
    local luasnip = require("luasnip")
    luasnip.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    })
    -- add vscode exported completions
    require("luasnip.loaders.from_vscode").lazy_load()

    vim.keymap.set({ "i", }, "<C-K>", function () luasnip.expand() end, { silent = true, })
    vim.keymap.set({ "i", "s", }, "<C-L>", function () luasnip.jump(1) end, { silent = true, })
    vim.keymap.set({ "i", "s", }, "<C-J>", function () luasnip.jump(-1) end, { silent = true, })

    vim.keymap.set({ "i", "s", }, "<C-E>", function ()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      end
    end, { silent = true, })
  end,
}

