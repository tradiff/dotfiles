-- LSP loading indicator
return {
  "j-hui/fidget.nvim",
  tag = "legacy",
  config = function()
    require("fidget").setup({
      text = {
        spinner = "line",
      },
    })
  end,
}
