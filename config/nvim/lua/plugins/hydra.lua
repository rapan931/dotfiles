return {
  "anuvyklack/hydra.nvim",
  config = function()
    local hydra = require("hydra")
    hydra({
      name = "window",
      mode = { "i", "t", "n" },
      body = [[<C-\>]],
      heads = {
        {
          ">",
          function()
            require("my").all_mode_wincmd(">")
          end,
        },
        {
          "<",
          function()
            require("my").all_mode_wincmd("<")
          end,
        },
        {
          "+",
          function()
            require("my").all_mode_wincmd("+")
          end,
        },
        {
          "-",
          function()
            require("my").all_mode_wincmd("-")
          end,
        },
        {
          "H",
          function()
            require("my").all_mode_wincmd("H")
          end,
        },
        {
          "J",
          function()
            require("my").all_mode_wincmd("J")
          end,
        },
        {
          "K",
          function()
            require("my").all_mode_wincmd("K")
          end,
        },
        {
          "L",
          function()
            require("my").all_mode_wincmd("L")
          end,
        },
        {
          "<c-h>",
          function()
            require("my").all_mode_wincmd("h")
          end,
        },
        {
          "<c-j>",
          function()
            require("my").all_mode_wincmd("j")
          end,
        },
        {
          "<c-k>",
          function()
            require("my").all_mode_wincmd("k")
          end,
        },
        {
          "<c-l>",
          function()
            require("my").all_mode_wincmd("l")
          end,
        },
      },
    })

    hydra({
      name = "quickfix/locationlist",
      mode = "n",
      body = "g",
      heads = {
        { "l", "<cmd>cnext<cr>" },
        { "h", "<cmd>cprev<cr>" },
        { "L", "<cmd>lnext<cr>" },
        { "H", "<cmd>lprev<cr>" },
      },
    })

    hydra({
      name = "go to older/newer position in change list",
      mode = "n",
      body = "g",
      heads = {
        { ";", "g;" },
        { ",", "g," },
      },
    })
  end,
}
