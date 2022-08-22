My = require('my')

local api = vim.api
local fn = vim.fn
local vg = vim.g
local vo = vim.o
local vv = vim.v

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

-- packer.nvim
vo.packpath = fn.stdpath('data') .. '/site/'
vim.cmd [[packadd packer.nvim]]
local packer = require('packer')
packer.init({ plugin_package = 'p' })
packer.startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }

  use 'neovim/nvim-lspconfig'
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-emoji'
  use 'hrsh7th/cmp-nvim-lua'

  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use 'mjlbach/onedark.nvim'
  use 'rebelot/kanagawa.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'EdenEast/nightfox.nvim'
  use 'cocopon/iceberg.vim'

  use 'nvim-lualine/lualine.nvim'

  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
  }

  use 'haya14busa/vim-asterisk'
  use 'AndrewRadev/linediff.vim'
  use 'tyru/open-browser.vim'
  use 'tyru/open-browser-github.vim'
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'klen/nvim-config-local'
  use 'rhysd/committia.vim'
  use 'hotwatermorning/auto-git-diff'

  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }

  use 'anuvyklack/hydra.nvim'

  use "~/repos/github.com/rapan931/lasterisk.nvim"
  use "~/repos/github.com/rapan931/bistahieversor.nvim"
  use "~/repos/github.com/rapan931/utahraptor.nvim"
end)

local my_filetype = require'my.filetype'
local bistahieversor = require'bistahieversor'
local utahraptor = require'utahraptor'

local my_map = require'my.map'

local map = my_map.map
-- local xmap = my_map.xmap
local nmap = my_map.nmap
-- local imap = My.keymap.imap
-- local cmap = My.keymap.cmap
-- local noremap = my_map.noremap
local xnoremap = my_map.xnoremap
local nnoremap = my_map.nnoremap
local inoremap = my_map.inoremap
local cnoremap = my_map.cnoremap

vg.ruby_no_expensive = 1

if fn.has'vim_starting' then
  vo.viminfo = "!,'1000,<100,s10,h"
end

api.nvim_create_augroup('vimrc_augroup', {})

autocmd('QuickfixCmdPost', {
  group = 'vimrc_augroup',
  pattern = {'grep', 'vimgrep', 'helpgrep'},
  nested = true,
  command = 'botright copen',
})

autocmd('TermOpen', {
  group = 'vimrc_augroup',
  pattern = '*',
  command = 'startinsert',
})

autocmd('InsertLeave', {
  group = 'vimrc_augroup',
  pattern = '*',
  command = 'call system("zenhan.exe 0")',
})

autocmd('CmdlineLeave', {
  group = 'vimrc_augroup',
  pattern = '*',
  command = 'call system("zenhan.exe 0")',
})

autocmd('CmdlineLeave', {
  group = 'vimrc_augroup',
  pattern = {'/', '\\?'},
  callback = function()
    if vim.v.event.abort == false then
      api.nvim_feedkeys(api.nvim_replace_termcodes(
        ":lua require('bistahieversor').echo() require('utahraptor').flash()<CR>", true, false, true
      ), 'n',true)
    end
  end
})

autocmd('BufEnter', {
  group = 'vimrc_augroup',
  pattern = '*',
  callback = function()
    local t = vim.bo.buftype
    if t == 'terminal' or t == 'prompt' or t == 'quickfix' then
      return
    end
    local root_dir = My.get_root_dir()
    if root_dir ~= nil and #root_dir ~= 0 then
      -- vim.bo.path = '.,,' .. root_dir .. '/**'
      vim.cmd('lcd ' .. root_dir)
    end
  end
})

autocmd('FileType', {
  group = 'vimrc_augroup',
  pattern = '*',
  callback = function(args) my_filetype[args.match]() end
})

autocmd('TextYankPost', {
  group = 'vimrc_augroup',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
    higroup = 'Utahraptor',
    timeout = 400,
    on_visual = false
    })
  end
})

