local telescope = require('telescope')
local actions = require('telescope.actions')

-- clear the selection highlight
vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = 'bg' })

-- context-specific highlights
vim.api.nvim_set_hl(0, 'TelescopeSpec', { bg = '#103235' })
vim.api.nvim_set_hl(0, 'TelescopeAdmin', { bg = '#272D43' })

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
    },
    lsp_references = {
      show_line = false
    },
  }
})

telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find,
  { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').git_status, { desc = 'Git Status' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols, { desc = '[F]ind LSP [S]ymbols' })
