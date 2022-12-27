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
local call = vim.call
local cmd = vim.cmd

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

-- packer.nvim
vim.opt.packpath = fn.stdpath("data") .. "/site/"
cmd("packadd packer.nvim")
local packer = require("packer")
packer.init({ plugin_package = "p" })
packer.startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })

  -- treesister
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("stevearc/aerial.nvim")

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
  use("j-hui/fidget.nvim")

  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-emoji")
  use("hrsh7th/cmp-nvim-lua")

  use("hrsh7th/cmp-vsnip")

  use("folke/tokyonight.nvim")
  use("mjlbach/onedark.nvim")
  use("rebelot/kanagawa.nvim")
  use("ellisonleao/gruvbox.nvim")
  use("EdenEast/nightfox.nvim")

  use("nvim-lualine/lualine.nvim")
  use("numToStr/Comment.nvim")

  use("klen/nvim-config-local")

  use("anuvyklack/hydra.nvim")

  use("ggandor/leap.nvim")
  use("ggandor/flit.nvim")
  use("notomo/reacher.nvim")

  use("~/repos/github.com/rapan931/lasterisk.nvim")
  use("~/repos/github.com/rapan931/bistahieversor.nvim")
  use("~/repos/github.com/rapan931/dentaku.nvim")

  -- vim script
  use("vim-denops/denops.vim")
  use("t9md/vim-quickhl")
  use({ "machakann/vim-sandwich", opt = true })
  use({ "cohama/lexima.vim", opt = true })
  use("rhysd/committia.vim")
  use("hrsh7th/vim-vsnip")
  use("rafamadriz/friendly-snippets")
  use("previm/previm")
  use("lambdalisue/mr.vim")
  use("thinca/vim-quickrun")
  use("lambdalisue/vim-quickrun-neovim-job")
  use("haya14busa/vim-edgemotion")
  use("AndrewRadev/linediff.vim")
  use("tyru/open-browser.vim")
  use("tyru/open-browser-github.vim")
  use("cocopon/iceberg.vim")
  use("lambdalisue/gin.vim")

  use("kana/vim-textobj-user")
  use("kana/vim-textobj-line")
  use("kana/vim-textobj-indent")
  use("thinca/vim-textobj-between")

  use("kana/vim-operator-user")
  use("kana/vim-operator-replace")
end)

require("leap")
nmap("S", "<Plug>(leap-cross-window)")
nmap("z/", function() require("reacher").start({}) end)
xmap("z/", function() require("reacher").start({}) end)

require("flit").setup({
  keys = { f = "f", F = "F", t = "t", T = "T" },
  -- A string like "nv", "nvo", "o", etc.
  labeled_modes = "",
  multiline = false,
  opts = {},
})

require("fidget").setup({})
require("aerial").setup({
  backends = {
    "treesitter",
    "markdown",
    "man",
  },

  layout = {
    max_width = { 80, 0.5 },
    width = nil,
    min_width = 20,
    win_opts = {
      winblend = 30,
    },

    default_direction = "float",
    placement = "edge",
  },

  keymaps = {
    ["q"] = "actions.close",
  },
  disable_max_lines = 10000,
  disable_max_size = 2000000,
  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },
  highlight_mode = "last",
  manage_folds = "auto",
  link_folds_to_tree = false,
  link_tree_to_folds = true,
  close_on_select = true,
  show_guides = true,
  float = {
    border = "rounded",
    relative = "win",
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.1 },
    override = function(conf, source_winid)
      conf.anchor = "NE"
      conf.col = vim.fn.winwidth(source_winid)
      conf.row = 0
      return conf
    end,
  },
})

vim.g.mapleader = ","
vim.g.previm_wsl_mode = 1

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    disable = function(lang, bufnr)
      local byte_size = fn.getfsize(api.nvim_buf_get_name(bufnr))
      if byte_size > 512 * 1000 then
        return true
      end
      local ok = true
      ok = pcall(function() vim.treesitter.get_parser(bufnr, lang):parse() end) and ok
      ok = pcall(function() vim.treesitter.get_query(lang, "highlights") end) and ok
      if not ok then
        return true
      end
      return false
    end,
  },
})

