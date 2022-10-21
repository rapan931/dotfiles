local M = {}
local buf_nmap = require('my.map').buf_nmap
local opt = vim.opt_local

---@param tab_length number
---@param is_hard_tab boolean
local function set_indent(tab_length, is_hard_tab)
  if is_hard_tab then
    opt.expandtab = false
  else
    opt.expandtab = true
  end

  opt.shiftwidth  = tab_length
  opt.softtabstop = tab_length
  opt.tabstop     = tab_length
end

M.gitconfig = function()
  set_indent(2, true)
end

M.make = function()
  set_indent(4, true)
end

M.help = function()
  buf_nmap('q', 'ZZ')
end

M.gitcommit = function()
  opt.spell = true
end

M.qf = function()
  buf_nmap('q', 'ZZ')
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
