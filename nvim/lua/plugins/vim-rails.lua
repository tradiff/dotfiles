-- alternate files, among other things
return {
  'tpope/vim-rails',
  config = function()
    -- alternate file
    -- create the file if it's missing
    vim.keymap.set('n', '<leader>a', ':execute "e " . eval("rails#buffer().alternate()")<cr>', { noremap = true })

    vim.g.rails_projections = {
          ['app/controllers/*_controller.rb'] = {
            ['test'] = {
          'spec/requests/{}_spec.rb',
          'spec/controllers/{}_controller_spec.rb',
          'test/controllers/{}_controller_test.rb'
        },
            ['alternate'] = {
          'spec/requests/{}_spec.rb',
          'spec/controllers/{}_controller_spec.rb',
          'test/controllers/{}_controller_test.rb'
        },
      },
          ['spec/requests/*_spec.rb'] = {
            ['command'] = 'request',
            ['alternate'] = 'app/controllers/{}_controller.rb',
      },
    }
  end
}