require("Comment").setup()

local null_ls = require("null-ls")
local null_ls_helper = require("null-ls.helpers")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.stylua,
    -- null_ls.builtins.formatting.prettier.with({
    --   prefer_local = "node_modules/.bin",
    -- }),
    null_ls.builtins.diagnostics.cspell.with({
      condition = function() return vim.fn.executable("cspell") > 0 end,
      -- extra_args = { "--show-suggestions", "--config", "~/.config/cspell/cspell.json" },
      extra_args = { "--show-suggestions", "--config", vim.env.HOME .. "/.config/cspell/cspell.json" },
      -- extra_args = { "--config", vim.env.HOME .. "/.config/cspell/cspell.json" },
      diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity.WARN end,
      method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    }),
    null_ls.builtins.diagnostics.textlint.with({
      prefer_local = "node_modules/.bin",
      filetypes = { "markdown" },
      condition = function(utils) return utils.root_has_file({ ".textlintrc" }) end,
    }),
    null_ls_helper.make_builtin({
      condition = function(utils) return utils.root_has_file({ ".textlintrc" }) end,
      name = "textlint_formatting",
      meta = { url = "https://example.com", description = "TODO" },
      method = null_ls.methods.FORMATTING,
      filetypes = { "markdown" },
      generator_opts = {
        command = "textlint",
        args = { "--fix", "$FILENAME" },
        to_temp_file = true,
      },
      prefer_local = "node_modules/.bin",
      factory = null_ls_helper.formatter_factory,
    }),
  },
  debug = true,
})

vim.g.mr_mru_disabled = 0
vim.g.mr_mrw_disabled = 1
vim.g.mr_mrr_disabled = 1

local my_filetype = require("my.filetype")
local bistahieversor = require("bistahieversor")
local lasterisk = require("lasterisk")

