return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
    -- local nvim_lspconfig = require("lspconfig")
    -- local mason_lspconfig = require("mason-lspconfig")
    -- mason_lspconfig.setup_handlers({
    --   function(server_name)
    --     local opts = {}
    --     opts.on_attach = on_attach
    --
    --     if server_name == "html" then
    --       opts.filetypes = { "html", "htmldjango" }
    --     end
    --
    --     if server_name == "yamlls" then
    --       opts.settings = {
    --         yaml = {
    --           ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
    --         },
    --       }
    --     end
    --
    --     nvim_lspconfig[server_name].setup(opts)
    --   end,
    -- })
  end,
}
