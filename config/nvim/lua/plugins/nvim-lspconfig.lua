local function on_attach(on_attach_func)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach_func(client, buffer)
    end,
  })
end

local my_map = require("my.map")
local nmap = my_map.nmap

return {
  "neovim/nvim-lspconfig",
  dependencies = { { "b0o/SchemaStore.nvim" }, { "lukas-reineke/lsp-format.nvim" } },
  init = function()
    on_attach(function(client, bufnr)
      local exclude_ft = {}
      -- local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
      local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      if vim.tbl_contains(exclude_ft, ft) then
        return
      end

      require("lsp-format").on_attach(client)

      local buf_opts = { buffer = bufnr }
      nmap("gD", vim.lsp.buf.declaration, buf_opts)
      nmap("gd", function()
        vim.cmd([[Telescope lsp_definitions]])
      end, buf_opts)
      nmap("K", vim.lsp.buf.hover, buf_opts)
      nmap("<Space><Space>gi", vim.lsp.buf.implementation, buf_opts)
      nmap("<C-q>", vim.lsp.buf.signature_help, buf_opts)
      nmap("<Space><Space>wa", vim.lsp.buf.add_workspace_folder, buf_opts)
      nmap("<Space><Space>wr", vim.lsp.buf.remove_workspace_folder, buf_opts)
      nmap("<Space><Space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, buf_opts)
      nmap("<Space><Space>D", function()
        vim.cmd([[Telescope lsp_type_definitions]])
      end, buf_opts)
      nmap("<Space><Space>rn", vim.lsp.buf.rename, buf_opts)
      nmap("<Space><Space>ca", vim.lsp.buf.code_action, buf_opts)
      nmap("<Space><Space>r", function()
        vim.cmd([[Telescope lsp_references]])
      end, buf_opts)
      nmap("<Space><Space>f", function()
        vim.lsp.buf.format({ async = false, timeout_ms = 4000 })
      end, buf_opts)

      vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
    end)
  end,
  opts = function()
    ---@class LSPConfigOpts
    local o = { lsp_opts = {} }

    o.lsp_opts.capabilities =
      vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

    o.lsp_opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

    o.html_like = {
      "astro",
      "html",
      "htmldjango",
      "css",
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "svelte",
      "vue",
      "markdown",
    }

    o.typescriptInlayHints = {
      parameterNames = {
        enabled = "literals", -- 'none' | 'literals' | 'all'
        suppressWhenArgumentMatchesName = true,
      },
      parameterTypes = { enabled = false },
      variableTypes = { enabled = false },
      propertyDeclarationTypes = { enabled = true },
      functionLikeReturnTypes = { enabled = false },
      enumMemberValues = { enabled = true },
    }

    function o.format_config(enabled)
      return function(client)
        client.server_capabilities.documentFormattingProvider = enabled
        client.server_capabilities.documentRangeFormattingProvider = enabled
      end
    end

    function o.setup(client, extra_opts)
      if type(client) == "string" then
        client = require("lspconfig")[client]
      end

      local default_opts = client.document_config.default_config

      local local_opts = vim.tbl_deep_extend("force", {}, o.lsp_opts, extra_opts or {})

      local_opts.filetypes = vim.tbl_flatten({
        local_opts.filetypes or default_opts.filetypes or {},
        local_opts.extra_filetypes or {},
      })
      local_opts.extra_filetypes = nil
      client.setup(local_opts)
    end

    return o
  end,
  config = function(_, opts)
    local format_config = opts.format_config
    local setup = opts.setup
    local html_like = opts.html_like
    local typescriptInlayHints = opts.typescriptInlayHints

    local lspconfig = require("lspconfig")

    -- server configs

    -- efm
    -- setup(lspconfig.efm, {
    --   filetypes = vim.tbl_flatten({
    --     {
    --       "lua",
    --       "python",
    --       "go",
    --       "rust",
    --     },
    --     -- config
    --     {
    --       "json",
    --       "jsonc",
    --       "yaml",
    --     },
    --     -- others
    --     {
    --
    --       "fish",
    --       "dockerfile",
    --     },
    --     -- web
    --     {
    --       -- -- markup
    --       "html",
    --       "svelte",
    --       "vue",
    --       "astro",
    --       "javascriptreact",
    --       "javascript.jsx",
    --       "typescriptreact",
    --       "typescript.tsx",
    --       "markdown",
    --       "markdown.mdx",
    --       -- -- style
    --       "css",
    --       "scss",
    --       "less",
    --
    --       -- -- script
    --       "javascript",
    --       "typescript",
    --     },
    --   }),
    --   init_options = {
    --     documentFormatting = true,
    --     rangeFormatting = true,
    --     hover = true,
    --     documentSymbol = true,
    --     codeAction = true,
    --     completion = true,
    --   },
    -- })

    -- html/css/js
    -- setup(lspconfig.emmet_ls, { extra_filetypes = html_like, on_attach = format_config(false) })
    -- setup(lspconfig.tailwindcss, { extra_filetypes = html_like, on_attach = format_config(false) })
    setup(lspconfig.html, { on_attach = format_config(false) })
    -- setup(lspconfig.stylelint_lsp, { on_attach = format_config(false) })

    -- setup(lspconfig.eslint, {
    --   extra_filetypes = { "svelte" },
    --   on_attach = format_config(false),
    -- })

    -- setup(lspconfig.biome)

    -- setup(lspconfig.denols, {
    --   single_file_support = false,
    --   root_dir = function(path)
    --     local marker = require("climbdir.marker")
    --     local found = require("climbdir").climb(
    --       path,
    --       marker.one_of(marker.has_readable_file("deno.json"), marker.has_readable_file("deno.jsonc"), marker.has_directory("denops")),
    --       {
    --         halt = marker.one_of(marker.has_readable_file("package.json"), marker.has_directory("node_modules")),
    --       }
    --     )
    --     if found then
    --       vim.b[vim.fn.bufnr()].deno_deps_candidate = found .. "/deps.ts"
    --     end
    --     return found
    --   end,
    --   on_attach = function(_, buffer)
    --     vim.api.nvim_create_autocmd("BufWritePost", {
    --       buffer = buffer,
    --       callback = function() vim.cmd.DenolsCache() end,
    --     })
    --   end,
    --   settings = {
    --     deno = {
    --       lint = true,
    --       unstable = true,
    --       suggest = {
    --         imports = {
    --           hosts = {
    --             ["https://deno.land"] = true,
    --             ["https://cdn.nest.land"] = true,
    --             ["https://crux.land"] = true,
    --             ["https://esm.sh"] = true,
    --           },
    --         },
    --       },
    --     },
    --   },
    -- })

    -- web DSL
    -- setup(lspconfig.svelte, {
    --   on_attach = function(client, _)
    --     vim.api.nvim_create_autocmd("BufWritePost", {
    --       pattern = { "*.js", "*.ts" },
    --       callback = function(ctx) client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match }) end,
    --     })
    --     format_config(false)(client)
    --   end,
    --   settings = {
    --     typescript = {
    --       inlayHints = typescriptInlayHints,
    --     },
    --   },
    -- })
    -- setup(lspconfig.astro, { on_attach = format_config(false) })
    -- setup(lspconfig.angularls)
    -- setup(lspconfig.vuels)
    -- setup(lspconfig.prismals)
    setup(lspconfig.gopls, {
      on_attach = format_config(true),
    })

    -- lua
    setup(lspconfig.lua_ls, {
      on_attach = format_config(false),
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        Lua = {
          -- semantic = { enable = false },
          diagnostics = {
            globals = { "vim", "pp" },
          },
          completion = {
            -- showWord = "Disable",
            callSnippet = "Replace",
          },
          workspace = {
            -- library = vim.api.nvim_get_runtime_file("", true),
            -- '/usr/local/share/lua/5.1/?/?.lua',
            -- library = vim.list_extend(My.plugin_paths(), { "/usr/local/share/lua/5.1/" }),
            -- library = vim.tbl_deep_extend("force", vim.api.nvim_get_runtime_file("", true), { }),
            library = require("my").plugin_paths(),
            checkThirdParty = false,
          },
          format = {
            enable = false,
          },
          hint = {
            enable = true,
          },
        },
      },
    })

    -- json
    setup(lspconfig.jsonls, {
      on_attach = format_config(false),
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
          format = { enable = true },
        },
      },
    })

    -- yaml
    setup(lspconfig.yamlls, {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas({
            -- extra = {
            --   {
            --     name = "openAPI 3.0",
            --     url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml",
            --   },
            --   {
            --
            --     name = "openAPI 3.1",
            --     url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml",
            --   },
            -- },
          }),
          validate = true,
          format = { enable = true },
        },
      },
    })

    -- -- swift
    -- setup(lspconfig.sourcekit)
    --
    -- -- ruby
    -- setup(lspconfig.ruby_ls)

    -- -- python
    -- local python_lsp_init = function(_, config)
    --   config.settings.python.pythonPath = vim.env.VIRTUAL_ENV and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
    --     or utils.find_cmd("python3", ".venv/bin", config.root_dir)
    -- end
    -- setup(lspconfig.pyright, { before_init = python_lsp_init })
    -- setup(lspconfig.ruff_lsp, { before_init = python_lsp_init })

    -- -- r
    -- setup(lspconfig.r_language_server)
    --
    -- -- sql
    -- setup(lspconfig.sqlls)
    --
    -- zls
    -- setup(lspconfig.zls)
    -- vim.g.zig_fmt_autosave = 0
  end,
}
