-- vertical lines showing indentation level
return {
  'Yggdroot/indentLine',
  config = function()
    vim.cmd([[ let g:indentLine_char = '▏' ]])
    vim.cmd([[ let g:indentLine_fileTypeExclude = ['fzf'] ]])
  end
}
