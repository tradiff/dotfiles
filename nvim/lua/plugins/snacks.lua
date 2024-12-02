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
  },
  keys = {
    { "<leader>gL", function() Snacks.lazygit() end,        desc = "Lazygit" },
    { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
  },
}
