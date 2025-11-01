vim.pack.add({
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/christoomey/vim-tmux-navigator",
})

local fzf = require("fzf-lua")

vim.keymap.set("n", "<leader>sh", fzf.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>f", fzf.files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", fzf.builtin, { desc = "[S]earch [S]elect fzf-lua" })
vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", fzf.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<C-P>", fzf.git_files, { desc = "[S]earch git files" })
vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    fzf.grep_curbuf({
        prompt = "Buffer❯ ",
        winopts = { preview = { hidden = true } },
    })
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>sn", function()
    fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })
