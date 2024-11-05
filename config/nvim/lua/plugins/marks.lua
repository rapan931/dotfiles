return {
  "rapan931/marks.nvim",
  branch = "feat-linehl",
  config = function()
    vim.api.nvim_set_hl(0, "MarkSignLineHL", { link = "Underlined" })
    require("marks").setup({
      force_write_shada = true,
      default_mappings = false,
      refresh_interval = 1000,
      mappings = {
        toggle = "m.",
        prev = "mk",
        next = "mj",
        delete_buf = "m<Space>",
        preview = "m/",
        set_bookmark0 = "m0",
      },
    })
  end,
}
