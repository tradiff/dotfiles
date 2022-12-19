-- convert ruby hash rockets to symbol hashes in the visual selection
-- unescaped regex:
-- :(\w+)\s*=>\s*
vim.api.nvim_create_user_command('HashConvert', '%s/\\%V:\\(\\w\\+\\)\\s*=>\\s*/\\1: /g', { range = true })
