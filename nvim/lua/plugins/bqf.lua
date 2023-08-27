-- better quickfix

-- When using `dd` in the quickfix list, remove the item from the quickfix list.
local delete_qf_entry = function ()
  local idx = vim.fn.line(".")
  local qfl = vim.fn.getqflist()
  table.remove(qfl, idx)
  vim.fn.setqflist(qfl, "r")
  vim.cmd("normal " .. idx .. "gg")
end

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "qf",
  callback = function ()
    vim.keymap.set("n", "dd", function () delete_qf_entry() end, { desc = "delete quickfix entry", buffer = 0, })
  end,
})

return {
  "kevinhwang91/nvim-bqf",
  config = function ()
    require("bqf").setup({
      preview = {
        auto_preview = false,
      },
    })
  end,
}
