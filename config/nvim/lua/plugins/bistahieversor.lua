local map = require("my.map").map
local vimrc_augroup = vim.api.nvim_create_augroup("vimrc_augroup", { clear = false })
return {
  "rapan931/bistahieversor.nvim",
  dir = "~/repos/github.com/rapan931/bistahieversor.nvim",
  config = function()
    vim.api.nvim_create_autocmd("CmdlineLeave", {
      group = vimrc_augroup,
      pattern = { "/", "\\?" },
      callback = function()
        if vim.v.event.abort == false then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":lua require('bistahieversor').echo()<CR>", true, false, true), "n", false)
        end
      end,
    })
    require("bistahieversor").setup({ maxcount = 1000, echo_wrapscan = true })

    map("n", function()
      require("bistahieversor").n_and_echo()
    end)
    map("N", function()
      require("bistahieversor").N_and_echo()
    end)
    map("<C-n>", function()
      require("bistahieversor").n_and_echo()
      vim.cmd("normal! zz")
    end)
  end,
}
