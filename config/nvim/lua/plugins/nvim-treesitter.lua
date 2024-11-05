return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    { "windwp/nvim-ts-autotag" },
    -- {
    --   "ray-x/cmp-treesitter",
    --   cond = function() return require("core.plugin").has("nvim-cmp") and not is_vscode() end,
    -- },
    --
    -- { "yioneko/nvim-yati", enabled = false },
    --
    -- -- textobj
    -- { "nvim-treesitter/nvim-treesitter-textobjects" },
    -- { "RRethy/nvim-treesitter-textsubjects" },
    -- { "David-Kunz/treesitter-unit" },
    --
    -- -- UI
    -- { "haringsrob/nvim_context_vt" },
    -- { "romgrk/nvim-treesitter-context" },
    --
    -- { "RRethy/nvim-treesitter-endwise" },
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      autotag = { enable = true },
      -- matchup = { enable = true },
      -- yati = { enable = true },
      -- endwise = { enable = true },
      -- indent = { enable = true },
      highlight = {
        enable = true,
        disable = function(lang, bufnr)
          local byte_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
          if byte_size > 512 * 1000 then
            return true
          end
          local ok = true
          ok = pcall(function() vim.treesitter.get_parser(bufnr, lang):parse() end) and ok
          ok = pcall(function() vim.treesitter.query.get(lang, "highlights") end) and ok
          if not ok then
            return true
          end
          return false
        end,
      },
    })
  end,
}
