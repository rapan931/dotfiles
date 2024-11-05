local nxmap = require("my.map").nxmap
return {
  "notomo/reacher.nvim",
  config = function()
    nxmap("z/", function()
      require("reacher").start()
    end)
  end,
}
