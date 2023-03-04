-- git gutter
return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require('gitsigns')
    local gitsigns_actions = require('gitsigns.actions')

    gitsigns.setup {
      signs = {
        add          = {
          hl = 'GitSignsAdd',
          text = '▍',
          numhl = 'GitSignsAddNr',
          linehl = 'GitSignsAddLn'
        },
        change       = {
          hl = 'GitSignsChange',
          text = '▍',
          numhl = 'GitSignsChangeNr',
          linehl = 'GitSignsChangeLn'
        },
        delete       = {
          hl = 'GitSignsDelete',
          text = '_',
          numhl = 'GitSignsDeleteNr',
          linehl = 'GitSignsDeleteLn'
        },
        topdelete    = {
          hl = 'GitSignsDelete',
          text = '‾',
          numhl = 'GitSignsDeleteNr',
          linehl = 'GitSignsDeleteLn'
        },
        changedelete = {
          hl = 'GitSignsChange',
          text = '▍',
          numhl = 'GitSignsChangeNr',
          linehl = 'GitSignsChangeLn'
        },
        untracked    = {
          hl = 'GitSignsAdd',
          text = '┆',
          numhl = 'GitSignsAddNr',
          linehl = 'GitSignsAddLn'
        },
      },
      signcolumn = true,
      numhl = true,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 0,
        ignore_whitespace = false
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,  -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm = {
        enable = false
      },
    }

    gitsigns_actions.change_base('HEAD', true)
  end
}
