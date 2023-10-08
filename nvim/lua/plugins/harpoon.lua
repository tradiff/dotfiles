return {
  "ThePrimeagen/harpoon",
  enabled = true,
  dependencies = {},
  config = function ()
    require("harpoon").setup({
      global_settings = {
        mark_branch = true,
      },
    })
  end,
  keys = {
    { "<leader>hh", function () require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon: UI", },
    { "<leader>ha", function () require("harpoon.mark").add_file() end, desc = "Harpoon: Add", },
    { "<leader>1", function () require("harpoon.ui").nav_file(1) end, desc = "Harpoon: Nav 1", },
    { "<leader>2", function () require("harpoon.ui").nav_file(2) end, desc = "Harpoon: Nav 2", },
    { "<leader>3", function () require("harpoon.ui").nav_file(3) end, desc = "Harpoon: Nav 3", },
    { "<leader>4", function () require("harpoon.ui").nav_file(4) end, desc = "Harpoon: Nav 4", },
    { "<leader>5", function () require("harpoon.ui").nav_file(5) end, desc = "Harpoon: Nav 5", },
  },
}
