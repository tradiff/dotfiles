-- opts can be:
--  a table (used as is)
--  nil (use default opts)
--  a string (assumed to be description and merged with default opts)
local function map(mode, lhs, rhs, opts)
  if type(opts) == "string" then
    opts = { noremap = true, silent = true, desc = opts, }
  else
    opts = opts or { noremap = true, silent = true, }
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

return map
