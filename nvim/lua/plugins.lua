return require('packer').startup(function(use)

  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use {
    'bluz71/vim-nightfly-guicolors',
    as = 'colorscheme',
    config = function()
      require('plugins.nightfly')
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('plugins.treesitter')
    end,
  }

  use {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('plugins.nvim-web-devicons')
    end,
  }

  -- file tree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('plugins.neo-tree')
    end
  }

  -- file tabs at the top
  use {
    'akinsho/bufferline.nvim',
    tag = 'v3.*',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('plugins.bufferline')
    end
  }

  -- close buffers without closing windows
  use {
    'moll/vim-bbye',
    config = function()
      require('plugins.vim-bbye')
    end
  }

  -- comment and uncomment code
  use 'tpope/vim-commentary'

  -- halp
  use {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup {}
    end
  }

  -- tab completion
  use { {
    'hrsh7th/nvim-cmp',
    config = function()
      require('plugins.cmp')
    end
  }, 'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip' }

  -- LSP config
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind.nvim'

  -- LSP loading indicator
  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({
        text = {
          spinner = 'line'
        }
      })
    end
  }

  -- status bar
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('plugins.lualine')
    end
  }

  -- fuzzy finder over lists
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim' } },
    after = 'colorscheme',
    config = function()
      require('plugins.telescope')
    end
  }

  -- dependency for better sorting performance
  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  })

  use {
    'theprimeagen/harpoon',
    config = function()
      require('plugins.harpoon')
    end
  }

  -- vertical lines showing indentation level
  use {
    'Yggdroot/indentLine',
    config = function()
      require('plugins.indent-line')
    end
  }

  -- unit tests
  -- use 'tpope/vim-dispatch'
  use {
    'vim-test/vim-test',
    config = function()
      require('plugins.vim-test')
    end
  }
  use 'skywind3000/asyncrun.vim'

  -- alternate files, among other things
  use {
    'tpope/vim-rails',
    config = function()
      require('plugins.vim-rails')
    end
  }

  -- git stuff
  -- git gutter
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('plugins.gitsigns')
    end
  }

  use {
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    after = 'colorscheme',
    config = function()
      require('plugins.diffview')
    end
  }

  -- copy git permalinks
  use {
    'ruifm/gitlinker.nvim',
    config = function()
      require('gitlinker').setup {}
    end
  }

  use {
    'tpope/vim-fugitive',
    config = function()
      require('plugins.fugitive')
    end
  }

  -- persistant sessions
  use({
    'Shatur/neovim-session-manager',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('plugins.session-manager')
    end
  })

  use({
    'knubie/vim-kitty-navigator'
  })

  -- insert debug statements into code
  use({
    'rareitems/printer.nvim',
    config = function()
      require('plugins.printer')
    end
  })

  use({
    'windwp/nvim-autopairs',
    config = function()
      require('plugins.nvim-autopairs')
    end
  })
end)
