return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Telescope git files" })
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Telescope grep search word" })
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Telescope grep search word" })
        vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Telescope help tags" })

        vim.keymap.set('n', '<leader>tk', builtin.keymaps, { desc = "Telescope keymaps" })
    end
}
