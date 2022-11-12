return require('packer').startup(function(use)

  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use {
    'bluz71/vim-nightfly-guicolors',
    config = function()
      vim.cmd [[colorscheme nightfly]]
    end
  }

  -- file tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    tag = 'nightly',
    config = function()
      require('plugins.nvim-tree')
    end
  }

  -- file tabs at the top
  use {
    'akinsho/bufferline.nvim',
    tag = 'v3.*',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('plugins.bufferline')
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
  use({
    'glepnir/lspsaga.nvim',
    branch = 'main'
  })
  use 'onsails/lspkind.nvim'

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
    config = function()
      require('plugins.telescope')
    end
  }

  -- dependency for better sorting performance
  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  })

  -- vertical lines showing indentation level
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('plugins.indent-blankline')
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
  use { 'tpope/vim-fugitive' }

  -- git gutter
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('plugins.gitsigns')
    end
  }

  -- copy git permalinks
  use {
    'ruifm/gitlinker.nvim',
    config = function()
      require('gitlinker').setup {}
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
end)
