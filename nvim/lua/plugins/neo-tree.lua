local map = require("map")
-- file tree
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  init = function()
    -- use - to toggle the tree.
    -- I'm not using `:Neotree toggle` because I want a slightly different
    -- behavior if the tree is already open but not focused. I want to send
    -- focus to it in that case, where `toggle` would have closed it.
    -- Opening is defined here, closing is in the window mappings below.
    map("n", "-", ":Neotree reveal<CR>")
  end,
  config = function()
    vim.fn.sign_define("DiagnosticSignError",
      { text = " ", texthl = "DiagnosticSignError", })
    vim.fn.sign_define("DiagnosticSignWarn",
      { text = " ", texthl = "DiagnosticSignWarn", })
    vim.fn.sign_define("DiagnosticSignInfo",
      { text = " ", texthl = "DiagnosticSignInfo", })
    vim.fn.sign_define("DiagnosticSignHint",
      { text = "", texthl = "DiagnosticSignHint", })

    ---Gets the node parent folder recursively
    ---@param tree table to look for nodes
    ---@param node table to look for folder parent
    ---@return table table
    local function get_folder_node(tree, node)
      if not node then
        node = tree:get_node()
      end
      if node.type == "directory" then
        return node
      end
      return get_folder_node(tree, tree:get_node(node:get_parent_id()))
    end


    local function getTelescopeOpts(state, path)
      return {
        cwd = path,
        search_dirs = { path },
        attach_mappings = function(prompt_bufnr, map)
          local actions = require "telescope.actions"
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local action_state = require "telescope.actions.state"
            local selection = action_state.get_selected_entry()
            local filename = selection.filename
            if (filename == nil) then
              filename = selection[1]
            end
            require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
          end)
          return true
        end
      }
    end


    require("neo-tree").setup({
      close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf", }, -- when opening files, do not use windows containing these filetypes or buftypes
      sort_case_insensitive = false,                                      -- used when sorting files and directories in the tree
      sort_function = nil,                                                -- use a custom function for sorting files and directories in the tree
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰉖",
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = "✖", -- this can only be used in the git_status source
            renamed = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },

        file_size = {
          enabled = false,
        },
        type = {
          enabled = false,
        },
        last_modified = {
          enabled = false,
        },
        created = {
          enabled = false,
        },

      },
      commands = {},
      window = {
        position = "float",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel", -- close preview or floating neo-tree window
          ["P"] = { "toggle_preview", config = { use_float = true, }, },
          ["l"] = "focus_preview",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "none",
          ["w"] = "none",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["a"] = {
            "add",
            config = {
              show_path = "none", -- "none", "relative", "absolute"
            },
          },
          ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
          ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ["-"] = "close_window",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["h"] = "close_node",
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },
        group_empty_dirs = false,               -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
          mappings = {
            ["."] = "set_root",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["D"] = "fuzzy_finder_directory",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["tg"] = "tree_grep",
          },
        },
        commands = {
          tree_grep = function(state)
            local node = get_folder_node(state.tree, state.tree:get_node())
            require("telescope.builtin").live_grep(getTelescopeOpts(state, node.path))
          end,
        },
      },

      sources = {
        "filesystem",
      },
      source_selector = {
        winbar = false,
        statusline = false,
      },
    })
  end,
}
