vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    desc = "highlight selection on yank",
    callback = function()
        vim.highlight.on_yank({ timeout = 50, visual = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    command = "wincmd L",
})

vim.api.nvim_create_autocmd('VimResized', {
    command = "wincmd =",
})