-- telescope
local telescope = require("telescope")
telescope.setup({
  defaults = {
    path_display = { "absolute" },
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

local t_scope_pickers = require("telescope.pickers")
local t_scope_finders = require("telescope.finders")
local t_scope_conf = require("telescope.config").values
local t_scope_make_entry = require("telescope.make_entry")

local function recent_file_sorter()
  -- 適当なsorter。score>0とそれ以外の差さえ出してくれれば何でも良いのでfile_sorterと大きな差はないはず。
  local file_sorter = t_scope_conf.file_sorter()
  local base_scorer = file_sorter.scoring_function
  file_sorter.scoring_function = function(self, prompt, line)
    local score = base_scorer(self, prompt, line)
    if score <= 0 then
      return -1
    else
      return 1
    end
  end
  return file_sorter
end

local function my_picker_mru(o)
  local opts = o or {}
  t_scope_pickers
    .new(opts, {
      prompt_title = "Oldfiles",
      finder = t_scope_finders.new_table({
        results = opts.only_cwd and call("mr#filter", fn["mr#mru#list"](), fn.getcwd()) or call("mr#mru#list"),
        entry_maker = t_scope_make_entry.gen_from_file(opts),
      }),
      sorter = recent_file_sorter(),
      previewer = t_scope_conf.file_previewer(opts),
      tiebreak = function(_, _) return false end,
    })
    :find()
end

local t_scope_builtin = require("telescope.builtin")
nmap("<Space>f", function() my_picker_mru({ only_cwd = true }) end)
nmap("<Space>F", function() my_picker_mru() end)

-- nmap("<Space>f", function() t_scope_builtin.oldfiles({ only_cwd = true }) end)
-- nmap("<Space>F", function() t_scope_builtin.oldfiles() end)
nmap("<Space>R", function() t_scope_builtin.resume() end)
nmap("<Leader><Leader>g", function() t_scope_builtin.live_grep() end)
nmap("<Leader><Leader>f", function() t_scope_builtin.fd({ cwd = vim.fn.expand("%:p:h") }) end)
nmap("<Leader><Leader>F", function() t_scope_builtin.fd({ find_command = { "fd", "--type", "f" } }) end)

require("window-picker").setup({
  include_current_win = true,
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
    width = 40,
    popup = {
      size = { height = "80%", width = "50%" },
      position = "50%",
    },
    mapping_options = { noremap = true, nowait = true },
    mappings = {
      -- ["ZZ"] = function(state) pp(state.tree:get_node()) end,
      -- ["zz"] = function(state) fn.setreg(vim.v.register, vim.inspect(state.tree)) end,
      -- ["Zz"] = function(state) fn.setreg(vim.v.register, vim.inspect(state)) end,
      ["t"] = function(state)
        local node = state.tree:get_node()
        local path = ""
        if node.type == "directory" then
          path = node.path
        else
          path = fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h")
        end
        cmd("topleft new")
        fn.termopen("bash", { cwd = path })
      end,
      ["<Leader><Leader>g"] = function(state) t_scope_builtin.live_grep({ cwd = state.tree:get_node().path }) end,
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
      ["."] = "set_root",
    },
  },
  filesystem = {
    bind_to_cwd = false,
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
          local parent_path, _ = require("neo-tree.utils").split_path(state.path)
          if not require("neo-tree.utils").truthy(parent_path) then
            return
          end

          if node == nil then
            if state.search_pattern then
              require("neo-tree.sources.filesystem").reset_search(state, false)
            end
            require("neo-tree.sources.filesystem")._navigate_internal(state, parent_path, nil, nil, false)
          elseif node.type == "directory" then
            if node.level == 0 then
              if node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              else
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
              local parent = fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h:h")
              if not require("neo-tree.utils").truthy(parent) then
                return
              end

              if state.search_pattern then
                require("neo-tree.sources.filesystem").reset_search(state, false)
              end
              require("neo-tree.sources.filesystem")._navigate_internal(state, parent, nil, nil, false)
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
nmap("<Space>ep", "<CMD>Neotree " .. vim.opt.packpath:get()[1] .. "pack/p/<CR>")
nmap("<Space>eh", "<CMD>Neotree dir=~<CR>")
nmap("<Space>ev", "<CMD>Neotree /usr/local/src/neovim<CR>")
nmap("<Space>eV", "<CMD>Neotree $VIMRUNTIME<CR>")
nmap("<Space>ed", "<CMD>Neotree ~/repos/github.com/rapan931/dotfiles<CR>")

vim.g.ruby_no_expensive = 1

if fn.has("vim_starting") then
  -- opt.viminfo = "!,'1000,<100,s10,h"
  vim.opt.shada = { "!", "'1000", "<100", "s10", "h" }
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
      on_visual = true,
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

command("RTP", function() print(fn.substitute(vim.opt.runtimepath._value, ",", "\n", "g")) end, {})

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

vim.g.vsnip_snippet_dir = fn.stdpath("data") .. "/site/pack/p/start/friendly-snippets/snippets"
local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None,
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
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-s>"] = cmp.mapping.complete({ config = { sources = { { name = "vsnip" } } } }),
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

nmap("<Space><Space>e", vim.diagnostic.open_float)
nmap("g[", vim.diagnostic.goto_prev)
nmap("g]", vim.diagnostic.goto_next)
nmap("<Space><Space>l", vim.diagnostic.setloclist)

local on_attach = function(_, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local buf_opts = { buffer = bufnr }
  nmap("gD", vim.lsp.buf.declaration, buf_opts)
  nmap("gd", vim.lsp.buf.definition, buf_opts)
  nmap("K", vim.lsp.buf.hover, buf_opts)
  nmap("<Space><Space>gi", vim.lsp.buf.implementation, buf_opts)
  nmap("<C-q>", vim.lsp.buf.signature_help, buf_opts)
  nmap("<Space><Space>wa", vim.lsp.buf.add_workspace_folder, buf_opts)
  nmap("<Space><Space>wr", vim.lsp.buf.remove_workspace_folder, buf_opts)
  nmap("<Space><Space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, buf_opts)
  nmap("<Space><Space>D", vim.lsp.buf.type_definition, buf_opts)
  nmap("<Space><Space>rn", vim.lsp.buf.rename, buf_opts)
  nmap("<Space><Space>ca", vim.lsp.buf.code_action, buf_opts)
  nmap("gr", vim.lsp.buf.references, buf_opts)
  nmap("<Space><Space>f", function() vim.lsp.buf.format({ async = false, timeout_ms = 4000 }) end, buf_opts)
end

require("mason").setup()
local nvim_lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup_handlers({
  function(server_name)
    local opts = {}
    opts.on_attach = on_attach

    if server_name == "html" then
      opts.filetypes = { "html", "htmldjango" }
    end

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

nvim_lspconfig.gopls.setup({ on_attach = on_attach })
nvim_lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  cmd = { "lua-language-server" },
  settings = {
    Lua = {
      semantic = { enable = false },
      runtime = {
        version = "LuaJIT",
        path = {
          "?.lua",
          "?/init.lua",
        },
      },
      completion = {
        callSnippet = "Disable",
        keywordSnippet = "Disable",
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

hydra({
  name = "go to older/newer position in change list",
  mode = "n",
  body = "g",
  heads = {
    { ";", "g;" },
    { ",", "g," },
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
  cmd("normal! zz")
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
  vim.opt.hlsearch = vim.opt.hlsearch
  fn.setreg("/", pattern)
  fn.histadd("/", pattern)
  bistahieversor.n_and_echo()
end)

vim.g.quickrun_config = {
  ["_"] = {
    outputter = "error",
    runner = "neovim_job",
    ["outputter/error/success"] = "buffer",
    ["outputter/error/error"] = "buffer",
    ["outputter/buffer/opener"] = ":botright 15split",
    ["outputter/buffer/close_on_empty"] = 1,
  },
  typescript = {
    command = "./node_modules/.bin/tsc",
    cmdopt = "--no-check --allow-all --unstable",
    tempfile = "%{tempname()}.ts",
    exec = { "%c", "node dist/%s:t:r.js" },
  },
  lua = {
    command = "nvim",
    exec = [[%c --clean --headless -c 'source %s' -c 'cquit 0']],
  },
}

vim.g.textobj_indent_no_default_key_mappings = 1
omap("ai", "<Plug>(textobj-indent-a)")
xmap("ai", "<Plug>(textobj-indent-a)")
omap("ii", "<Plug>(textobj-indent-a)")
xmap("ii", "<Plug>(textobj-indent-a)")

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

nmap("<Leader>qw", "<CMD>windo diffthis<CR>")
nmap("<Leader>qo", "<CMD>windo diffoff<CR>")
nmap("<Leader>qu", "<CMD>diffupdate<CR>")

nmap("2o", "jo")

nmap("<Space>m", "<Plug>(quickhl-manual-this)")
xmap("<Space>m", "<Plug>(quickhl-manual-this)")
nmap("<Space>M", "<Plug>(quickhl-manual-reset)")
xmap("<Space>M", "<Plug>(quickhl-manual-reset)")

-- CR付けない
nmap("<Leader>R", ":QuickRun")
xmap("<Leader>R", ":QuickRun")

-- setting
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
vim.opt.mousehide = false

vim.opt.fileencoding = "utf-8"

if fn.executable("rg") then
  vim.opt.grepprg = "rg --vimgrep --no-heading"
end

vim.opt.completeopt = {
  "menu",
  "menuone",
  "noselect",
}
vim.opt.clipboard = "unnamed"
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

vim.opt.termguicolors = true

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

vim.g.lexima_map_escape = ""
vim.g.lexima_enable_endwise_rules = false
vim.g.lexima_accept_pum_with_enter = false

cmd("packadd lexima.vim")

call("lexima#set_default_rules")

-- [ \%# ]の状態から']'の入力でleaveするようにする
-- call("lexima#add_rule", { char = "]", at = [==[\s\%#\s]]==], leave = 2 })

-- typescript
call("lexima#add_rule", {
  filetype = { "typescript", "typescriptreact", "javascript" },
  char = ">",
  at = [==[\.[a-zA-Z]\+([a-zA-Z,]*>\%#)]==],
  input = [==[<BS> => {]==],
  input_after = "}",
})
call("lexima#add_rule", {
  filetype = { "typescript", "typescriptreact", "javascript" },
  char = ">",
  at = [==[\.[a-zA-Z]\+(([a-zA-Z, :<>]*>\%#))]==],
  input = [==[<BS><C-g>U<Right> => {]==],
  input_after = "}",
})
call("lexima#add_rule", {
  filetype = { "typescript", "typescriptreact", "javascript" },
  char = ">",
  at = [==[([a-zA-Z, :<>]*>\%#)]==],
  input = [==[<BS><C-g>U<Right> => {]==],
  input_after = "}",
})
call("lexima#add_rule", {
  filetype = { "typescript", "typescriptreact", "javascript" },
  char = ">",
  at = [==[({[a-zA-Z, :<>]\+>\%#\s\?})]==],
  input = [==[<BS><C-o>:normal! f)<CR><C-g>U<Right> => {}<C-g>U<Left>]==],
})

-- ruby
call("lexima#add_rule", {
  filetype = { "ruby" },
  char = "<CR>",
  at = [==[^\s*\%(module\|def\|class\|if\|unless\)\s\w\+\((.*)\)\?\%#$]==],
  input = "<CR>",
  input_after = "<CR>end",
})
call("lexima#add_rule", { filetype = { "ruby" }, char = "<CR>", at = [==[^\s*\%(begin\)\s*\%#]==], input_after = "<CR>end" })
call("lexima#add_rule", { filetype = { "ruby" }, char = "<CR>", at = [==[\%(^\s*#.*\)\@<!do\%(\s*|.*|\)\?\s*\%#]==], input_after = "<CR>end" })
call("lexima#add_rule", { filetype = { "ruby" }, char = "<Bar>", at = [==[do\%#]==], input = "<Space><Bar>", input_after = "<Bar><CR>end" })
call("lexima#add_rule", { filetype = { "ruby" }, char = "<Bar>", at = [==[do\s\%#]==], input = "<Bar>", input_after = "<Bar><CR>end" })
call("lexima#add_rule", { filetype = { "ruby" }, char = "<Bar>", at = [==[{\%#}]==], input = "<Space><Bar>", input_after = "<Bar><Space>" })
call("lexima#add_rule", { filetype = { "ruby" }, char = "<Bar>", at = [==[{\s\%#\s}]==], input = "<Bar>", input_after = "<Bar><Space>" })

-- 各種ログの設定 ppp<Space>で発火するようにする
call(
  "lexima#add_rule",
  { filetype = { "typescript", "typescriptreact", "javascript" }, char = "<Space>", at = [[\<pp\%#]], input = "<BS><BS><BS>console.log()<Left>" }
)

call("lexima#add_rule", { filetype = "lua", char = "<Space>", at = [[\<pp\%#]], input = "<BS><BS>vim.pretty_print()<Left>" })
call("lexima#add_rule", { filetype = "vim", char = "<Space>", at = [[\<pp\%#]], input = "<BS><BS>echo <Space>" })
call("lexima#add_rule", { filetype = "python", char = "<Space>", at = [[\<pp\%#]], input = "<BS><BS>print()<Left>" })

imap("<S-CR>", function() return "<End>" .. call("lexima#expand", "<LT>CR>", "i") end, { expr = true, remap = true, silent = true })

cmd("colorscheme tokyonight")
