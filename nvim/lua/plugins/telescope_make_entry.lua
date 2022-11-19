-- mostly copied from https://github.com/nvim-telescope/telescope.nvim/blob/9cf465894a61b840f6ab9e757223d21b8005cff9/lua/telescope/make_entry.lua
-- with changes to allow highlighting based on file path

local utils = require 'telescope.utils'
local Path = require 'plenary.path'

local display_highlighter = function(display, icon_hl_group, opts, entry)
  local result_highlights = {}
  if icon_hl_group then
    table.insert(result_highlights, { { 1, 3 }, icon_hl_group })
  end

  if opts.highlights then
    for _, highlight in ipairs(opts.highlights) do
      if string.match(entry.filename, highlight[1]) then
        table.insert(result_highlights, { { 0, 99 }, highlight[2] })
      end
    end
  end

  return display, result_highlights
end

local handle_entry_index = function(opts, t, k)
  local override = ((opts or {}).entry_index or {})[k]
  if not override then
    return
  end

  local val, save = override(t, opts)
  if save then
    rawset(t, k, val)
  end
  return val
end

local make_entry = {}

make_entry.set_default_entry_mt = function(tbl, opts)
  return setmetatable({}, {
    __index = function(t, k)
      local override = handle_entry_index(opts, t, k)
      if override then
        return override
      end

      -- Only hit tbl once
      local val = tbl[k]
      if val then
        rawset(t, k, val)
      end

      return val
    end,
  })
end

do
  local lookup_keys = {
    ordinal = 1,
    value = 1,
    filename = 1,
    cwd = 2,
  }

  function make_entry.gen_from_file(opts)
    opts = opts or {}

    local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

    local disable_devicons = opts.disable_devicons

    local mt_file_entry = {}

    mt_file_entry.cwd = cwd
    mt_file_entry.display = function(entry)
      local hl_group
      local display = utils.transform_path(opts, entry.value)

      display, hl_group = utils.transform_devicons(entry.value, display, disable_devicons)
      return display_highlighter(display, hl_group, opts, entry)
    end

    mt_file_entry.__index = function(t, k)
      local override = handle_entry_index(opts, t, k)
      if override then
        return override
      end

      local raw = rawget(mt_file_entry, k)
      if raw then
        return raw
      end

      if k == 'path' then
        local retpath = Path:new({ t.cwd, t.value }):absolute()
        if not vim.loop.fs_access(retpath, 'R', nil) then
          retpath = t.value
        end
        return retpath
      end

      return rawget(t, rawget(lookup_keys, k))
    end

    return function(line)
      return setmetatable({ line }, mt_file_entry)
    end
  end
end

do
  local lookup_keys = {
    value = 1,
    ordinal = 1,
  }

  -- Gets called only once to parse everything out for the vimgrep, after that looks up directly.
  local parse_with_col = function(t)
    local _, _, filename, lnum, col, text = string.find(t.value, [[(..-):(%d+):(%d+):(.*)]])

    local ok
    ok, lnum = pcall(tonumber, lnum)
    if not ok then
      lnum = nil
    end

    ok, col = pcall(tonumber, col)
    if not ok then
      col = nil
    end

    t.filename = filename
    t.lnum = lnum
    t.col = col
    t.text = text

    return { filename, lnum, col, text }
  end

  local parse_without_col = function(t)
    local _, _, filename, lnum, text = string.find(t.value, [[(..-):(%d+):(.*)]])

    local ok
    ok, lnum = pcall(tonumber, lnum)
    if not ok then
      lnum = nil
    end

    t.filename = filename
    t.lnum = lnum
    t.col = nil
    t.text = text

    return { filename, lnum, nil, text }
  end

  local parse_only_filename = function(t)
    t.filename = t.value
    t.lnum = nil
    t.col = nil
    t.text = ''

    return { t.filename, nil, nil, '' }
  end

  function make_entry.gen_from_vimgrep(opts)
    opts = opts or {}

    local mt_vimgrep_entry
    local parse = parse_with_col
    if opts.__matches == true then
      parse = parse_only_filename
    elseif opts.__inverted == true then
      parse = parse_without_col
    end

    local disable_devicons = opts.disable_devicons
    local disable_coordinates = opts.disable_coordinates
    local only_sort_text = opts.only_sort_text

    local execute_keys = {
      path = function(t)
        if Path:new(t.filename):is_absolute() then
          return t.filename, false
        else
          return Path:new({ t.cwd, t.filename }):absolute(), false
        end
      end,

      filename = function(t)
        return parse(t)[1], true
      end,

      lnum = function(t)
        return parse(t)[2], true
      end,

      col = function(t)
        return parse(t)[3], true
      end,

      text = function(t)
        return parse(t)[4], true
      end,
    }

    -- For text search only, the ordinal value is actually the text.
    if only_sort_text then
      execute_keys.ordinal = function(t)
        return t.text
      end
    end

    local display_string = '%s%s%s'

    mt_vimgrep_entry = {
      cwd = vim.fn.expand(opts.cwd or vim.loop.cwd()),

      display = function(entry)
        local display_filename = utils.transform_path(opts, entry.filename)

        local coordinates = ''
        if not disable_coordinates then
          if entry.lnum then
            if entry.col then
              coordinates = string.format(':%s:%s:', entry.lnum, entry.col)
            else
              coordinates = string.format(':%s:', entry.lnum)
            end
          end
        end

        local display, hl_group = utils.transform_devicons(
          entry.filename,
          string.format(display_string, display_filename, coordinates, entry.text),
          disable_devicons
        )

        return display_highlighter(display, hl_group, opts, entry)
      end,

      __index = function(t, k)
        local override = handle_entry_index(opts, t, k)
        if override then
          return override
        end

        local raw = rawget(mt_vimgrep_entry, k)
        if raw then
          return raw
        end

        local executor = rawget(execute_keys, k)
        if executor then
          local val, save = executor(t)
          if save then
            rawset(t, k, val)
          end
          return val
        end

        return rawget(t, rawget(lookup_keys, k))
      end,
    }

    return function(line)
      return setmetatable({ line }, mt_vimgrep_entry)
    end
  end
end

return make_entry
