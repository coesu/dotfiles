return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- "hrsh7th/cmp-nvim-lsp",
        -- "hrsh7th/cmp-buffer",
        -- "hrsh7th/cmp-path",
        -- "hrsh7th/cmp-cmdline",
        -- "hrsh7th/nvim-cmp",
        -- "L3MON4D3/LuaSnip",
        -- "saadparwaiz1/cmp_luasnip",
        { "j-hui/fidget.nvim", opts = {} },
    },

    config = function()
        -- local cmp = require('cmp')
        -- local cmp_lsp = require("cmp_nvim_lsp")
        -- local capabilities = vim.tbl_deep_extend(
        --     "force",
        --     {},
        --     vim.lsp.protocol.make_client_capabilities(),
        --     cmp_lsp.default_capabilities())
        --
        -- require("fidget").setup({})
        -- require("mason").setup()
        -- require("mason-lspconfig").setup({
        --     ensure_installed = {
        --         "lua_ls",
        --     },
        --     handlers = {
        --         function(server_name) -- default handler (optional)
        --             require("lspconfig")[server_name].setup {
        --                 capabilities = capabilities
        --             }
        --         end,
        --
        --         ["lua_ls"] = function()
        --             local lspconfig = require("lspconfig")
        --             lspconfig.lua_ls.setup {
        --                 capabilities = capabilities,
        --                 settings = {
        --                     Lua = {
        --                         diagnostics = {
        --                             globals = { "vim", "it", "describe", "before_each", "after_each" },
        --                         }
        --                     }
        --                 }
        --             }
        --         end,
        --     }
        -- })
        -- local lspconfig = require"lspconfig"
        -- lspconfig.pyright.setup {}
        -- lspconfig.rust_analyzer.setup {}
        -- lspconfig.lua_ls.setup {}
        --
        --
        -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
        --
        -- cmp.setup({
        --     snippet = {
        --         expand = function(args)
        --             require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        --         end,
        --     },
        --     mapping = cmp.mapping.preset.insert({
        --         ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        --         ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        --         ['<CR>'] = cmp.mapping.confirm({ select = true }),
        --         ["<C-Space>"] = cmp.mapping.complete(),
        -- complete    }),
        --     sources = cmp.config.sources({
        --         { name = 'nvim_lsp' },
        --         { name = 'luasnip' }, -- For luasnip users.
        --     }, {
        --         { name = 'buffer' },
        --     })
        -- })
        --
        -- vim.diagnostic.config({
        --     -- update_in_insert = true,
        --     virtual_text = false,
        --     float = {
        --         focusable = true,
        --         style = "minimal",
        --         border = "rounded",
        --         source = "always",
        --         header = "",
        --         prefix = "",
        --     },
        -- })
        --
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                -- Find references for the word under your cursor.
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

                -- Opens a popup that displays documentation about the word under your cursor
                --  See `:help K` for why this keymap.
                map("K", vim.lsp.buf.hover, "Hover Documentation")

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- local servers = {
        -- 	pyright = {},
        -- 	rust_analyzer = {},
        -- 	lua_ls = {
        -- 		settings = {
        -- 			Lua = {
        -- 				completion = {
        -- 					callSnippet = "Replace",
        -- 					diagnostics = {
        -- 						globals = { "vim", "it", "describe", "before_each", "after_each" },
        -- 					},
        -- 				},
        -- 			},
        -- 		},
        -- 	},
        -- }
        -- local lspconfig = require("lspconfig")
        -- for server, opts in pairs(servers) do
        -- 	lspconfig[server].setup(opts)
        -- end

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", "pyright", "rust_analyzer",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })
    end,
}
