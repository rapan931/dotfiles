local my_map = require("my.map")
local map = my_map.map
local xmap = my_map.xmap
local nmap = my_map.nmap
local imap = my_map.imap
local cmap = my_map.cmap
-- local omap = my_map.omap
-- local smap = my_map.smap
local tmap = my_map.tmap
local nxmap = my_map.nxmap

-- mapping
-- nxmap("z/", function() require("reacher").start() end)
-- nxmap("S", function() require("leap").leap({ target_windows = { fn.win_getid() } }) end)

-- nmap("<Space>ee", "<CMD>Neotree toggle<CR>")
-- nmap("<Space>er", "<CMD>Neotree ./<CR>")
-- nmap("<Space>ef", "<CMD>Neotree ./ reveal_force_cwd<CR>")
-- nmap("<Space>ep", "<CMD>Neotree " .. vim.fn.stdpath("data") .. "/lazy<CR>")
-- nmap("<Space>eh", "<CMD>Neotree ~<CR>")
-- nmap("<Space>ev", "<CMD>Neotree /usr/local/src/neovim<CR>")
-- nmap("<Space>eV", "<CMD>Neotree $VIMRUNTIME<CR>")
-- nmap("<Space>ed", "<CMD>Neotree ~/repos/github.com/rapan931/dotfiles<CR>")

nmap("<Space>.", [[<CMD>e $MYVIMRC<CR>]])

-- map("n", function() require("bistahieversor").n_and_echo() end)
-- map("N", function() require("bistahieversor").N_and_echo() end)
-- map("<C-n>", function()
--   require("bistahieversor").n_and_echo()
--   cmd("normal! zz")
-- end)
--
-- map("*", function()
--   require("lasterisk").search()
--   require("bistahieversor").echo()
-- end)
--
-- xmap("*", function()
--   require("lasterisk").search({ is_whole = false, silent = true })
--   require("bistahieversor").echo()
-- end)
--
-- map("g*", function()
--   require("lasterisk").search({ is_whole = false, silent = true })
--   require("bistahieversor").echo()
-- end)
--
-- my_map.nmap("<Leader>*", function()
--   cmd("normal! g_v_")
--   require("lasterisk").search({ is_whole = false, silent = true })
--   require("bistahieversor").echo()
-- end)
--
-- nmap("g/", function()
--   local pattern = [[\V]] .. fn.join(vim.tbl_map(function(line) return fn.escape(line, [[/\]]) end, fn.getreg(vim.v.register, 1, 1)), [[\n]])
--   vim.opt.hlsearch = vim.opt.hlsearch
--   fn.setreg("/", pattern)
--   fn.histadd("/", pattern)
--   require("bistahieversor").n_and_echo()
-- end)
--
-- omap("ai", "<Plug>(textobj-indent-a)")
-- xmap("ai", "<Plug>(textobj-indent-a)")
-- omap("ii", "<Plug>(textobj-indent-a)")
-- xmap("ii", "<Plug>(textobj-indent-a)")

cmap("<C-e>", "<End>")
imap("<C-e>", "<End>")
cmap("<C-a>", "<Home>")
imap("<C-a>", "<Home>")
cmap("<C-f>", "<Right>")
imap("<C-f>", "<Right>")
cmap("<C-b>", "<Left>")
imap("<C-b>", "<Left>")

nmap("gs", ":<C-u>%s///g<Left><Left>")
xmap("gs", ":s///g<Left><Left>")

nmap("gc", ":<C-u>vimgrep //j %<Left><Left><Left><Left>")

xmap("v", "$h")

xmap("<ESC>", "o<ESC>")
nmap("gv", "gvo")

nmap("<Space>.", [[<CMD>e $MYVIMRC<CR>]])

nxmap("j", "gj")
nxmap("k", "gk")

nmap("yie", [[<cmd>%y<cr>]])
nmap("die", "ggdG")
nmap("cie", "ggcG")
nmap("vie", "ggVG")

map(";", ":")
map(":", ";")

nmap("gF", "<Cmd>vertical botright wincmd F<CR>")

-- nxmap("<C-j>", "<Plug>(edgemotion-j)")
-- nxmap("<C-k>", "<Plug>(edgemotion-k)")

-- nxmap("<Leader>ob", "<Plug>(openbrowser-smart-search)")
-- nxmap("<Leader>og", "<CMD>OpenGithubProject<CR>")
--
-- nmap("<Leader>og", "<CMD>OpenBrowse rhttps://github.com/<C-r>=expand('<cfile>')<CR><CR>")
-- xmap("<Leader>og", "<CMD>OpenBrowse rhttps://github.com/<C-r>=luaeval(My.selected_text)<CR><CR>")

nmap("<F4>", "<CMD>set wrap!<CR>")

