local nmap = require("my.map").nmap

return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
  },
  config = function()
    require("window-picker").setup({
      include_current_win = true,
      selection_chars = "SDFGHJKL;QWERTYUIOPZCVBNM",
      show_prompt = true,
      filter_rules = {
        bo = {
          filetype = { "neo-tree", "neo-tree-popup", "notify" },
          buftype = { "terminal", "quickfix" },
        },
      },
      picker_config = {

        statusline_winbar_picker = {
          selection_display = function(char, windowid)
            return "%=" .. char .. "%="
          end,
        },
      },
    })

    local telescope_builtin = require("telescope.builtin")
    require("neo-tree").setup({
      hide_root_node = true,
      sources = {
        "filesystem",
        -- "git_status",
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
          ["ZZ"] = function(state)
            pp(state.tree:get_node())
          end,
          ["zz"] = function(state)
            vim.fn.setreg(vim.v.register, vim.inspect(state.tree))
          end,
          ["Zz"] = function(state)
            vim.fn.setreg(vim.v.register, vim.inspect(state))
          end,
          ["<C-y>"] = function(state)
            require("my").echo_and_yank(state.tree:get_node().path)
          end,
          ["t"] = function(state)
            local node = state.tree:get_node()
            local path = ""
            if node.type == "directory" then
              path = node.path
            else
              path = vim.fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h")
            end
            vim.cmd("topleft new")
            vim.fn.termopen("bash", { cwd = path })
          end,
          ["<Leader><Leader>g"] = function(state)
            telescope_builtin.live_grep({ cwd = state.tree:get_node().path })
          end,
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

              local toggle_dir_no_redraw = function(_state, _node)
                require("neo-tree.sources.filesystem").toggle_directory(_state, _node, nil, true, true)
              end

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
            -- ["<CR>"] = "set_root",
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
            ["w"] = "open_with_window_picker",
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
              elseif node.skip_node and node.is_empty_with_hidden_root then
                -- empty directory
                require("neo-tree.sources.filesystem.commands").navigate_up(state)
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
                  local parent = vim.fn.fnamemodify(string.gsub(node.path, "/$", ""), ":h:h")
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
    })

    nmap("<Space>ee", "<CMD>Neotree toggle<CR>")
    nmap("<Space>er", "<CMD>Neotree ./<CR>")
    nmap("<Space>ef", "<CMD>Neotree ./ reveal_force_cwd<CR>")
    nmap("<Space>ep", "<CMD>Neotree " .. vim.fn.stdpath("data") .. "/lazy<CR>")
    nmap("<Space>eh", "<CMD>Neotree ~<CR>")
    nmap("<Space>ev", "<CMD>Neotree /usr/local/src/neovim<CR>")
    nmap("<Space>eV", "<CMD>Neotree $VIMRUNTIME<CR>")
    nmap("<Space>ed", "<CMD>Neotree ~/repos/github.com/rapan931/dotfiles<CR>")
  end,
}
