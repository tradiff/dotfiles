-- insert debug statements into code
return {
  "rareitems/printer.nvim",
  config = function()
    require("printer").setup({
      keymap = "gp",
      behavior = "insert_below",
      formatters = {
        ruby = function(inside, variable)
          return string.format('pp "%s: ", %s', inside, variable)
        end,
      },
      add_to_inside = function(text)
        return string.format("DEBUG %s:%s %s", vim.fn.expand("%:t"), vim.fn.line("."), text)
      end,
    })
  end,
}
