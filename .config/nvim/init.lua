My = require("my")

local my_map = require("my.map")
local map = my_map.map
local xmap = my_map.xmap
local nmap = my_map.nmap
local imap = my_map.imap
local cmap = my_map.cmap
local omap = my_map.omap

local api = vim.api
local fn = vim.fn

local opt = vim.opt
local cmd = vim.cmd

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

-- packer.nvim
opt.packpath = fn.stdpath("data") .. "/site/"
cmd("packadd packer.nvim")
local packer = require("packer")
packer.init({ plugin_package = "p" })
packer.startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

  -- treesister
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/nvim-treesitter-textobjects")

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })

  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons" },
  })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })

  use({
    "nvim-neo-tree/neo-tree.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "~/repos/github.com/rapan931/nvim-window-picker",
    },
  })

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
  use("numToStr/Comment.nvim")

  use("haya14busa/vim-asterisk")
  use("AndrewRadev/linediff.vim")
  use("tyru/open-browser.vim")
  use("tyru/open-browser-github.vim")
  use("klen/nvim-config-local")
  use("rhysd/committia.vim")
  use("hotwatermorning/auto-git-diff")
  use("haya14busa/vim-edgemotion")

  use({ "machakann/vim-sandwich", opt = true })

  use("windwp/nvim-autopairs")
  use("previm/previm")

  use("anuvyklack/hydra.nvim")

  use("~/repos/github.com/rapan931/lasterisk.nvim")
  use("~/repos/github.com/rapan931/bistahieversor.nvim")
  use("~/repos/github.com/rapan931/binary_comments.vim")
  -- use("~/repos/github.com/rapan931/utahraptor.nvim")
end)

vim.g.mapleader = ","
vim.g.previm_wsl_mode = 1

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(lang)
      local ok = pcall(function() vim.treesitter.get_query(lang, "highlights") end)
      return not ok
    end,
  },
})

-- opt.winbar = '%f'
require("window-picker").setup({
  include_current_win = true,
  -- use_winbar = 'always',
  autoselect_one = true,
  selection_chars = "SDFGHJKL;QWERTYUIOPZCVBNM",
  other_win_hl_color = "#e35e4f",
  filter_rules = {
    bo = {
      filetype = { "neo-tree", "neo-tree-popup", "notify" },
      buftype = { "terminal", "quickfix" },
    },
  },
  hl_position = "all",
})

require("Comment").setup()
require("nvim-autopairs").setup({})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.stylua.with({
      cwd = function(_)
        local root = My.get_root_dir()
        if #root > 0 then
          return root
        else
          return fn.expand("%:p:h")
        end
      end,
    }),
    null_ls.builtins.diagnostics.cspell.with({
      condition = function() return vim.fn.executable("cspell") > 0 end,
      -- extra_args = { "--show-suggestions", "--config", "~/.config/cspell/cspell.json" },
      extra_args = { "--show-suggestions", "--config", vim.env.HOME .. "/.config/cspell/cspell.json" },
      -- extra_args = { "--config", vim.env.HOME .. "/.config/cspell/cspell.json" },
      diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity.WARN end,
    }),
  },
  debug = true,
})

local my_filetype = require("my.filetype")
local bistahieversor = require("bistahieversor")
local lasterisk = require("lasterisk")

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
  },
})
telescope.load_extension("fzf")

local telescope_builtin = require("telescope.builtin")
nmap("<Space>f", function() telescope_builtin.oldfiles({ only_cwd = true }) end)
nmap("<Space>F", function() telescope_builtin.oldfiles() end)
nmap("<Space>R", function() telescope_builtin.resume() end)
nmap("<Space><Space>g", function() telescope_builtin.live_grep() end)
nmap("<Space><Space>f", function() telescope_builtin.fd({ cwd = vim.fn.expand("%:p:h") }) end)
nmap("<Space><Space>F", function() telescope_builtin.fd({ find_command = { "fd", "--type", "f" } }) end)

