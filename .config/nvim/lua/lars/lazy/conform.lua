return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				python = { "isort", "ruff_fix", "ruff_format" },
				lua = { "stylua" },
				json = { "prettier" },
				htlm = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				css = { "prettier" },
				nix = { "nixfmt" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = true,
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			conform.format({
				lsp_fallback = true,
				async = true,
			})
		end, { desc = "Format file" })
	end,
}
