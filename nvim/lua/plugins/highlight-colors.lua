return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    require("nvim-highlight-colors").setup({
      render = "virtual",
      virtual_symbol = "",
      enable_named_colors = false,
      enable_tailwind = false,
    })
  end
}
