local M = {}

---@param lhs string
---@param rhs string | function
---@param ... table options
M.nnoremap = function (lhs, rhs, ...)
  vim.keymap.set('n', lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.onoremap = function (lhs, rhs, ...)
  vim.keymap.set('o', lhs, rhs, ...)
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
return M