nmap("<Leader>qw", "<CMD>windo diffthis<CR>")
nmap("<Leader>qo", "<CMD>windo diffoff<CR>")
nmap("<Leader>qu", "<CMD>diffupdate<CR>")

nmap("2o", "jo")

-- nxmap("<Space>m", "<Plug>(quickhl-manual-this)")
-- nxmap("<Space>M", "<Plug>(quickhl-manual-reset)")

-- imap("<C-s>", function() return call("vsnip#expandable") and "<Plug>(vsnip-expand)" or "<C-s>" end, { expr = true })
-- smap("<C-s>", function() return call("vsnip#expandable") and "<Plug>(vsnip-expand)" or "<C-s>" end, { expr = true })
--
-- imap("<C-k>", function() return call("vsnip#available") and "<Plug>(vsnip-expand-or-jump)" or "<C-k>" end, { expr = true })
-- smap("<C-k>", function() return call("vsnip#available") and "<Plug>(vsnip-expand-or-jump)" or "<C-k>" end, { expr = true })

-- nmap("<Leader>r", "<Plug>(operator-replace)")
-- xmap("<Leader>r", "<Plug>(operator-replace)")
-- smap("<Leader>r", "<Plug>(operator-replace)")

nmap("dk", function()
  return vim.fn.line(".") == vim.fn.line("$") and "dk" or "dkk"
end, { expr = true })

-- nmap("+", require("dial.map").inc_normal())
-- xmap("+", require("dial.map").inc_visual())
-- nmap("-", require("dial.map").dec_normal())
-- xmap("-", require("dial.map").dec_visual())

-- CR付けない
-- nmap("<Leader>R", ":QuickRun")
-- xmap("<Leader>R", ":QuickRun")

tmap("<A-n>", [[<C-\><C-n>]])

tmap("<A-h>", [[<C-\><C-n><C-w>h]])
tmap("<A-l>", [[<C-\><C-n><C-w>l]])
tmap("<A-j>", [[<C-\><C-n><C-w>j]])
tmap("<A-k>", [[<C-\><C-n><C-w>k]])
nmap("<A-h>", [[<C-w>h]])
nmap("<A-l>", [[<C-w>l]])
nmap("<A-j>", [[<C-w>j]])
nmap("<A-k>", [[<C-w>k]])

-- タイプミスでWindowを閉じる子と何度かあったのでNop
nmap("<C-w><C-q>", [[<Nop>]])

-- vim.fn["operator#sandwich#set"]("add", "all", "highlight", 10)
-- vim.fn["operator#sandwich#set"]("delete", "all", "highlight", 10)
-- vim.fn["operator#sandwich#set"]("add", "all", "hi_duration", 10)
-- vim.fn["operator#sandwich#set"]("delete", "all", "hi_duration", 10)

-- xmap("sd", "<Plug>(operator-sandwich-delete)")
-- xmap("sr", "<Plug>(operator-sandwich-replace)")
-- nmap("sa", "<Plug>(operator-sandwich-add)iw")
-- xmap("sa", "<Plug>(operator-sandwich-add)")
-- map("sA", "<Plug>(operator-sandwich-add)")
--
-- nmap("sd", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
-- nmap("sr", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
--
-- omap("iq", "<Plug>(textobj-sandwich-auto-i)")
-- xmap("iq", "<Plug>(textobj-sandwich-auto-i)")
-- omap("aq", "<Plug>(textobj-sandwich-auto-a)")
-- xmap("aq", "<Plug>(textobj-sandwich-auto-a)")

-- nmap("<Space>/", "<Plug>(comment_toggle_linewise_current)")
-- xmap("<Space>/", "<Plug>(comment_toggle_linewise_visual)")

-- for atcode
nmap("ZZ", function()
  local file_path = "/home/rapan931/repos/github.com/rapan931/atcoder/input"
  if vim.fn.filereadable(file_path) == 0 then
    return
  end

  vim.fn.writefile(vim.fn.getreg(vim.v.register, 1, 1), file_path)

  local name = vim.fn.bufname(file_path)
  if #name == 0 then
    return
  end

  local bufinfo = vim.fn.getbufinfo(name)
  if #bufinfo == 0 then
    return
  end

  for _, list in pairs(bufinfo) do
    for _, winid in pairs(list["windows"]) do
      vim.fn.win_execute(winid, "e!")
    end
  end
end)

nmap("ZQ", function()
  vim.cmd("only")
  vim.cmd("e /home/rapan931/repos/github.com/rapan931/atcoder/main.go")
  vim.cmd("vsp input")
  vim.cmd("sp output")
  vim.cmd("sp")
  vim.cmd("terminal")
end)

nmap("<Space><Space>e", vim.diagnostic.open_float)
nmap("g[", vim.diagnostic.goto_prev)
nmap("g]", vim.diagnostic.goto_next)
nmap("<Space><Space>l", vim.diagnostic.setloclist)
