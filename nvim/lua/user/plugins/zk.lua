vim.pack.add({ "https://github.com/zk-org/zk-nvim" })

local zk = require("zk")

zk.setup({

    picker = "fzf",

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

local opts = { noremap=true, silent=false }

-- Create a new note after asking for its title.
vim.api.nvim_set_keymap("n", "<leader>on", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)

-- Open notes.
vim.api.nvim_set_keymap("n", "<leader>os", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Open notes associated with the selected tags.
vim.api.nvim_set_keymap("n", "<leader>ot", "<Cmd>ZkTags<CR>", opts)

-- Search for the notes matching a given query.
vim.api.nvim_set_keymap("n", "<leader>of", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", opts)
-- Search for the notes matching the current visual selection.
vim.api.nvim_set_keymap("v", "<leader>of", ":'<,'>ZkMatch<CR>", opts)
