local nxmap = require("my.map").nxmap

return {
  "t9md/vim-quickhl",
  config = function()
    nxmap("<Space>m", "<Plug>(quickhl-manual-this)")
    nxmap("<Space>M", "<Plug>(quickhl-manual-reset)")
  end,
}
