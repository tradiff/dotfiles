-- git gutter
return {
  "lewis6991/gitsigns.nvim",
  enabled = true,
  config = function()
    local gitsigns = require("gitsigns")
    local gitsigns_actions = require("gitsigns.actions")

    gitsigns.setup({
      on_attach = function(buffer)
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        map("n", "<leader>ghb", function() gitsigns.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gitsigns.blame() end, "Blame Buffer")
      end
    })

    gitsigns_actions.change_base("HEAD", true)
  end,
}
