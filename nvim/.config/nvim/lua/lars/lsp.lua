local lsp = require('lsp-zero').preset({
    manage_nvim_cmp = {
        set_sources = 'recommended'
    }
})


lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

lsp.setup()
local cmp = require('cmp')
local cmp_select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-k>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item(cmp_select_opts)
            else
                cmp.complete()
            end
        end),
        ['<C-j>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item(cmp_select_opts)
            else
                cmp.complete()
            end
        end),
    },
})

vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false
})

-- local lsp = require('lsp-zero').preset({
--   name = 'recommended',
--   set_lsp_keymaps = true,
--   manage_nvim_cmp = true,
--   suggest_lsp_servers = true,
-- })
-- local cmp = require('cmp')
-- --local cmp_select = {behavior = cmp.SelectBehaviour.Select}
-- lsp.setup_nvim_cmp({
--     -- preselect = 'none',
--     -- completion = {
--     --     completeopt = 'menu,menuone,noinsert,noselect'
--     -- },
--     mapping = lsp.defaults.cmp_mappings ({
--     ['<C-d>'] = cmp.mapping.scroll_docs( -4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete {},
--     ['<CR>'] = cmp.mapping.confirm {
--         behavior = cmp.ConfirmBehavior.Replace,
--         select = false,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--             cmp.select_next_item()
--         else
--             fallback()
--         end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--         if cmp.visible() then
--             cmp.select_prev_item()
--         else
--             fallback()
--         end
--     end, { 'i', 's' }),
--     })
-- })
-- lsp.setup()
-- vim.diagnostic.config({
--     virtual_text = false,
--     signs = false,
--     update_in_insert = false,
--     underline = true,
--     severity_sort = true,
--     float = {
--         focusable = false,
--         style = 'minimal',
--         border = 'rounded',
--         source = 'always',
--         header = '',
--         prefix = '',
--     },
-- })
--
-- require("lspconfig")["texlab"].setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- })
--
--
