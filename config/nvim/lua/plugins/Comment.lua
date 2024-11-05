local nmap = require("my.map").nmap
local xmap = require("my.map").xmap

return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      mappings = {
        basic = false,
        extra = false,
      },
    })

    nmap("<Space>/", "<Plug>(comment_toggle_linewise_current)")
    xmap("<Space>/", "<Plug>(comment_toggle_linewise_visual)")
  end,
}
