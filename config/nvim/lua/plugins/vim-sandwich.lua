local map = require("my.map").map
local omap = require("my.map").omap
local nmap = require("my.map").nmap
local xmap = require("my.map").xmap

return {
  "machakann/vim-sandwich",
  config = function()
    -- vim.fn["operator#sandwich#set"]("add", "all", "highlight", 10)
    -- vim.fn["operator#sandwich#set"]("delete", "all", "highlight", 10)
    -- vim.fn["operator#sandwich#set"]("add", "all", "hi_duration", 10)
    -- vim.fn["operator#sandwich#set"]("delete", "all", "hi_duration", 10)

    xmap("sd", "<Plug>(operator-sandwich-delete)")
    xmap("sr", "<Plug>(operator-sandwich-replace)")
    nmap("sa", "<Plug>(operator-sandwich-add)iw")
    xmap("sa", "<Plug>(operator-sandwich-add)")
    map("sA", "<Plug>(operator-sandwich-add)")

    nmap("sd", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
    nmap("sr", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")

    omap("iq", "<Plug>(textobj-sandwich-auto-i)")
    xmap("iq", "<Plug>(textobj-sandwich-auto-i)")
    omap("aq", "<Plug>(textobj-sandwich-auto-a)")
    map("aq", "<Plug>(textobj-sandwich-auto-a)")
  end,
}
