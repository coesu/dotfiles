vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
})

vim.lsp.config("lua_ls", {
    settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } }
})

vim.lsp.enable({ 'lua_ls', 'julials', 'rust_analyzer', 'texlab', 'clangd', 'pyright', 'ruff' })


local map = vim.keymap.set

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('documentFormattingProvider') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end

        map("n", "gd", FzfLua.lsp_definitions, { desc = "Lsp Definition" })
        map("n", "gr", FzfLua.lsp_references, { desc = "Lsp References" })
        map("n", "gI", FzfLua.lsp_implementations)
        map("n", "<leader>D", FzfLua.lsp_typedefs)
        map("n", "<leader>ca", FzfLua.lsp_code_actions)
        map("n", "<leader>ws", FzfLua.lsp_live_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
        map("n", "gD", FzfLua.lsp_declarations)
    end,
})
