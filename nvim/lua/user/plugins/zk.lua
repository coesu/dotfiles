vim.pack.add({ "https://github.com/zk-org/zk-nvim" })

local zk = require("zk")

zk.setup({

    picker = "select",

    lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
            -- on_attach = ...
            -- etc, see `:h vim.lsp.start()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
            enabled = true,
        },
    },
})
