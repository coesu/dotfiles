local function build_blink(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
        vim.notify('Building blink.cmp', vim.log.levels.INFO)
        print(ev.data.path)
        local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
        if obj.code == 0 then
            vim.notify('Building blink.cmp done', vim.log.levels.INFO)
        else
            vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
        end
    end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = build_blink })
vim.pack.add({ "https://github.com/saghen/blink.cmp" })

require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-o>"] = { "select_and_accept" },

        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
    },


    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },

    },
    fuzzy = { implementation = "rust" },
    cmdline = { enabled = true },
    completion = {
    }
})
