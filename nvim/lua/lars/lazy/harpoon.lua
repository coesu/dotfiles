return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },

	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "add file to harpoon" })
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "toggle harpoon menu" })

		vim.keymap.set("n", "<leader>n", function()
			harpoon:list():select(1)
		end, { desc = "select harppon file 1" })
		vim.keymap.set("n", "<leader>e", function()
			harpoon:list():select(2)
		end, { desc = "select harppon file 2" })
		vim.keymap.set("n", "<leader>i", function()
			harpoon:list():select(3)
		end, { desc = "select harppon file 3" })
		vim.keymap.set("n", "<leader>o", function()
			harpoon:list():select(4)
		end, { desc = "select harppon file 4" })
	end,
}
