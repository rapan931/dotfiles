My = require("my")

local api = vim.api
local fn = vim.fn

local opt = vim.opt
local cmd = vim.cmd

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

-- packer.nvim
opt.packpath = fn.stdpath("data") .. "/site/"
cmd.packadd("packer.nvim")
local packer = require("packer")
packer.init({ plugin_package = "p" })
packer.startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

  -- treesister
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/nvim-treesitter-textobjects")

  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.stylua,
        },
      })
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })

  use("nvim-lua/plenary.nvim")
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })
  use("nvim-telescope/telescope-file-browser.nvim")

  use("neovim/nvim-lspconfig")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")

  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-emoji")
  use("hrsh7th/cmp-nvim-lua")

  use("hrsh7th/cmp-vsnip")
  use("hrsh7th/vim-vsnip")

  use("folke/tokyonight.nvim")
  use("mjlbach/onedark.nvim")
  use("rebelot/kanagawa.nvim")
  use("ellisonleao/gruvbox.nvim")
  use("EdenEast/nightfox.nvim")
  use("cocopon/iceberg.vim")

  use("nvim-lualine/lualine.nvim")
  use({
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  })

  use("haya14busa/vim-asterisk")
  use("AndrewRadev/linediff.vim")
  use("tyru/open-browser.vim")
  use("tyru/open-browser-github.vim")
  use("klen/nvim-config-local")
  use("rhysd/committia.vim")
  use("hotwatermorning/auto-git-diff")

  use({ "machakann/vim-sandwich", opt = true })

  use({
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup({}) end,
  })

  use("anuvyklack/hydra.nvim")

  use("~/repos/github.com/rapan931/lasterisk.nvim")
  use("~/repos/github.com/rapan931/bistahieversor.nvim")
  use("~/repos/github.com/rapan931/utahraptor.nvim")
  use("~/repos/github.com/rapan931/binary_comments.vim")
end)

local my_filetype = require("my.filetype")
local bistahieversor = require("bistahieversor")
local lasterisk = require("lasterisk")
local utahraptor = require("utahraptor")
utahraptor.setup({
  flash_ms = 500,
  flash_hl_group = "MyFlash",
})

vim.g.mapleader = ","
local my_map = require("my.map")
-- local map = my_map.map
-- local xmap = my_map.xmap
-- local nmap = my_map.nmap
-- local imap = My.keymap.imap
-- local cmap = My.keymap.cmap
local noremap = my_map.noremap
local xnoremap = my_map.xnoremap
local nnoremap = my_map.nnoremap
local inoremap = my_map.inoremap
local cnoremap = my_map.cnoremap
local onoremap = my_map.onoremap

local binary_comments = require("binary_comments")
xnoremap("ge", binary_comments.draw)

vim.g.ruby_no_expensive = 1

if fn.has("vim_starting") then
  -- opt.viminfo = "!,'1000,<100,s10,h"
  opt.shada = { "!", "'1000", "<100", "s10", "h" }
end

api.nvim_create_augroup("vimrc_augroup", {})

api.nvim_set_hl(0, "MyFlash", { bg = "Purple", fg = "White" })
api.nvim_set_hl(0, "MyWindowFlash", { bg = "LightYellow", fg = "DarkGray" })
autocmd("ColorScheme", {
  group = "vimrc_augroup",
  pattern = "*",
  callback = function()
    api.nvim_set_hl(0, "MyFlash", { bg = "Purple", fg = "White" })
    api.nvim_set_hl(0, "MyWindowFlash", { bg = "LightYellow", fg = "DarkGray" })
  end,
})

autocmd("QuickfixCmdPost", {
  group = "vimrc_augroup",
  pattern = { "grep", "vimgrep", "helpgrep" },
  nested = true,
  command = "botright copen",
})

autocmd("TermOpen", {
  group = "vimrc_augroup",
  pattern = "*",
  command = "startinsert",
})

