return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({

        suggestion = { enabled = false, },
        panel = { enabled = false, },
        filetypes = {
          ["*"] = false, -- disable for all other filetypes
          lua = true,
          ruby = true,
        },
      })
    end,
  },
}
