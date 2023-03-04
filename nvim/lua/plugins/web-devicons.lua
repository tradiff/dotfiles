return {
  'nvim-tree/nvim-web-devicons',
  config = function()
    local devicons = require('nvim-web-devicons')

    local function get_ext(name)
      if name:find '^.+%.test%..+$' or name:find '^.+Test%..+$' or name:find '^.+_test%..+$' then
        return 'test'
      end

      if name:find '^.+%.spec%..+$' or name:find '^.+Spec%..+$' or name:find '^.+_spec%..+$' then
        return 'spec'
      end

      return name:match '^.*%.(.*)$' or ''
    end

    local get_icon = devicons.get_icon
    devicons.get_icon = function(name, ext, opts)
      return get_icon(name, get_ext(name), opts)
    end

    local get_icon_colors = devicons.get_icon_colors
    devicons.get_icon_colors = function(name, ext, opts)
      return get_icon_colors(name, get_ext(name), opts)
    end

    devicons.get_icon_by_filetype = function(ft, opts)
      -- Disable get_icon_by_filetype so that bufferline will fall through to
      -- get_icon. Because get_icon_by_filetype is only provided with the filetype
      -- (ex: "ruby"), not the filename, so we can't see if the filename contains
      -- "spec"
      return nil
    end

    devicons.setup {
      override = {
        rb = {
          icon = '',
          color = '#FF5874',
          cterm_color = '52',
          name = 'Rb'
        },
            ['test'] = { icon = '', color = '#22C7A8', name = 'TestFile' },
            ['spec'] = { icon = '', color = '#22C7A8', name = 'SpecFile' },
      },
    }
  end,
}
