return {
	{
		"saghen/blink.compat",
		lazy = true,
		opts = {},
		config = function()
			-- monkeypatch cmp.ConfirmBehavior for Avante
			require("cmp").ConfirmBehavior = {
				Insert = "insert",
				Replace = "replace",
			}
		end,
	},
	{
		"saghen/blink.cmp",
		lazy = false,
		-- dependencies = { "rafamadriz/friendly-snippets", "yetone/avante.nvim", "folke/noice.nvim" },
		dependencies = { "rafamadriz/friendly-snippets", "yetone/avante.nvim" },

		version = "v0.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config

		opts = {
			keymap = {
				preset = "default",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<C-o>"] = { "select_and_accept" },

				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = {
					"lazydev",
					"lsp",
					"path",
					"snippets",
					"buffer",
					"avante_commands",
					"avante_mentions",
					"avante_files",
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
					avante_commands = {
						name = "avante_commands",
						module = "blink.compat.source",
						score_offset = 90, -- show at a higher priority than lsp
						opts = {},
					},
					avante_files = {
						name = "avante_commands",
						module = "blink.compat.source",
						score_offset = 100, -- show at a higher priority than lsp
						opts = {},
					},
					avante_mentions = {
						name = "avante_mentions",
						module = "blink.compat.source",
						score_offset = 1000, -- show at a higher priority than lsp
						opts = {},
					},
				},
				-- compat = { "avante_commands", "avante_mentions", "avante_files" },
			},

			completion = { accept = { auto_brackets = { enabled = true } } },
			cmdline = {
				keymap = { preset = "inherit" },
				completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
			},
		},
		opts_extend = { "sources.default" },
	},
}
