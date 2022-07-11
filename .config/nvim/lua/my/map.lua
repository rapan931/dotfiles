local M = {}

local function handle_args(...)
  local args = {...}
  if #args == 0 then
    return {}
  end

  return args[1]
end

M.nnoremap = function (lhs, rhs, ...)
  vim.keymap.set('n', lhs, rhs, ...)
end

M.xnoremap = function (lhs, rhs, ...)
  vim.keymap.set('x', lhs, rhs, ...)
end

M.inoremap = function (lhs, rhs, ...)
  vim.keymap.set('i', lhs, rhs, ...)
end

M.cnoremap = function (lhs, rhs, ...)
  vim.keymap.set('c', lhs, rhs, ...)
end

M.nmap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('n', lhs, rhs, merged_opt)
end

M.xmap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('x', lhs, rhs, merged_opt)
end

M.imap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('i', lhs, rhs, merged_opt)
end

M.cmap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('c', lhs, rhs, merged_opt)
end

return M
