local nxmap = require("my.map").nxmap
local nmap = require("my.map").nmap
local xmap = require("my.map").xmap

return {
  "tyru/open-browser.vim",
  dependencies = { "tyru/open-browser-github.vim" },
  config = function()
    nxmap("<Leader>ob", "<Plug>(openbrowser-smart-search)")
    nxmap("<Leader>og", "<CMD>OpenGithubProject<CR>")

    nmap("<Leader>og", "<CMD>OpenBrowse https://github.com/<C-r>=expand('<cfile>')<CR><CR>")
    xmap("<Leader>og", "<CMD>OpenBrowse https://github.com/<C-r>=luaeval(require('my').selected_text)<CR><CR>")
  end,
}
