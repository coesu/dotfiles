local bufnr = 17

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("executePythonoranythingelse", {clear = true}),
    pattern = "autosave.lua",
    callback = function()
        vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { "hello", "world"})

    end,
})
