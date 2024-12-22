-- halp
return {
  "folke/which-key.nvim",
  enabled = true,
  config = function()
    require("which-key").setup({
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>c", group = "CopilotChat" },
          { "<leader>f", group = "file/find" },
          { "z",         group = "fold" },
        },
      },
    })
  end,
}
