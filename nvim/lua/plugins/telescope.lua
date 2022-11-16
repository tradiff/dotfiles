local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    dynamic_preview_title = true,
    path_display = { 'shorten' },
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

        --   ["<c-t>"] = trouble.open_with_trouble,
        ['<esc>'] = actions.close
      }
    },
    vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number',
      '--column', '--smart-case' }
  },
  pickers = {
    find_files = {
      hidden = false
    }
  }
})

telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>tf', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>tg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>tb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<leader>th', '<cmd>Telescope help_tags<CR>')
vim.keymap.set('n', '<leader>td', '<cmd>Telescope git_status<CR>')

