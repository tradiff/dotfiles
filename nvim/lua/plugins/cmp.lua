return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
  },
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')

    cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn['vsnip#anonymous'](args.body)
        end
      },
      mapping = {
            ['<Down>'] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Insert
        }),
            ['<Up>'] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Insert
        }),
            ['<Esc>'] = cmp.mapping.abort(),
        -- Space or CR only accepts if the user selected an option manually
            ['<Space>'] = cmp.mapping.confirm({
          select = false
        }),
            ['<CR>'] = cmp.mapping.confirm({
          select = false
        }),
        -- Tab will accept the first item even if the user didnt' select any options
            ['<Tab>'] = cmp.mapping.confirm({
          select = true
        }),
      },
      sources = cmp.config.sources({ {
        name = 'nvim_lsp'
      }, {
        name = 'vsnip'
      } }, { {
        name = 'buffer'
      } }),
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipse_char = '...'
        })
      }
    })
  end
}
