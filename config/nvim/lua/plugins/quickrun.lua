local nmap = require("my.map").nmap
local xmap = require("my.map").xmap

return {
  "thinca/vim-quickrun",
  dependencies = {
    { "lambdalisue/vim-quickrun-neovim-job" },
  },
  config = function()
    vim.g.quickrun_config = {
      ["_"] = {
        outputter = "error",
        runner = "neovim_job",
        ["outputter/error/success"] = "buffer",
        ["outputter/error/error"] = "buffer",
        ["outputter/buffer/opener"] = ":botright 15split",
        ["outputter/buffer/close_on_empty"] = 1,
      },
      ["typescript"] = {
        command = "./node_modules/.bin/tsc",
        cmdopt = "--no-check --allow-all --unstable",
        tempfile = "%{tempname()}.ts",
        exec = { "%c", "node dist/%s:t:r.js" },
      },
      ["c"] = {
        type = vim.fn.executable("gcc") and "c/clang" or "c/gcc",
      },
      ["c/clang"] = {
        command = "clang",
        exec = { "%c %o %s -ledit -o %s:p:r", "%s:p:r %a" },
      },
      ["lua"] = {
        command = "nvim",
        exec = [[%c --clean --headless -c 'source %s' -c 'cquit 0']],
      },
    }

    nmap("<Leader>R", ":QuickRun")
    xmap("<Leader>R", ":QuickRun")
  end,
}
