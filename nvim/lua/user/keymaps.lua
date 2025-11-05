vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", vim.cmd.bnext, { silent = true })
vim.keymap.set("n", "<S-h>", vim.cmd.bprevious, { silent = true })

-- Splits
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "split" })
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "split" })

-- resize
vim.keymap.set("n", "<M-j>", "<cmd>resize +10<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>resize -10<CR>")
vim.keymap.set("n", "<M-h>", "<cmd>vertical resize -10<CR>")
vim.keymap.set("n", "<M-l>", "<cmd>vertical resize +10<CR>")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>c", "<cmd>!cat % | wl-copy<CR>", { desc = "Copy file content" })

vim.keymap.set("n", "<leader>r", '<cmd>!tmux send-keys -t 1 Up Enter<CR>')
