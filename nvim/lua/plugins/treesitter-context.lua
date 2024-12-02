-- sticky scroll
return {
  "nvim-treesitter/nvim-treesitter-context",
  enabled = true,
  config = function()
    require("treesitter-context").setup({
      mode = "topline",
      multiline_threshold = 2,
    })
  end,
}
