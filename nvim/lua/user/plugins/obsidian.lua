vim.pack.add({
    "https://github.com/epwalsh/obsidian.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
})

require("obsidian").setup({
    workspaces = {
        {
            name = "main",
            path = "~/Syncthing/obsidian",
        },
    },
    notes_subdir = "notes",
    new_notes_location = "notes_subdir",
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
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            print("nil")
            for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
            end
        end
        return tostring(os.time()) .. "-" .. suffix
    end,
})
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Open today's obsidian note" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<CR>", { desc = "Open yesterday's obsidian note" })
vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianTomorrow<CR>", { desc = "Open tomorrow's obsidian note" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianRename<CR>", { desc = "Obsidian Rename note" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { desc = "Obsidian Create new note" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open in Obsidian" })
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Obsidian Open Backlinks" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Obsidian QuickSwitch" })
