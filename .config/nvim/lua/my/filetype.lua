local M = {}
local bm = vim.api.nvim_buf_set_keymap
local noremap = { noremap = true }

---@param tab_length number
---@param is_hard_tab boolean
local function set_indent(tab_length, is_hard_tab)
  if is_hard_tab then
    vim.bo.expandtab = false
  else
    vim.bo.expandtab = true
  end

  vim.bo.shiftwidth  = tab_length
  vim.bo.softtabstop = tab_length
  vim.bo.tabstop     = tab_length
end

M.gitconfig = function()
  set_indent(2, true)
end

M.make = function()
  set_indent(4, true)
end

M.help = function()
  bm(0, 'n', 'q', 'ZZ', noremap)
end

M.qf = function()
  bm(0, 'n', 'q', 'ZZ', noremap)
end

M.java = function()
  set_indent(4, false)
end

return setmetatable(M, {
  __index = function()
    return function()
      set_indent(2, false)
    end
  end
})
