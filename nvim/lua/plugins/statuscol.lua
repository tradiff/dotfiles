return {
  "luukvbaal/statuscol.nvim",
  enabled = true,
  config = function ()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      ft_ignore = { "neo-tree", },
      relculright = true,
      segments = {
        -- line nums
        {
          text = { builtin.lnumfunc, },
          click = "v:lua.ScLa",
          bg = "LineNrColumn",
        },
        -- folds
        {
          text = { builtin.foldfunc, },
          click = "v:lua.ScFa",
        },
        -- signs
        {
          text = { "%s", },
          click = "v:lua.ScSa",
        },
      },
    })
  end,
}
