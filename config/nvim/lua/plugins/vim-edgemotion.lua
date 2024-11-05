local nxmap = require("my.map").nxmap

return {
  "haya14busa/vim-edgemotion",
  config = function()
    nxmap("<C-j>", "<Plug>(edgemotion-j)")
    nxmap("<C-k>", "<Plug>(edgemotion-k)")
  end,
}