autocmd("InsertLeave", {
  group = "vimrc_augroup",
  pattern = "*",
  command = "call system('zenhan.exe 0')",
})

autocmd("CmdlineLeave", {
  group = "vimrc_augroup",
  pattern = "*",
  command = "call system('zenhan.exe 0')",
})

autocmd("CmdlineLeave", {
  group = "vimrc_augroup",
  pattern = { "/", "\\?" },
  callback = function()
    if vim.v.event.abort == false then
      api.nvim_feedkeys(
        api.nvim_replace_termcodes(":lua require('bistahieversor').echo() require('utahraptor').flash()<CR>", true, false, true),
        "n",
        false
      )
    end
  end,
})

autocmd("FocusGained", {
  group = "vimrc_augroup",
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      local win_id = fn.win_getid()
      local match_id =
        fn.matchadd("MyWindowFlash", [[\%>]] .. (fn.line("w0") - 1) .. [[l\_.*\%<]] .. (fn.line("w$") + 1) .. "l", 100, -1, { window = win_id })
      vim.defer_fn(function()
        if #fn.getwininfo(win_id) ~= 0 then
          fn.matchdelete(match_id, win_id)
          cmd("redraw")
        end
      end, 300)
    end, 30)
  end,
})

autocmd("BufEnter", {
  group = "vimrc_augroup",
  pattern = "*",
  callback = function()
    local t = vim.bo.buftype
    if t == "terminal" or t == "prompt" or t == "quickfix" then
      return
    end
    local root_dir = My.get_root_dir()
    if root_dir ~= nil and #root_dir ~= 0 then
      -- vim.bo.path = '.,,' .. root_dir .. '/**'
      cmd("lcd " .. root_dir)
    end
  end,
})

autocmd("FileType", {
  group = "vimrc_augroup",
  pattern = "*",
  callback = function(args) my_filetype[args.match]() end,
})

autocmd("TextYankPost", {
  group = "vimrc_augroup",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "MyFlash",
      timeout = 400,
      on_visual = false,
    })
  end,
})

command("CdCurrent", "cd %:p:h", {})
command("Cn", function() My.echo_and_yank(fn.expand("%:t")) end, {})
command("Cfp", function() My.echo_and_yank(fn.expand("%:p")) end, {})
command("Crp", function() My.echo_and_yank(fn.expand("%")) end, {})
command("Cdp", function() My.echo_and_yank(My.get_root_dir()) end, {})
command("Cdn", function() My.echo_and_yank(string.gsub(My.get_root_dir(), ".*/", "")) end, {})

command("TCurrent", function()
  local path = fn.expand("%:p")
  if fn.filereadable(path) == 1 then
    local dir_path = fn.expand("%:p:h")

    cmd("new")
    fn.termopen("bash", { cwd = dir_path })
  else
    print("Current buffer is not file!!")
  end
end, {})

-- command('OpenTerm', function()
--   local buffer_handle = vim.api.nvim_create_buf(false, false)
--   if not buffer_handle then
--     return
--   end
--
--   local window_handle = vim.api.nvim_open_win(buffer_handle, true, {
--     relative = 'editor',
--     width = 100,
--     height = 25,
--     row = 10,
--     col = 10
--   })
--
--   if not window_handle then
--     return
--   end
--
--   vim.api.nvim_open_term(buffer_handle, {})
-- end, {})

vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1

vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_sql_completion = 1
vim.g.loaded_xmlformat = 1
vim.g.loaded_tutor_mode_plugin = 1

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
})

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer" },
    { name = "emoji" },
  }),

  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

