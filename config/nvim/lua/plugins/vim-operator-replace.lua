local smap = require("my.map").smap
local nmap = require("my.map").nmap
local xmap = require("my.map").xmap

return {
  "kana/vim-operator-replace",
  dependencies = { "kana/vim-operator-user" },
  config = function()
    nmap("<Leader>r", "<Plug>(operator-replace)")
    xmap("<Leader>r", "<Plug>(operator-replace)")
    smap("<Leader>r", "<Plug>(operator-replace)")
  end,
}
