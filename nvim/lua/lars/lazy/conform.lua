return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- python = { "isort", "ruff_fix", "ruff_format" },
				lua = { "stylua" },
				-- json = { "prettier" },
				-- htlm = { "prettier" },
				-- yaml = { "prettier" },
				-- markdown = { "prettier" },
				-- css = { "prettier" },
				nix = { "alejandra" },
				rust = { "rustfmt" },
				-- cpp = { "clang-format" },
			},
			format_on_save = {
				lsp_fallback = true,
			},
		})
	end,
}
