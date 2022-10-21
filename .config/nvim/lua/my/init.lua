-- local filetype = require('filetype')

local M = {}
local fn = vim.fn

_G.pp = function(obj) vim.pretty_print(obj) end

---@return string
M.dump = function(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  return table.concat(objects, '    ')
end

M.get_root_dir = function()
  local target_dir = fn.expand("%:p:h") .. ";"
  local search_dirs = { ".git" }

  for _, dir in pairs(search_dirs) do
    local ret_dir = fn.finddir(dir, target_dir)
    if ret_dir ~= "" then
      return fn.fnamemodify(ret_dir, ":p:h:h")
    end
  end
  return ""
end

---@param cmd string wincmd
M.all_mode_wincmd = function(cmd)
  local mode = fn.mode()
  if mode == "n" then
    vim.cmd("wincmd " .. cmd)
  elseif mode == "t" or mode == "i" then
    vim.cmd("stopinsert")
    vim.cmd("wincmd " .. cmd)
  end
end

---@param obj any
M.echo_and_yank = function(obj)
  -- Since vim.inspect adds double quotation for string,
  if type(obj) == "string" then
    fn.setreg(vim.v.register, obj)
    print(obj)
  else
    fn.setreg(vim.v.register, vim.inspect(obj))
    print(vim.inspect(obj))
  end
end

M.plugin_paths = function()
  local start_paths = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/p/start/*", "", true)
  local opt_paths = vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/p/opt/*", "", true)
  return vim.tbl_map(function(path) return fn.resolve(path) end, vim.tbl_flatten({ start_paths, opt_paths }))
end

-- M.start_terminal = function()
--   local bufnr = util.api.nvim_create_buf()
--   util.api.nvim_resize_win()
--   util.api.nvim_open_term(bufnr)
-- end

return M
