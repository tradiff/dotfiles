local map = require("map")
-- alternate files, among other things
return {
  "tpope/vim-rails",
  config = function ()
    map("n", "<leader>a", ":A<cr>", "Alternate file")
    map("n", "<leader>A", ':execute "e " . eval("rails#buffer().alternate()")<cr>',
      "Alternate file, create if missing")

    vim.g.rails_projections = {
      ["app/controllers/*_controller.rb"] = {
        ["test"] = {
          "spec/requests/{}_spec.rb",
          "spec/controllers/{}_controller_spec.rb",
          "test/controllers/{}_controller_test.rb",
        },
        ["alternate"] = {
          "spec/requests/{}_spec.rb",
          "spec/controllers/{}_controller_spec.rb",
          "test/controllers/{}_controller_test.rb",
        },
      },
      ["spec/requests/*_spec.rb"] = {
        ["command"] = "request",
        ["alternate"] = "app/controllers/{}_controller.rb",
      },
    }
  end,
}
