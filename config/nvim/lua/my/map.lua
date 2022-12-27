local M = {}

local function handle_opt(...)
  local args = { ... }
  if #args == 0 or type(args[1]) ~= "table" then
    return {}
  end

  return args[1]
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.nmap = function(lhs, rhs, ...)
  vim.keymap.set("n", lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.omap = function(lhs, rhs, ...)
  vim.keymap.set("o", lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.xmap = function(lhs, rhs, ...)
  vim.keymap.set("x", lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.imap = function(lhs, rhs, ...)
  vim.keymap.set("i", lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.cmap = function(lhs, rhs, ...)
  vim.keymap.set("c", lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.map = function(lhs, rhs, ...)
  vim.keymap.set({ "n", "x", "o" }, lhs, rhs, ...)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.buf_nmap = function(lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend("force", { buffer = true }, handle_opt(...))
  M.nmap(lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.buf_omap = function(lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend("force", { buffer = true }, handle_opt(...))
  M.omap(lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.buf_xmap = function(lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend("force", { buffer = true }, handle_opt(...))
  M.xmap(lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.buf_imap = function(lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend("force", { buffer = true }, handle_opt(...))
  M.imap(lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.buf_cmap = function(lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend("force", { buffer = true }, handle_opt(...))
  M.cmap(lhs, rhs, merged_opt)
end

---@param lhs string
---@param rhs string | function
---@param ... table options
M.buf_map = function(lhs, rhs, ...)
  local merged_opt = vim.tbl_deep_extend("force", { buffer = true }, handle_opt(...))
  M.map(lhs, rhs, merged_opt)
end

return M