nnoremap("<Leader><Leader>e", vim.diagnostic.open_float)
nnoremap("g[", vim.diagnostic.goto_prev)
nnoremap("g]", vim.diagnostic.goto_next)
nnoremap("<Leader><Leader>q", vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { buffer = bufnr }
  nnoremap("gD", vim.lsp.buf.declaration, bufopts)
  nnoremap("gd", vim.lsp.buf.definition, bufopts)
  nnoremap("K", vim.lsp.buf.hover, bufopts)
  nnoremap("<Leader><Leaer>gi", vim.lsp.buf.implementation, bufopts)
  nnoremap("<C-k>", vim.lsp.buf.signature_help, bufopts)
  nnoremap("<Leader><Leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  nnoremap("<Leader><Leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  nnoremap("<Leader><Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  nnoremap("<Leader><Leader>D", vim.lsp.buf.type_definition, bufopts)
  nnoremap("<Leader><Leader>rn", vim.lsp.buf.rename, bufopts)
  nnoremap("<Leader><Leader>ca", vim.lsp.buf.code_action, bufopts)
  nnoremap("gr", vim.lsp.buf.references, bufopts)
  nnoremap("<Leader><Leader>f", function() vim.lsp.buf.format({ async = false }) end, bufopts)
end

require("mason").setup()
local nvim_lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = {}
    opts.on_attach = on_attach

    if server_name == "yamlls" then
      opts.settings = {
        yaml = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        },
      }
    end

    nvim_lspconfig[server_name].setup(opts)
  end,
})

nvim_lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = {
          "?.lua",
          "?/init.lua",
        },
      },
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim", "pp" }, -- pp is same vim.pretty_print
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file("", true),
        -- '/usr/local/share/lua/5.1/?/?.lua',
        library = vim.list_extend(My.plugin_paths(), { "/usr/local/share/lua/5.1/" }),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

