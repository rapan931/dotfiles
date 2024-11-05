return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      -- default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal,
        augend.constant.new({ elements = { "true", "false" }, preserve_case = true }),
        augend.constant.new({ elements = { "Yes", "No" }, preserve_case = true }),
        -- augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = false }),
        augend.constant.new({ elements = { "==", "!=" }, word = false }),
        augend.constant.new({ elements = { "&&", "||" }, word = false }),
        augend.constant.new({ elements = { "and", "or" }, preserve_case = true }),
        augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
        augend.constant.new({ elements = { "on", "off" }, preserve_case = true }),
        augend.constant.new({ elements = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }, preserve_case = true }),
        augend.constant.new({
          elements = { "Jan", "Feb", "Apr", "Mar", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" },
          preserve_case = true,
        }),
        augend.integer.alias.hex,
        augend.integer.alias.binary,
      },
    })
  end,
}
