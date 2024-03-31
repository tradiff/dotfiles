local Job = require "plenary.job"

local function get_os_command_output(cmd, cwd)
  if type(cmd) ~= "table" then return {} end
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data) table.insert(stderr, data) end,
  }):sync()
  return stdout, ret, stderr
end

return {
  "ThePrimeagen/harpoon",
  enabled = true,
  branch = "harpoon2",
  dependencies = {},
  opts = {
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
      key = function()
        local branch = get_os_command_output({
          "git",
          "rev-parse",
          "--abbrev-ref",
          "HEAD",
        })[1]

        if branch then
          return vim.loop.cwd() .. "-" .. branch
        else
          return vim.loop.cwd()
        end
      end,
    }
  },

  keys = function()
    local harpoon = require("harpoon")
    return {
      {
        "<leader>hh",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list(), {
            border = "rounded",
            title_pos = "center",
            ui_width_ratio = 0.9,
          }
          )
        end,
        desc = "Harpoon: UI",
      },
      { "<leader>ha", function() require("harpoon"):list():append() end,  desc = "Harpoon: Add", },
      { "<leader>1",  function() require("harpoon"):list():select(1) end, desc = "Harpoon: Nav 1", },
      { "<leader>2",  function() require("harpoon"):list():select(2) end, desc = "Harpoon: Nav 2", },
      { "<leader>3",  function() require("harpoon"):list():select(3) end, desc = "Harpoon: Nav 3", },
      { "<leader>4",  function() require("harpoon"):list():select(4) end, desc = "Harpoon: Nav 4", },
      { "<leader>5",  function() require("harpoon"):list():select(5) end, desc = "Harpoon: Nav 5", },
    }
  end
}
