local M = {}

local function handle_args(...)
  local args = {...}
  if #args == 0 then
    return {}
  end

  return args[1]
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.nnoremap = function (lhs, rhs, ...)
  vim.keymap.set('n', lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.xnoremap = function (lhs, rhs, ...)
  vim.keymap.set('x', lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.inoremap = function (lhs, rhs, ...)
  vim.keymap.set('i', lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.cnoremap = function (lhs, rhs, ...)
  vim.keymap.set('c', lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.noremap = function (lhs, rhs, ...)
  vim.keymap.set({'n', 'x', 'o'}, lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.nmap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('n', lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.xmap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('x', lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.imap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('i', lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.cmap = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set('c', lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.map = function (lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend('force', { remap = true }, handle_args(...))
  vim.keymap.set({'n', 'x', 'o'}, lhs, rhs, merged_opt)
end

return M
