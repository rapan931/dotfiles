local vimrc_augroup = vim.api.nvim_create_augroup("vimrc_augroup", { clear = false })
return {
return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    local null_ls = require("null-ls")
    local null_ls_helper = require("null-ls.helpers")

    null_ls.setup({
      sources = {
        -- null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier.with({
        --   prefer_local = "node_modules/.bin",
        -- }),
        null_ls.builtins.formatting.eslint.with({
          prefer_local = "node_modules/.bin",
        }),
        null_ls.builtins.diagnostics.cspell.with({
          condition = function()
            return vim.fn.executable("cspell") > 0
          end,
          -- extra_args = { "--show-suggestions", "--config", "~/.config/cspell/cspell.json" },
          extra_args = { "--show-suggestions", "--config", vim.env.HOME .. "/.config/cspell/cspell.json" },
          -- extra_args = { "--config", vim.env.HOME .. "/.config/cspell/cspell.json" },
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity.WARN
          end,
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
        }),
        null_ls.builtins.diagnostics.textlint.with({
          prefer_local = "node_modules/.bin",
          filetypes = { "markdown" },
          method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          condition = function(utils)
            return utils.root_has_file({ ".textlintrc" })
          end,
        }),
        null_ls_helper.make_builtin({
          condition = function(utils)
            return utils.root_has_file({ ".textlintrc" })
          end,
          name = "textlint_formatting",
          meta = { url = "https://example.com", description = "textlint_formatting" },
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
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = vimrc_augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vimrc_augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(client)
                  return client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
