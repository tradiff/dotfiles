-- Truncate LSP log file on startup
local log_path = vim.lsp.get_log_path()
local f = io.open(log_path, "w")
if f then
  f:close()
else
  vim.notify("Could not truncate LSP log file at " .. log_path, vim.log.levels.ERROR)
end
