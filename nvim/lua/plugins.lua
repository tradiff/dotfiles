return require('packer').startup(function(use)

  -- packer can manage itself
  use 'wbthomason/packer.nvim'

  -- colorscheme
  use {
    'bluz71/vim-nightfly-guicolors',
    as = 'colorscheme',
    config = function()
      vim.cmd([[colorscheme nightfly]])

      vim.cmd([[highlight DiffAdd gui=none guifg=none guibg=#103235]])
      vim.cmd([[highlight DiffChange gui=none guifg=none guibg=#272D43]])
      vim.cmd([[highlight DiffText gui=none guifg=none guibg=#394b70]])
      vim.cmd([[highlight DiffviewDiffAddAsDelete gui=none guifg=none guibg=#3F2D3D]])
      vim.cmd([[highlight DiffviewDiffDelete gui=none guifg=#3B4252 guibg=none]])
      vim.cmd([[highlight DiffDelete gui=none guifg=#21252A guibg=#1A1D21]])
    end
  }

  -- file tree
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
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
end)
