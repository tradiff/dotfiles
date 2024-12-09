-- `viq`/`vaq` select quoted strings
-- `vib`/`vab` select brackets
return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({ -- code block
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = ai.gen_spec.treesitter({ -- function
          a = "@function.outer",
          i = "@function.inner"
        }),
        c = ai.gen_spec.treesitter({ -- class
          a = "@class.outer",
          i = "@class.inner"
        }),
      },
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)
  end,
}
