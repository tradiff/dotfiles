return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function ()
        return vim.fn.executable "make" == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim", },
    { "nvim-tree/nvim-web-devicons", },
  },
  config = function ()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- If there is a multi selection, put the selected ones into the quickfix
    -- window; else, open the file in the current buffer.
    local function my_smart_select(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local num_selections = table.getn(picker:get_multi_selection())
      if num_selections > 1 then
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
        -- jump to the first qf match.
        vim.cmd.cc()
      else
        actions.select_default(prompt_bufnr)
      end
    end

    require("telescope").setup({
      defaults = {
        selection_caret = "▶ ",
        dynamic_preview_title = true,
        results_title = false,
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            width = 99999999,
            height = 99999999,
            prompt_position = "top",
            preview_width = 0.7,
          },
        },

        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--vimgrep",
          "--multiline",
        },
        mappings = {
          n = {
            ["<C-d>"] = actions.delete_buffer,
          },
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<esc>"] = actions.close,
            ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<cr>"] = my_smart_select,
            ["<C-d>"] = actions.delete_buffer,
          },
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp", })
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps", })
    vim.keymap.set("n", "<leader>ff", function () builtin.find_files({ hidden = true, }) end,
      { desc = "[F]ind [F]iles", })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord", })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep", })
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume", })
    vim.keymap.set("n", "<leader><leader>",
      function () builtin.buffers({ sort_mru = true, ignore_current_buffer = true, }) end,
      { desc = "[ ] Find existing buffers", })
    vim.keymap.set("n", "<leader>fd", builtin.git_status, { desc = "[G]it Status", })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "[F]ind LSP [S]ymbols", })
  end,
}
