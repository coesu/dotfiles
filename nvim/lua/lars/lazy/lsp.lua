return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "Saghen/blink.cmp",
        { "mason-org/mason.nvim", opts = {} },
        { "j-hui/fidget.nvim",    opts = {} },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
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
        capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())


        -- vim.lsp.enable('lua_ls')
        -- vim.lsp.enable('pyright')
        -- vim.lsp.enable('rust_analyzer')
        -- vim.lsp.enable('julials')
        local lspconfig = require("lspconfig")

        local servers = {
            pyright = true,
            lua_ls = {
                server_capabilities = {
                    semanticTokensProvider = vim.NIL,
                },
            },
            texlab = true,
            rust_analyzer = true,
            julials = true,
            -- julials = {
            -- 	on_new_config = function(new_config, _)
            -- 		local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
            -- 		new_config.cmd[1] = julia
            -- 		vim.notify("Hello from julials")
            -- 		-- if require("lspconfig").util.path.is_file(julia) then
            -- 		--     vim.notify("Hello from julials")
            -- 		--     new_config.cmd[1] = julia
            -- 		-- else
            -- 		--     vim.notify("Hello! from julials with error")
            -- 		-- end
            -- 	end,
            -- },
        }

        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end
            config = vim.tbl_deep_extend("force", {}, {
                capabilities = capabilities,
            }, config)

            lspconfig[name].setup(config)
        end
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
