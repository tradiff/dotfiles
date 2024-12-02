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
          { "<leader>f", group = "file/find" },
          { "z",         group = "fold" },
        },
      },
    })
  end,
}
