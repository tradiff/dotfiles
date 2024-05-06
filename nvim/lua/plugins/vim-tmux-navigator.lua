return {
  "christoomey/vim-tmux-navigator",
  enabled = true,

  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.g.tmux_navigator_no_wrap = 1
  end,
  keys = {
    { "<m-h>",  "<cmd>TmuxNavigateLeft<cr>", },
    { "<m-j>",  "<cmd>TmuxNavigateDown<cr>", },
    { "<m-k>",  "<cmd>TmuxNavigateUp<cr>", },
    { "<m-l>",  "<cmd>TmuxNavigateRight<cr>", },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", },
  },
}
