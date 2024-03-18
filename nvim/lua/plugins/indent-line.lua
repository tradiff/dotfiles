-- vertical lines showing indentation level
return {
  "Yggdroot/indentLine",
  enabled = false,
  config = function()
    vim.cmd([[ let g:indentLine_char = '▏' ]])
    vim.cmd([[ let g:indentLine_fileTypeExclude = ['fzf'] ]])
  end,
}