vim.g.neo_tree_remove_legacy_commands = 1
require("neo-tree").setup({
  hide_root_node = true,
  sources = {
    "filesystem",
    "git_status",
  },
  sort_function = nil,
  use_default_mappings = false,
  source_selector = {
    winbar = true,
    separator = "|",
  },
  window = {
    width = 50,
    popup = {
      size = { height = "80%", width = "50%" },
      position = "50%",
    },
    mapping_options = { noremap = true, nowait = true },
    mappings = {
      -- ["ZZ"] = function(state) fn.setreg(vim.v.register, vim.inspect(state.tree:get_node())) end,
      ["ZZ"] = function(state) pp(state.tree:get_node()) end,
      ["zz"] = function(state) fn.setreg(vim.v.register, vim.inspect(state.tree)) end,
      ["Zz"] = function(state) fn.setreg(vim.v.register, vim.inspect(state)) end,
      ["t"] = function(state)
        local node = state.tree:get_node()
        local path = ""
        if node.type == "directory" then
          path = node.path
        else
          path = node.path:match("(^.+/).+$")
        end
        cmd("topleft new")
        fn.termopen("bash", { cwd = path })
      end,
      ["<Space><Space>g"] = function(state) telescope_builtin.live_grep({ cwd = state.tree:get_node().path }) end,
      ["<C-l>"] = "refresh",
      ["q"] = "close_window",

      ["<space>"] = { "toggle_node", nowait = false },
      ["<esc>"] = "revert_preview",
      ["p"] = { "toggle_preview", config = { use_float = true } },
      ["Za"] = "expand_all_nodes",
      ["o"] = "open",

      ["AAA"] = { "add", config = { show_path = "none" } },
      ["KKK"] = "add_directory",
      ["DDD"] = "delete",
      ["RRR"] = "rename",
      ["YYY"] = "copy_to_clipboard",
      ["XXX"] = "cut_to_clipboard",
      ["PPP"] = "paste_from_clipboard",
      ["CCC"] = "copy",
      ["MMM"] = "move",
      ["g?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
    },
  },
  filesystem = {
    window = {
      mappings = {
        ["H"] = "toggle_hidden",
        ["z/"] = "fuzzy_finder",
        ["z?"] = "fuzzy_finder_directory",
        ["f"] = "filter_on_submit",
        ["<C-x>"] = "clear_filter",
        -- ["<bs>"] = "navigate_up",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",

        ["T"] = function(state)
          local node = state.tree:get_node()

          if node.type ~= "directory" then
            api.nvim_echo({ { "works only for directories!", "WarningMsg" } }, true, {})
            return
          end

          local toggle_dir_no_redraw =
            function(_state, _node) require("neo-tree.sources.filesystem").toggle_directory(_state, _node, nil, true, true) end

          local expand_node
          expand_node = function(_node)
            local id = _node:get_id()
            if _node.type == "directory" and not _node:is_expanded() then
              toggle_dir_no_redraw(state, _node)
              _node = state.tree:get_node(id)
            end
            local children = state.tree:get_nodes(id)
            if children then
              for _, child in ipairs(children) do
                if child.type == "directory" then
                  expand_node(child)
                end
              end
            end
          end

          expand_node(node)
          require("neo-tree.ui.renderer").redraw(state)
        end,
        ["<CR>"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if node._parent_id ~= nil then
              require("neo-tree.sources.filesystem.commands").set_root(state)
            end
          else
            require("neo-tree.sources.common.commands").open_with_window_picker(state)
          end
        end,

        ["l"] = function(state)
          local node = state.tree:get_node()
          if node.type ~= "directory" then
            return
          end

          if not node:is_expanded() then
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          end
          require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
        end,
        ["h"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if node.level == 0 then
              if node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              else
                local parent_path = fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h:h")
                pp(node.path)
                pp(fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h"))
                pp(parent_path)
                if not require("neo-tree.utils").truthy(parent_path) then
                  return
                end

                if state.search_pattern then
                  require("neo-tree.sources.filesystem").reset_search(state, false)
                end
                require("neo-tree.sources.filesystem")._navigate_internal(state, parent_path, nil, nil, false)
              end
            else
              if node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              else
                require("neo-tree.sources.filesystem").toggle_directory(state, state.tree:get_node(node:get_parent_id()))
              end
            end
          else
            if node.level == 0 then
              local parent_path = fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h:h")
              if not require("neo-tree.utils").truthy(parent_path) then
                return
              end

              if state.search_pattern then
                require("neo-tree.sources.filesystem").reset_search(state, false)
              end
              require("neo-tree.sources.filesystem")._navigate_internal(state, parent_path, nil, nil, false)
            else
              require("neo-tree.sources.filesystem").toggle_directory(state, state.tree:get_node(node:get_parent_id()))
            end
          end

          require("neo-tree.ui.renderer").redraw(state)
        end,
      },
    },
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
      show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = true,
      hide_by_name = { ".DS_Store", "thumbs.db", "node_modules" },
    },
    find_by_full_path_words = false,
  },
  git_status = {
    window = {
      mappings = {
        ["gA"] = "git_add_all",
        ["ga"] = "git_add_file",
        ["gu"] = "git_unstage_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gpp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
})

nmap("<Space>ee", "<CMD>Neotree toggle<CR>")
nmap("<Space>er", "<CMD>Neotree dir=./<CR>")
nmap("<Space>ef", "<CMD>Neotree dir=./ reveal_force_cwd<CR>")
nmap("<Space>ep", "<CMD>Neotree " .. opt.packpath:get()[1] .. "pack/p/<CR>")
nmap("<Space>eh", "<CMD>Neotree dir=~<CR>")
nmap("<Space>ev", "<CMD>Neotree $VIMRUNTIME<CR>")
nmap("<Space>ev", "<CMD>Neotree /usr/local/src/neovim<CR>")

local binary_comments = require("binary_comments")
xmap("ge", binary_comments.draw)

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
      api.nvim_feedkeys(api.nvim_replace_termcodes(":lua require('bistahieversor').echo()<CR>", true, false, true), "n", false)
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

nmap("<Leader><Leader>e", vim.diagnostic.open_float)
nmap("g[", vim.diagnostic.goto_prev)
nmap("g]", vim.diagnostic.goto_next)
nmap("<Leader><Leader>q", vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local buf_opts = { buffer = bufnr }
  nmap("gD", vim.lsp.buf.declaration, buf_opts)
  nmap("gd", vim.lsp.buf.definition, buf_opts)
  nmap("K", vim.lsp.buf.hover, buf_opts)
  nmap("<Leader><Leader>gi", vim.lsp.buf.implementation, buf_opts)
  nmap("<C-q>", vim.lsp.buf.signature_help, buf_opts)
  nmap("<Leader><Leader>wa", vim.lsp.buf.add_workspace_folder, buf_opts)
  nmap("<Leader><Leader>wr", vim.lsp.buf.remove_workspace_folder, buf_opts)
  nmap("<Leader><Leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, buf_opts)
  nmap("<Leader><Leader>D", vim.lsp.buf.type_definition, buf_opts)
  nmap("<Leader><Leader>rn", vim.lsp.buf.rename, buf_opts)
  nmap("<Leader><Leader>ca", vim.lsp.buf.code_action, buf_opts)
  nmap("gr", vim.lsp.buf.references, buf_opts)
  nmap("<Leader><Leader>f", function() vim.lsp.buf.format({ async = false }) end, buf_opts)
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
      format = {
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
    { ">", function() My.all_mode_wincmd(">") end },
    { "<", function() My.all_mode_wincmd("<") end },
    { "+", function() My.all_mode_wincmd("+") end },
    { "-", function() My.all_mode_wincmd("-") end },
    { "H", function() My.all_mode_wincmd("H") end },
    { "J", function() My.all_mode_wincmd("J") end },
    { "K", function() My.all_mode_wincmd("K") end },
    { "L", function() My.all_mode_wincmd("L") end },
    { "<c-h>", function() My.all_mode_wincmd("h") end },
    { "<c-j>", function() My.all_mode_wincmd("j") end },
    { "<c-k>", function() My.all_mode_wincmd("k") end },
    { "<c-l>", function() My.all_mode_wincmd("l") end },
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
  extensions = { "quickfix", "neo-tree" },
})

bistahieversor.setup({ maxcount = 1000, echo_wrapscan = true })
map("n", function() bistahieversor.n_and_echo() end)
map("N", function() bistahieversor.N_and_echo() end)
map("<C-n>", function()
  bistahieversor.n_and_echo()
  vim.cmd("normal! zz")
end)

map("*", function()
  lasterisk.search()
  bistahieversor.echo()
end)

xmap("*", function()
  lasterisk.search({ is_whole = false })
  bistahieversor.echo()
end)

map("g*", function()
  lasterisk.search({ is_whole = false })
  bistahieversor.echo()
end)

nmap("g/", function()
  local pattern = [[\V]] .. fn.join(vim.tbl_map(function(line) return fn.escape(line, [[/\]]) end, fn.getreg(vim.v.register, 1, 1)), [[\n]])
  opt.hlsearch = opt.hlsearch
  fn.setreg("/", pattern)
  fn.histadd("/", pattern)
  bistahieversor.n_and_echo()
end)

cmap("<C-e>", "<End>")
imap("<C-e>", "<End>")
cmap("<C-a>", "<Home>")
imap("<C-a>", "<Home>")
cmap("<C-f>", "<Right>")
imap("<C-f>", "<Right>")
cmap("<C-b>", "<Left>")
imap("<C-b>", "<Left>")

nmap("gs", ":<C-u>%s///g<Left><Left>")
xmap("gs", ":s///g<Left><Left>")

xmap("v", "$h")
-- xmap('v', '$')

xmap("<ESC>", "o<ESC>")
nmap("gv", "gvo")

nmap("<Space>.", [[<cmd>e $MYVIMRC<CR>]])

nmap("j", "gj")
xmap("j", "gj")
nmap("k", "gk")
xmap("k", "gk")

nmap("yie", [[<cmd>%y<cr>]])
nmap("die", "ggdG")
nmap("vie", "ggVG")

xmap("<Esc>", "o<Esc>")
nmap("gv", "gvo")

nmap("gF", "<Cmd>vertical botright wincmd F<CR>")

nmap("<C-j>", "<Plug>(edgemotion-j)")
xmap("<C-j>", "<Plug>(edgemotion-j)")
nmap("<C-k>", "<Plug>(edgemotion-k)")
xmap("<C-k>", "<Plug>(edgemotion-k)")

nmap("<Leader>ob", "<Plug>(openbrowser-smart-search)")
xmap("<Leader>ob", "<Plug>(openbrowser-smart-search)")

nmap("<F4>", "<CMD>set wrap!<CR>")

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

cmd("packadd vim-sandwich")
fn["operator#sandwich#set"]("add", "all", "highlight", 10)
fn["operator#sandwich#set"]("delete", "all", "highlight", 10)
fn["operator#sandwich#set"]("add", "all", "hi_duration", 10)
fn["operator#sandwich#set"]("delete", "all", "hi_duration", 10)

xmap("sd", "<Plug>(operator-sandwich-delete)")
xmap("sr", "<Plug>(operator-sandwich-replace)")
nmap("sa", "<Plug>(operator-sandwich-add)iw")
xmap("sa", "<Plug>(operator-sandwich-add)")
map("sA", "<Plug>(operator-sandwich-add)")

nmap("sd", "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")
nmap("sr", "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)")

omap("iq", "<Plug>(textobj-sandwich-auto-i)")
xmap("iq", "<Plug>(textobj-sandwich-auto-i)")
omap("aq", "<Plug>(textobj-sandwich-auto-a)")
omap("aq", "<Plug>(textobj-sandwich-auto-a)")

cmd("colorscheme tokyonight")
