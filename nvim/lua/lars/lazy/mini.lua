return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.ai").setup() -- a/i textobjects
		require("mini.jump").setup() -- fFtT work past a line
		local MiniJump2d = require("mini.jump2d").setup({
			view = {
				dim = true,
				n_steps_ahead = 1,
			},
			mappings = {
				start_jumping = "",
			},
		})
		vim.keymap.set("n", "<CR>", "<cmd>:lua MiniJump2d.start(MiniJump2d.builtin_opts.word_start)<cr>")
		require("mini.surround").setup() -- surround
	end,
}
