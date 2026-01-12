vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
vim.pack.add({ "https://github.com/kawre/leetcode.nvim" })

vim.pack.add({ "https://github.com/mbbill/undotree" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })

vim.pack.add({ "https://github.com/supermaven-inc/supermaven-nvim" })

vim.pack.add({ "https://github.com/lervag/vimtex" })
vim.g.vimtex_view_method = 'sioyek'

vim.pack.add({ "https://github.com/vimpostor/vim-tpipeline" })
