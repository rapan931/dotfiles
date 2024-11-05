return {
  "nvim-telescope/telescope.nvim",
  build = ":TSUpdate",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    { "lambdalisue/mr.vim" },
  },
  config = function()
    local telescope = require("telescope")
    local nmap = require("my.map").nmap
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

    local telescope_pickers = require("telescope.pickers")
    local telescope_finders = require("telescope.finders")
    local telescope_conf = require("telescope.config").values
    local telescope_make_entry = require("telescope.make_entry")
    local telescope_action_state = require("telescope.actions.state")

    local function recent_file_sorter()
      -- 適当なsorter。score>0とそれ以外の差さえ出してくれれば何でも良いのでfile_sorterと大きな差はないはず。
      local file_sorter = telescope_conf.file_sorter()
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
      telescope_pickers
        .new(opts, {
          prompt_title = "Oldfiles",
          finder = telescope_finders.new_table({
            results = opts.only_cwd and vim.call("mr#filter", vim.fn["mr#mru#list"](), vim.fn.getcwd()) or vim.call("mr#mru#list"),
            entry_maker = telescope_make_entry.gen_from_file(opts),
          }),
          sorter = recent_file_sorter(),
          previewer = telescope_conf.file_previewer(opts),
          tiebreak = function(_, _) return false end,
        })
        :find()
    end

    local mr_custom_action = function(_, m)
      m("n", "dd", function(prompt_bufnr)
        local current_picker = telescope_action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection) vim.call("mr#mru#delete", selection.filename) end)
      end)

      return true
    end

    local telescope_builtin = require("telescope.builtin")
    nmap("<Space>f", function() my_picker_mru({ only_cwd = true, attach_mappings = mr_custom_action }) end)
    nmap("<Space>F", function() my_picker_mru({ attach_mappings = mr_custom_action }) end)

    nmap("<Space>R", function() telescope_builtin.resume() end)
    nmap("<Leader><Leader>g", function() telescope_builtin.live_grep() end)
    nmap("<Leader><Leader>f", function() telescope_builtin.fd({ cwd = vim.fn.expand("%:p:h") }) end)
    nmap("<Leader><Leader>F", function() telescope_builtin.fd({ find_command = { "fd", "--type", "f" } }) end)
  end,
}