local hydra = require("hydra")
hydra({
  name = "window",
  mode = { "i", "t", "n" },
  body = [[<C-\>]],
  heads = {
    {
      ">",
      function() My.all_mode_wincmd(">") end,
    },
    {
      "<",
      function() My.all_mode_wincmd("<") end,
    },
    {
      "+",
      function() My.all_mode_wincmd("+") end,
    },
    {
      "-",
      function() My.all_mode_wincmd("-") end,
    },
    {
      "<c-h>",
      function() My.all_mode_wincmd("h") end,
    },
    {
      "<c-j>",
      function() My.all_mode_wincmd("j") end,
    },
    {
      "<c-k>",
      function() My.all_mode_wincmd("k") end,
    },
    {
      "<c-l>",
      function() My.all_mode_wincmd("l") end,
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

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = "auto",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

bistahieversor.setup({ maxcount = 1000, echo_wrapscan = true })
noremap("n", function()
  bistahieversor.n_and_echo()
  utahraptor.flash()
end)

noremap("N", function()
  bistahieversor.N_and_echo()
  utahraptor.flash()
end)

noremap("*", function()
  lasterisk.search()
  bistahieversor.echo()
  utahraptor.flash()
end)

xnoremap("*", function()
  lasterisk.search({ is_whole = false })
  bistahieversor.echo()
  utahraptor.flash()
end)

noremap("g*", function()
  lasterisk.search({ is_whole = false })
  bistahieversor.echo()
  utahraptor.flash()
end)

nnoremap("g/", function()
  local pattern = [[\V]] .. fn.join(vim.tbl_map(function(line) return fn.escape(line, [[/\]]) end, fn.getreg(vim.v.register, 1, 1)), [[\n]])
  opt.hlsearch = opt.hlsearch
  fn.setreg("/", pattern)
  fn.histadd("/", pattern)
  bistahieversor.n_and_echo()
  utahraptor.flash()
end)

cnoremap("<C-e>", "<End>")
inoremap("<C-e>", "<End>")
cnoremap("<C-a>", "<Home>")
inoremap("<C-a>", "<Home>")
cnoremap("<C-f>", "<Right>")
inoremap("<C-f>", "<Right>")
cnoremap("<C-b>", "<Left>")
inoremap("<C-b>", "<Left>")

nnoremap("gs", ":<C-u>%s///g<Left><Left>")
xnoremap("gs", ":s///g<Left><Left>")

xnoremap("v", "$h")
-- xnoremap('v', '$')

xnoremap("<ESC>", "o<ESC>")
nnoremap("gv", "gvo")

-- telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<Up>"] = require("telescope.actions").preview_scrolling_up,
        ["<Down>"] = require("telescope.actions").preview_scrolling_down,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = false,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
})
telescope.load_extension("fzf")

local tele_builtin = require("telescope.builtin")
nnoremap("<Space>F", "", {
  callback = function() tele_builtin.oldfiles() end,
})
nnoremap("<Space>f", "", {
  callback = function() tele_builtin.oldfiles({ only_cwd = true }) end,
})
nnoremap("<Space>R", "", {
  callback = function() tele_builtin.resume() end,
})

nnoremap("<Space>.", [[<cmd>e $MYVIMRC<CR>]])

nnoremap("j", "gj")
xnoremap("j", "gj")
nnoremap("k", "gk")
xnoremap("k", "gk")

nnoremap("yie", [[<cmd>%y<cr>]])
nnoremap("die", "ggdG")
nnoremap("vie", "ggdG")

xnoremap("<Esc>", "o<Esc>")
nnoremap("gv", "gvo")

nnoremap("gF", "<Cmd>vertical botright wincmd F<CR>")

-- nnoremap('n', 'n', { callback = function() print('callback!!!') end })

-- setting
opt.undofile = true
opt.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo/"

opt.smartcase = true
opt.ignorecase = true

opt.hidden = false

opt.undofile = true
opt.undodir = vim.env.XDG_STATE_HOME .. "/nvim/undo/"

opt.directory = vim.env.XDG_STATE_HOME .. "/nvim/swap/"
opt.swapfile = true

opt.cursorline = true

opt.signcolumn = "yes"

opt.shortmess = "filmnrwxtToOISs"

opt.title = true
opt.cmdheight = 2
opt.showcmd = true

opt.backup = false
opt.writebackup = false

opt.equalalways = true
opt.splitright = true

opt.list = true
opt.listchars = {
  tab = ">--",
}

opt.sidescroll = 3

opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true

opt.spelllang = { "en", "cjk" }

opt.formatoptions = "tcroqmMj"

opt.fixendofline = false

opt.mouse = "nv"
opt.mousehide = false

opt.fileencoding = "utf-8"

if fn.executable("rg") then
  opt.grepprg = "rg --vimgrep --no-heading"
end

opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}
opt.clipboard = "unnamed"
vim.g.clipboard = {
  name = "win32yank-wsl",

  copy = {
    ["+"] = "win32yank.exe -i",
    ["*"] = "win32yank.exe -i",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enable = 1,
}

opt.termguicolors = true

vim.g.sandwich_no_default_key_mappings = 1
vim.g.operator_sandwich_no_default_key_mappings = 1

cmd.packadd("vim-sandwich")
fn["operator#sandwich#set"]("add", "all", "highlight", 10)
fn["operator#sandwich#set"]("delete", "all", "highlight", 10)
fn["operator#sandwich#set"]("add", "all", "hi_duration", 10)
fn["operator#sandwich#set"]("delete", "all", "hi_duration", 10)

xnoremap("sd", "<Plug>(operator-sandwich-delete)")
xnoremap("sr", "<Plug>(operator-sandwich-replace)")
nnoremap("sa", "<Plug>(operator-sandwich-add)iw")
xnoremap("sa", "<Plug>(operator-sandwich-add)")
noremap("sA", "<Plug>(operator-sandwich-add)")

nnoremap("sd", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
nnoremap("sr", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")

onoremap("iq", "<Plug>(textobj-sandwich-auto-i)")
xnoremap("iq", "<Plug>(textobj-sandwich-auto-i)")
onoremap("aq", "<Plug>(textobj-sandwich-auto-a)")
onoremap("aq", "<Plug>(textobj-sandwich-auto-a)")

cmd.colorscheme("tokyonight")
