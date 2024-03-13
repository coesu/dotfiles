return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- opts = {
    --     workspaces = {
    --         {
    --             name = "main",
    --             path = "~/Nextcloud/obsidian",
    --         },
    --     },
    --     templates = {
    --         subdir = "templates",
    --         date_format = "%Y-%m-%d",
    --         time_format = "%H:%M",
    --         -- A map for custom variables, the key should be the variable and the value a function
    --         substitutions = {},
    --     },
    --     daily_notes = {
    --         folder = "notes/daily",
    --         -- template = "daily.md",
    --     },
    -- },
    config = function()
        require("obsidian").setup({
            workspaces = {
                {
                    name = "main",
                    path = "~/Nextcloud/obsidian",
                },
            },
            templates = {
                subdir = "templates",
                date_format = "%Y-%m-%d",
                time_format = "%H:%M",
                -- A map for custom variables, the key should be the variable and the value a function
                substitutions = {},
            },
            daily_notes = {
                folder = "notes/daily",
                -- template = "daily.md",
            },
        })
        vim.keymap.set('n', '<leader>ot', "<cmd>ObsidianToday<CR>", { desc = "Open today's obsidian note" })
        vim.keymap.set('n', '<leader>oy', "<cmd>ObsidianYesterday<CR>", { desc = "Open yesterday's obsidian note" })
        vim.keymap.set('n', '<leader>ow', "<cmd>ObsidianTomorrow<CR>", { desc = "Open tomorrow's obsidian note" })
        vim.keymap.set('n', '<leader>or', "<cmd>ObsidianRename<CR>", { desc = "Rename note" })
        vim.keymap.set('n', '<leader>on', "<cmd>ObsidianNew<CR>", { desc = "Create new note" })
        vim.keymap.set('n', '<leader>oo', "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian" })
    end
}
