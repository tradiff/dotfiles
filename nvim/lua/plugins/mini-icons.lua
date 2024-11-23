return {
  "echasnovski/mini.icons",
  enabled = true,
  config = function()
    local mini_icons = require("mini.icons")

    mini_icons.setup({
      filetype = {
        ["ruby.spec"] = { glyph = "", hl = "MiniIconsGreen" }
      },
      use_file_extension = function(ext, _) return ext:sub(-2) ~= "rb" end,
    })
    mini_icons.mock_nvim_web_devicons()
    mini_icons.tweak_lsp_kind()
  end,
}
