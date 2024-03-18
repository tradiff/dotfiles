return {
  "tzachar/highlight-undo.nvim",
  config = function()
    require("highlight-undo").setup({
      hlgroup = "CurSearch",
      duration = 300,
    })
  end,
}
