telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
    defaults = {
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
                ["<esc>"] = actions.close
            }
        },
        vimgrep_arguments = {'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number',
                             '--column', '--smart-case'}
    },
    pickers = {
        find_files = {
            hidden = false
        }
    }
})

telescope.load_extension('fzf')

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>')
vim.keymap.set('n', '<leader>en', '<cmd lua require("telescope.builtin").find_files({cwd = "~/.config/nvim"})<CR>')
vim.keymap.set('n', '<leader>f<leader>', '<cmd>Telescope grep_string<CR>')
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope git_status<CR>')
