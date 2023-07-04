-- convert ruby hash rockets to symbol hashes in the visual selection
-- unescaped regex:
-- :(\w+)\s*=>\s*
vim.api.nvim_create_user_command('HashConvert', '%s/\\%V:\\(\\w\\+\\)\\s*=>\\s*/\\1: /g', { range = true })

-- convert ruby symbol hashes to string hash rockets in the visual selection
-- unescaped regex:
-- (\w+): \s*
vim.api.nvim_create_user_command('HashConvertString', '%s/\\%V\\(\\w\\+\\): \\s*/"\\1" => /g', { range = true })

function MigrationBump()
  local current_filepath = vim.fn.expand('%')
  local current_dir = vim.fn.expand('%:p:h')
  local current_filename = vim.fn.fnamemodify(current_filepath, ':t')
  local new_filename = os.date('!%Y%m%d%H%M%S') .. string.sub(current_filename, 15)
  local new_filepath = current_dir .. '/' .. new_filename

  print('Renaming:')
  print(current_filename)
  print('to:')
  print(new_filename)

  local confirm = vim.fn.input('Are you sure you want to continue? (y/n) ')
  print(' ')

  if confirm == 'y' then
    -- Rename file
    vim.fn.rename(current_filepath, new_filepath)
    print('File renamed!')

    -- Update the buffer's filename
    local bufnr = vim.fn.bufnr('%')
    vim.api.nvim_buf_set_name(bufnr, new_filepath)
  else
    -- User cancelled, do nothing
    print('Function cancelled.')
  end
end

-- Rename the Rails migration in the current buffer to use today's timestamp
-- so that it's the last one.
vim.api.nvim_create_user_command('MigrationBump', 'lua MigrationBump()', {})
