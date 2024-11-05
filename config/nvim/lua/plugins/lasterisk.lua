local map = require("my.map").map
local nmap = require("my.map").nmap
local xmap = require("my.map").xmap

return {
  "rapan931/lasterisk.nvim",
  dir = "~/repos/github.com/rapan931/lasterisk.nvim",
  dependencies = {
    { "rapan931/bistahieversor.nvim" },
  },
  config = function()
    map("*", function()
      require("lasterisk").search()
      require("bistahieversor").echo()
    end)

    xmap("*", function()
      require("lasterisk").search({ is_whole = false, silent = true })
      require("bistahieversor").echo()
    end)

    map("g*", function()
      require("lasterisk").search({ is_whole = false, silent = true })
      require("bistahieversor").echo()
    end)

    nmap("<Leader>*", function()
      vim.cmd("normal! g_v_")
      require("lasterisk").search({ is_whole = false, silent = true })
      require("bistahieversor").echo()
    end)
  end,
}
