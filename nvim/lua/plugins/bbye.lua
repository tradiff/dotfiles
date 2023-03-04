-- close buffers without closing windows
return {
  'moll/vim-bbye',
  config = function()
    -- delete the current buffer
    vim.keymap.set('n', '<leader>q', ':Bdelete<cr>')
  end
}
