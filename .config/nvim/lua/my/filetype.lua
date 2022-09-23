local M = {}
local bm = vim.api.nvim_buf_set_keymap
local noremap = { noremap = true }
local lopt = vim.opt_local

---@param tab_length number
---@param is_hard_tab boolean
local function set_indent(tab_length, is_hard_tab)
  if is_hard_tab then
    lopt.expandtab = false
  else
    lopt.expandtab = true
  end

  lopt.shiftwidth  = tab_length
  lopt.softtabstop = tab_length
  lopt.tabstop     = tab_length
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
