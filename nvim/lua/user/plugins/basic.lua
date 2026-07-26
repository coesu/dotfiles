vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })

vim.pack.add({ "https://github.com/mbbill/undotree" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })

vim.pack.add({ "https://github.com/lervag/vimtex" })
vim.g.vimtex_view_method = 'zathura'

vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })

vim.pack.add({ "https://github.com/vimpostor/vim-tpipeline" })

vim.pack.add({ 'https://github.com/stevearc/oil.nvim' })
require("oil").setup()


vim.pack.add({'https://github.com/jpalardy/vim-slime.git'})

vim.g.slime_target="tmux"
vim.g.slime_bracketed_paste=1
