local telescope = require('telescope')
local actions = require('telescope.actions')

vim.cmd([[highlight TelescopeSpec gui=none guifg=none guibg=#103235]])
vim.cmd([[highlight TelescopeAdmin gui=none guifg=none guibg=#272D43]])

local highlights = {
  { 'spec/.*', 'TelescopeSpec' },
  { 'app/admin/.*', 'TelescopeAdmin' }
}

telescope.setup({
  defaults = {
    selection_caret = '▶ ',
    dynamic_preview_title = true,
    path_display = function(_, path)
      local tail = require('telescope.utils').path_tail(path)
      local directory = string.sub(path, 1, -(string.len(tail) + 1))
      return string.format('%s (%s)', tail, directory)
    end,
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        width = 0.99
      }
    },
    mappings = {
      i = {
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
        ['<esc>'] = actions.close
      }
    },
    vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number',
      '--column', '--smart-case' }
  },
  pickers = {
    find_files = {
      hidden = false,
      entry_maker = require 'plugins.telescope_make_entry'.gen_from_file(
        {
          highlights = highlights
        }
      ),
    },
    live_grep = {
      entry_maker = require 'plugins.telescope_make_entry'.gen_from_vimgrep(
        {
          highlights = highlights
        }
      ),
    }
  }
})

telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>tf', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>tg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>tb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<leader>th', '<cmd>Telescope help_tags<CR>')
vim.keymap.set('n', '<leader>td', '<cmd>Telescope git_status<CR>')
