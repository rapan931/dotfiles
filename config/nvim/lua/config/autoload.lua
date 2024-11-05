-- autocmd
local autocmd = vim.api.nvim_create_autocmd
local vimrc_augroup = vim.api.nvim_create_augroup("vimrc_augroup", {})

autocmd("ColorScheme", {
  group = vimrc_augroup,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "MyFlash", { bg = "Purple", fg = "White" })
    vim.api.nvim_set_hl(0, "MyWindowFlash", { bg = "LightYellow", fg = "DarkGray" })
  end,
})

autocmd("QuickfixCmdPost", {
  group = vimrc_augroup,
  pattern = { "grep", "vimgrep", "helpgrep" },
  nested = true,
  command = "botright copen",
})

autocmd("TermOpen", {
  group = vimrc_augroup,
  pattern = "*",
  command = "startinsert",
})

autocmd("InsertLeave", {
  group = vimrc_augroup,
  pattern = "*",
  command = "call system('zenhan.exe 0')",
})

autocmd("InsertLeave", {
  group = vimrc_augroup,
  pattern = "*",
  command = "echomsg 'hogehoge'",
})

autocmd("CmdlineLeave", {
  group = vimrc_augroup,
  pattern = "*",
  command = "call system('zenhan.exe 0')",
})

autocmd("FocusGained", {
  group = vimrc_augroup,
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      local win_id = vim.fn.win_getid()
      local match_id = vim.fn.matchadd(
        "MyWindowFlash",
        [[\%>]] .. (vim.fn.line("w0") - 1) .. [[l\_.*\%<]] .. (vim.fn.line("w$") + 1) .. "l",
        100,
        -1,
        { window = win_id }
      )
      vim.defer_fn(function()
        if #vim.fn.getwininfo(win_id) ~= 0 then
          vim.fn.matchdelete(match_id, win_id)
          vim.cmd("redraw")
        end
      end, 300)
    end, 30)
  end,
})

autocmd("BufEnter", {
  group = vimrc_augroup,
  pattern = "*",
  callback = function()
    local t = vim.bo.buftype
    if t == "terminal" or t == "prompt" or t == "quickfix" then
      return
    end
    local root_dir = require("my").get_root_dir()
    if root_dir ~= nil and #root_dir ~= 0 then
      -- vim.bo.path = '.,,' .. root_dir .. '/**'
      vim.cmd("lcd " .. root_dir)
    end
  end,
})

-- autocmd("FileType", {
--   group = vimrc_augroup,
--   pattern = "*",
--   callback = function(args)
--     require("my.filetype")[args.match]()
--   end,
-- })
--
-- autocmd("TextYankPost", {
--   group = vimrc_augroup,
--   pattern = "*",
--   callback = function()
--     vim.highlight.on_yank({
--       higroup = "MyFlash",
--       timeout = 400,
--       on_visual = true,
--     })
--   end,
-- })

print('hogehoge')
