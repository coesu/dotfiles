vim.pack.add({
    "https://github.com/folke/sidekick.nvim",
    "https://github.com/folke/noice.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/folke/sidekick.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/folke/snacks.nvim",
})

require("snacks").setup({ picker = { enabled = true }, })

require("sidekick").setup({
    cli = {
        mux = {
            backend = "tmux",
            enabled = true,
        },
    },
})


require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
    },

    popupmenu = { enabled = true, backend = "nui", },
})

require("which-key").setup({
    preset = "helix",
    debug = vim.uv.cwd():find("which%-key"),
})


local map = vim.keymap.set

local sidekick = require("sidekick")
local cli = require("sidekick.cli")

map("n", "<tab>", function()
    if not sidekick.nes_jump_or_apply() then
        return "<Tab>"
    end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

map({ "n", "t", "i", "x" }, "<C-s>", function()
    cli.toggle()
end, { desc = "Sidekick Toggle" })

map("n", "<leader>aa", function()
    cli.toggle()
end, { desc = "Sidekick Toggle CLI" })

map("n", "<leader>as", function()
    cli.select()
end, { desc = "Select CLI" })

map("n", "<leader>ad", function()
    cli.close()
end, { desc = "Detach a CLI Session" })

map({ "x", "n" }, "<leader>at", function()
    cli.send({ msg = "{this}" })
end, { desc = "Send This" })

map("n", "<leader>af", function()
    cli.send({ msg = "{file}" })
end, { desc = "Send File" })

map("x", "<leader>av", function()
    cli.send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

map({ "n", "x" }, "<leader>ap", function()
    cli.prompt()
end, { desc = "Sidekick Select Prompt" })

map("n", "<leader>ac", function()
    cli.toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Toggle Claude" })
