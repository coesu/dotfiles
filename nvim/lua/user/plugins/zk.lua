vim.pack.add({ "https://github.com/zk-org/zk-nvim" })

local zk = require("zk")

zk.setup({

    picker = "fzf_lua",

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

local opts = { noremap = true, silent = false }

-- Create a new note after asking for its title.
vim.api.nvim_set_keymap("n", "<leader>on", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)

-- Open notes.
-- Open notes associated with the selected tags.
vim.api.nvim_set_keymap("n", "<leader>ot", "<Cmd>ZkTags<CR>", opts)

local commands = require("zk.commands")
commands.add("ZkOrphans", function(options)
    options = vim.tbl_extend("force", { orphan = true }, options or {})
    zk.edit(options, { title = "Zk Orphans" })
end)

local fzf = require("fzf-lua")
vim.api.nvim_create_user_command("ZkGrep", function()
    fzf.live_grep_native({
        cwd = vim.env.ZK_NOTEBOOK_DIR,
    })
end, {})

vim.api.nvim_set_keymap("n", "<leader>of", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Search for the notes matching a given query.
vim.api.nvim_set_keymap("n", "<leader>os", "<Cmd>ZkGrep<CR>", opts)
vim.api.nvim_set_keymap("v", "<leader>os", ":'<,'>ZkMatch<CR>", opts)

vim.keymap.set("n", "<leader>oj", function() zk.new({ dir = "journal" }) end, { desc = "New journal note" })


vim.pack.add({
    -- 'https://github.com/nvim-treesitter/nvim-treesitter',
    -- 'https://github.com/nvim-mini/mini.nvim',            -- if you use the mini.nvim suite
    -- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
    -- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
    'https://github.com/jalvesaq/zotcite',
})
require('zotcite').setup({})
