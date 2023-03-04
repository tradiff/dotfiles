return {
  'akinsho/bufferline.nvim',
  version = 'v3.*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        filetype = false,
        close_command = 'Bdelete %d',
        right_mouse_command = 'Bdelete %d',
        offsets = { {
          filetype = 'neo-tree',
          text = ''
        } },
        separator_style = 'slant', -- "slant" | "thick" | "thin" | { 'any', 'any' },
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' }
        },
        sort_by =
        'insert_after_current' -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
      }
    }
  end,
  init = function()
    -- <TAB><S-TAB> switch between buffers
    vim.keymap.set('n', '<TAB>', ':BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<S-TAB>', ':BufferLineCyclePrev<CR>')

    vim.api.nvim_create_user_command('Pin', 'BufferLineTogglePin', { nargs = 0 })
  end,
}
