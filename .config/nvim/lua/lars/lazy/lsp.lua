return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- "williamboman/mason.nvim",
        -- "williamboman/mason-lspconfig.nvim",
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
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

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

        local servers = {
            pyright = {},
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        },
                    },
                },
            },
        }
        local lspconfig = require("lspconfig")
        for server, opts in pairs(servers) do
            lspconfig[server].setup(opts)
        end

        -- require("mason").setup()
        -- require("mason-lspconfig").setup({
        -- 	ensure_installed = {
        -- 	},
        -- 	handlers = {
        -- 		function(server_name) -- default handler (optional)
        -- 			require("lspconfig")[server_name].setup({
        -- 				capabilities = capabilities,
        -- 			})
        -- 		end,
        --
        -- 		["lua_ls"] = function()
        -- 			local lspconfig = require("lspconfig")
        -- 			lspconfig.lua_ls.setup({
        -- 				capabilities = capabilities,
        -- 				settings = {
        -- 					Lua = {
        -- 						diagnostics = {
        -- 							globals = { "vim", "it", "describe", "before_each", "after_each" },
        -- 						},
        -- 					},
        -- 				},
        -- 			})
        -- 		end,
        -- 		["clangd"] = function()
        -- 			local lspconfig = require("lspconfig")
        -- 			lspconfig.clangd.setup({
        -- 				capabilities = capabilities,
        -- 				cmd = { "clangd", "--offset-encoding=utf-16" },
        -- 			})
        -- 		end,
        -- 		["rust_analyzer"] = function()
        -- 			local lspconfig = require("lspconfig")
        -- 			lspconfig.rust_analyzer.setup({
        -- 				capabilities = capabilities,
        -- 				settings = {
        -- 					cargo = {
        -- 						allFeatures = true,
        -- 					},
        -- 					checkOnSave = {
        -- 						command = "clippy",
        -- 					},
        -- 				},
        -- 			})
        -- 		end,
        -- 	},
        -- })
    end,
}
