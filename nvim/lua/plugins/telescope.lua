-- fuzzy finder over lists
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'colorscheme',
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    -- clear the selection highlight
    vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = 'bg' })

    -- used to feed the current selected text into telescope
    local function getVisualSelection()
      vim.cmd('noau normal! "vy"')
      local text = vim.fn.getreg('v')
      vim.fn.setreg('v', {})

      text = string.gsub(text, '\n', '')
      if #text > 0 then
        return text
      else
        return ''
      end
    end

    telescope.setup({
      defaults = {
        selection_caret = '▶ ',
        dynamic_preview_title = true,
        path_display = function(_, path)
          local tail = require('telescope.utils').path_tail(path)
          local directory = string.sub(path, 1, -(string.len(tail) + 1))
          return string.format('%s (%s)', tail, directory)
        end,
        border = true,
        borderchars = {
          prompt = { '─', '│', 'x', '│', '╭', '┬', '│', '│' },
          results = { '─', '│', '─', '│', '├', '┤', '┴', '╰' },
          preview = { '─', '│', '─', ' ', '─', '╮', '╯', '─' },
        },
        results_title = false,
        layout_strategy = 'horizontal',
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = {
            width = 99999999,
            height = 99999999,
            prompt_position = 'top',
            preview_width = 0.7,
          }
        },
        mappings = {
          i = {
                ['<C-k>'] = actions.move_selection_previous,
                ['<C-j>'] = actions.move_selection_next,
                ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                ['<esc>'] = actions.close,
                ['<C-Down>'] = actions.cycle_history_next,
                ['<C-Up>'] = actions.cycle_history_prev,
          }
        },
        vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number',
          '--column', '--smart-case' }
      },
      pickers = {
        find_files = {
          hidden = false,
        },
        live_grep = {
        },
        lsp_references = {
          show_line = false
        },
      }
    })

    telescope.load_extension('fzf')

    local keymap = vim.keymap.set
    local tb = require('telescope.builtin')
    local opts = { noremap = true, silent = true }

    keymap('n', '<leader>?', tb.oldfiles, { desc = '[?] Find recently opened files' }, opts)
    keymap('n', '<leader><space>', tb.buffers, { desc = '[ ] Find existing buffers' }, opts)
    keymap('n', '<leader>/', tb.current_buffer_fuzzy_find,
      { desc = '[/] Fuzzily search in current buffer]' }, opts)
    keymap('n', '<leader>ff', tb.find_files, { desc = '[F]ind [F]iles' }, opts)
    keymap('n', '<leader>fh', tb.help_tags, { desc = '[F]ind [H]elp' }, opts)
    keymap('n', '<leader>fw', tb.grep_string, { desc = '[F]ind current [W]ord' }, opts)
    keymap('n', '<leader>fg', tb.live_grep, { desc = '[F]ind by [G]rep' }, opts)
    keymap('v', '<leader>fg', function()
      local text = getVisualSelection()
      tb.live_grep({ default_text = text, desc = '[F]ind by [G]rep' })
    end, opts)

    keymap('n', '<leader>fd', tb.git_status, { desc = 'Git Status' }, opts)
    keymap('n', '<leader>fs', tb.lsp_document_symbols, { desc = '[F]ind LSP [S]ymbols' }, opts)

    vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal wrap]]
    vim.cmd [[autocmd User TelescopePreviewerLoaded setlocal number]]
  end
}
