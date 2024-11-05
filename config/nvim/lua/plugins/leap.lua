local nxmap = require("my.map").nxmap

return {
  "ggandor/leap.nvim",
  dependencies = {
    { "ggandor/flit.nvim" },
  },
  config = function()
    require("flit").setup({
      keys = { f = "f", F = "F", t = "t", T = "T" },
      labeled_modes = "",
      multiline = false,
    })

    nxmap("S", function()
      require("leap").leap({ target_windows = { vim.fn.win_getid() } })
    end)
  end,
}