command('CdCurrent', 'cd %:p:h', {})
command('Cn',  function() My.echo_and_yank(fn.expand('%:t')) end, {})
command('Cfp', function() My.echo_and_yank(fn.expand('%:p')) end, {})
command('Crp', function() My.echo_and_yank(fn.expand('%')) end, {})
command('Cdp', function() My.echo_and_yank(My.get_root_dir()) end, {})
command('Cdn', function() My.echo_and_yank(string.gsub(My.get_root_dir(), '.*/', '')) end, {})

command('TCurrent', function()
  local path = fn.expand('%:p')
  if fn.filereadable(path) == 1 then
    local dir_path = fn.expand('%:p:h')

    vim.cmd[[new]]
    fn.termopen('bash', { cwd = dir_path })
  else
    print('Current buffer is not file!!')
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

vg.did_install_default_menus = 1
vg.did_install_syntax_menu   = 1

vg.loaded_vimball            = 1
vg.loaded_vimballPlugin      = 1
vg.loaded_tar                = 1
vg.loaded_zip                = 1
vg.loaded_zipPlugin          = 1
vg.loaded_netrw              = 1
vg.loaded_netrwPlugin        = 1
vg.loaded_netrwSettings      = 1
vg.loaded_netrwFileHandlers  = 1
vg.loaded_2html_plugin       = 1
vg.loaded_gzip               = 1
vg.loaded_tarPlugin          = 1
vg.loaded_sql_completion     = 1
vg.loaded_xmlformat          = 1
vg.loaded_tutor_mode_plugin  = 1

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
}

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
    end,
  }, sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  } , {
    { name = 'buffer' },
    { name = 'emoji' },
  }),

  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()

      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
   sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
   sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require("mason").setup()
local nvim_lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = {}

    nvim_lspconfig[server_name].setup(opts)
  end
})

nnoremap('<space>e', vim.diagnostic.open_float)
nnoremap('gh', vim.diagnostic.goto_prev)
nnoremap('gl', vim.diagnostic.goto_next)
nnoremap('<space>q', vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local bufopts = { buffer=bufnr }
  nnoremap('gD', vim.lsp.buf.declaration, bufopts)
  nnoremap('gd', vim.lsp.buf.definition, bufopts)
  nnoremap('K', vim.lsp.buf.hover, bufopts)
  nnoremap('gi', vim.lsp.buf.implementation, bufopts)
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts)
  nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  nnoremap('<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts)
  nnoremap('<space>rn', vim.lsp.buf.rename, bufopts)
  nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts)
  nnoremap('gr', vim.lsp.buf.references, bufopts)
  nnoremap('<space>f',function() vim.lsp.buf.format { async = true } end, bufopts)
end

