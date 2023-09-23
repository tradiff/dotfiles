-- highlight jump targets when using f, F, t, T
return {
  "jinh0/eyeliner.nvim",
  config = function ()
    require "eyeliner".setup {
      highlight_on_key = true,
      dim = true,
    }
  end,
}
