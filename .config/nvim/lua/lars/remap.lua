vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { silent = true })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { silent = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true })

-- Splits
vim.keymap.set("n", "<leader>-", "<cmd>split<CR>", { desc = "split" })
vim.keymap.set("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "split" })

-- resize
vim.keymap.set("n", "<S-C-j>", "<cmd>resize +10<CR>")
vim.keymap.set("n", "<S-C-k>", "<cmd>resize -10<CR>")
vim.keymap.set("n", "<S-C-h>", "<cmd>vertical resize -10<CR>")
vim.keymap.set("n", "<S-C-l>", "<cmd>vertical resize +10<CR>")

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
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- running code
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(args)
		local file = vim.fn.expand("%")
		vim.keymap.set(
			"n",
			"<leader>r",
			'<cmd>!tmux send-keys -t 1 "python ' .. file .. '" Enter<CR><CR>',
			{ buffer = args.buf }
		)
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "rust",
	callback = function(args)
		vim.keymap.set("n", "<leader>r", '<cmd>!tmux send-keys -t 1 "cargo run" Enter<CR><CR>', { buffer = args.buf })
	end,
})
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "python",
-- 	callback = function(args)
-- 		local file = vim.fn.expand("%")
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>r",
-- 			"<cmd>!zellij run -d right -- python " .. file .. " Enter<CR><CR>",
-- 			{ buffer = args.buf, silent = true }
-- 		)
-- 	end,
-- })
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "rust",
-- 	callback = function(args)
-- 		vim.keymap.set("n", "<leader>r", "<cmd>!zellij run -d right -- cargo run Enter<CR><CR>", { buffer = args.buf })
-- 	end,
-- })
