return {
  "sindrets/diffview.nvim",
  dependencies = {
    "colorscheme",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local diffview = require("diffview")

    diffview.setup({
      ehanced_diff_hl = true,
    })

    -- set diff deletes to use fancy diagonal lines instead of lame hyphens
    vim.opt.fillchars = vim.opt.fillchars + "diff:╱"

    vim.api.nvim_create_user_command("DiffviewToggle", function()
      local view = require("diffview.lib").get_current_view()

      if view then
        vim.cmd("DiffviewClose")
      else
        vim.cmd("DiffviewOpen")
      end
    end, { nargs = "*", })


    vim.keymap.set("n", "<Leader>d", ":DiffviewToggle<cr>")
  end,
}
