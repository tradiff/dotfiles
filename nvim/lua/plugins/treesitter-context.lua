-- sticky scroll
return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup({
      mode = "cursor",
      multiline_threshold = 2,
    })
  end,
}
