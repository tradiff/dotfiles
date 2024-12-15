return {
  "folke/snacks.nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    lazygit = { enabled = true },
    quickfile = { enabled = true },
    toggle = { enabled = true },
    words = { enabled = true },
    notifier = {
      enabled = true,
      style = "minimal",
    },
  },
  keys = {
    { "<leader>gL", function() Snacks.lazygit() end,        desc = "Lazygit" },
    { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    {
      "<leader>nx",
      function() Snacks.notifier.hide() end,
      desc = "Dismiss all notifications",
    },
    {
      "<leader>nh",
      function() Snacks.notifier.show_history() end,
      desc = "Show notification history",
    },
  },
  init = function()
    require("which-key").add({
      { "<leader>n", group = "notifications" },
      { "<leader>u", group = "ui" }
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap"):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>un")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.treesitter():map("<leader>uT")
      end,
    })
  end,
}