nvim_lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  cmd = {'lua-language-server'},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?/init.lua',
          'lua/?.lua',
        },
      },
      completion = {
         callSnippet = 'Replace',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        -- library = vim.api.nvim_get_runtime_file("", true),
        library = My.plugin_paths()
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

local hydra = require('hydra')
hydra({
  name = 't window',
  mode = {'i', 't', 'n'},
  body = [[<C-\>]],
  heads = {
    { '>', function() My.all_mode_wincmd('>') end },
    { '<', function() My.all_mode_wincmd('<') end },
    { '+', function() My.all_mode_wincmd('+') end },
    { '-', function() My.all_mode_wincmd('-') end },
    { 'h', function() My.all_mode_wincmd('h') end },
    { 'j', function() My.all_mode_wincmd('j') end },
    { 'k', function() My.all_mode_wincmd('k') end },
    { 'l', function() My.all_mode_wincmd('l') end },
  },
})

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
     always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

bistahieversor.setup({ maxcount = 1000 , echo_wrapscan = true})
map('n', function()
  bistahieversor.n_and_echo()
  utahraptor.flash()
end)

map('N', function()
  bistahieversor.N_and_echo()
  utahraptor.flash()
end)

nmap('*',  function()
  require('lasterisk').search()
  bistahieversor.echo()
  utahraptor.flash()
end)

map('g*',  function()
  require('lasterisk').search({ is_whole = false })
  bistahieversor.echo()
  utahraptor.flash()
end)

nmap('g/', function()
  local pattern = [[\V]] .. fn.join(vim.tbl_map(function(line) return fn.escape(line, [[/\]]) end, fn.getreg(vv.register, 1, 1)), [[\n]])
  vo.hlsearch = vo.hlsearch
  fn.setreg('/', pattern)
  fn.histadd('/', pattern)
  bistahieversor.n_and_echo()
  utahraptor.flash()
end)

cnoremap('<C-e>', '<End>')
inoremap('<C-e>', '<End>')
cnoremap('<C-a>', '<Home>')
inoremap('<C-a>', '<Home>')
cnoremap('<C-f>', '<Right>')
inoremap('<C-f>', '<Right>')
cnoremap('<C-b>', '<Left>')
inoremap('<C-b>', '<Left>')

nnoremap('gs', ':<C-u>%s///g<Left><Left>')
xnoremap('gs', ':s///g<Left><Left>')

xnoremap('v', '$h')
-- xnoremap('v', '$')

xnoremap('<ESC>', 'o<ESC>')
nnoremap('gv', 'gvo')

-- telescope
local telescope = require('telescope')
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = false,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
}
telescope.load_extension('fzf')

local tele_builtin = require('telescope.builtin')
nnoremap('<Space>F', '', { callback = function() tele_builtin.oldfiles() end })
nnoremap('<Space>f', '', { callback = function() tele_builtin.oldfiles({ only_cwd = true }) end })

nnoremap('<Space>.', [[<cmd>e $MYVIMRC<CR>]])

nnoremap('j', 'gj')
xnoremap('j', 'gj')
nnoremap('k', 'gk')
xnoremap('k', 'gk')

-- nnoremap('n', 'n', { callback = function() print('callback!!!') end })

-- setting
vo.undofile = true
vo.undodir = vim.env.XDG_STATE_HOME..'/nvim/undo/'

vo.smartcase = true
vo.ignorecase = true

vo.hidden = false

vo.undofile = true
vo.undodir = vim.env.XDG_STATE_HOME..'/nvim/undo/'

vo.directory = vim.env.XDG_STATE_HOME..'/nvim/swap/'
vo.swapfile = true

vo.cursorline = true

vo.signcolumn = 'yes'

vo.shortmess = 'filmnrwxtToOIS'

vo.title = true
vo.laststatus = 2
vo.cmdheight = 1
vo.showcmd = true

vo.backup = false
vo.writebackup = false

vo.equalalways = true
vo.splitright = true

vo.list = true
vo.listchars = 'tab:>-'

vo.sidescroll = 3

vo.matchpairs = '(:),{:},[:],<:>'

vo.expandtab = true
vo.tabstop = 2
vo.softtabstop = 2
vo.shiftwidth = 2
vo.shiftround = 2

vo.spelllang = 'en,cjk'

vo.formatoptions = 'tcroqmMj'

vo.fixendofline = false

vo.mouse = 'nv'
vo.mousehide = false

vo.fileencoding = 'utf-8'

if fn.executable('rg') then
  vo.grepprg = "rg --vimgrep --no-heading"
end

-- vim.fileencodings = 'utf-8,sjis,euc-jp,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,euc-jisx0213'

vo.completeopt = 'menu,menuone,noselect'
vo.clipboard = 'unnamed'
vg.clipboard = {
  name = 'win32yank-wsl',

  copy = {
    ['+'] = 'win32yank.exe -i',
    ['*'] = 'win32yank.exe -i'
  },
  paste = {
    ['+'] = 'win32yank.exe -o --lf',
    ['*'] = 'win32yank.exe -o --lf'
  },
  cache_enable = 1,
}

vo.termguicolors = true
vim.cmd [[colorscheme iceberg]]
