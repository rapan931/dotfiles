local lazypath = vim.fn.stdpath("data") .. "/lazy-test/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  import = "plugins",
  root = vim.fn.stdpath("data") .. "/lazy-test",
  lockfile = vim.fn.stdpath("config") .. "/lazy-test-lock.json",
  install = {
    missing = true,
    colorscheme = { "tokyonight" },
  },
  readme = {
    enabled = true,
    root = vim.fn.stdpath("state") .. "/lazy-test/readme",
    files = { "README.md", "lua/**/README.md" },
    -- only generate markdown helptags for plugins that dont have docs
    skip_if_doc_exists = true,
  },
  state = vim.fn.stdpath("state") .. "/lazy-test/state.json",
})

print("loaded lazy.lua")
print("loaded lazy.lua")
