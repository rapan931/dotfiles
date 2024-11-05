vim.opt.undofile = true
vim.opt.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo/"

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.hidden = false

vim.opt.undofile = true
vim.opt.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo/"

vim.opt.directory = vim.env.XDG_STATE_HOME .. "/nvim/swap/"
vim.opt.swapfile = true

vim.opt.cursorline = true

vim.opt.signcolumn = "yes"

vim.opt.shortmess = "filmnrwxtToOISs"

vim.opt.title = true
vim.opt.cmdheight = 2
vim.opt.showcmd = true

vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.equalalways = true
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = {
  tab = ">--",
}

vim.opt.sidescroll = 3

vim.opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true

vim.opt.spelllang = { "en", "cjk" }

vim.opt.formatoptions = "tcroqmMj"

vim.opt.fixendofline = false

vim.opt.mouse = "nv"

vim.opt.fileencoding = "utf-8"

if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
end

vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}
vim.opt.clipboard = "unnamed"

vim.opt.termguicolors = true

print("loaded option.lua")
print("loaded option.lua")
