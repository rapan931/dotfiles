local M = {}
local buf_nmap = require("my.map").buf_nmap
local buf_imap = require("my.map").buf_imap
local opt = vim.opt_local

---@param tab_length number
---@param is_hard_tab boolean
local function set_indent(tab_length, is_hard_tab)
  opt.expandtab = not is_hard_tab
  opt.shiftwidth = tab_length
  opt.softtabstop = tab_length
  opt.tabstop = tab_length
end

M.gitconfig = function() set_indent(2, true) end
M.quickrun = function() buf_nmap("q", "ZZ") end
M.make = function() set_indent(4, true) end
M.go = function() set_indent(4, true) end
M.help = function() buf_nmap("q", "ZZ") end
M.gitcommit = function() opt.spell = true end
M.qf = function() buf_nmap("q", "ZZ") end
M.java = function() set_indent(4, false) end
M.python = function() set_indent(4, false) end
M.sql = function() set_indent(2, false) end
M.markdown = function()
  buf_nmap("<Space><Space>f", function() vim.lsp.buf.format({ async = false, timeout_ms = 4000 }) end)
end
M.reacher = function()
  buf_nmap("<CR>", function() require("reacher").finish() end)
  buf_imap("<CR>", function() require("reacher").finish() end)
  buf_nmap("<ESC>", function() require("reacher").cancel() end)
  -- buf_imap("<ESC>", function() require("reacher").cancel() end)

  buf_nmap("gg", function() require("reacher").first() end)
  buf_nmap("G", function() require("reacher").last() end)
  buf_nmap("n", function() require("reacher").next() end)
  buf_nmap("N", function() require("reacher").previous() end)

  buf_imap("<Tab>", function() require("reacher").next() end)
  buf_imap("<S-Tab>", function() require("reacher").previous() end)
  buf_imap("<C-n>", function() require("reacher").forward_history() end)
  buf_imap("<C-p>", function() require("reacher").backward_history() end)
end

return setmetatable(M, {
  __index = function()
    return function() set_indent(2, false) end
  end,
})
