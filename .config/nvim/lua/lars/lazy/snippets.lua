return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",

	dependencies = { "rafamadriz/friendly-snippets" },

	config = function()
		-- --------------------------------------------- "
		local ls = require("luasnip")
		local s = ls.snippet
		local sn = ls.snippet_node
		local isn = ls.indent_snippet_node
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node
		local c = ls.choice_node
		local d = ls.dynamic_node
		local r = ls.restore_node
		local events = require("luasnip.util.events")
		local ai = require("luasnip.nodes.absolute_indexer")
		local fmt = require("luasnip.extras.fmt").fmt
		local m = require("luasnip.extras").m
		local lambda = require("luasnip.extras").l
		local postfix = require("luasnip.extras.postfix").postfix
		-----------------------------------------------

		ls.config.set_config({
			-- Don't store snippet history for less overhead
			history = false,
			-- Allow autotrigger snippets
			enable_autosnippets = true,
			-- For equivalent of UltiSnips visual selection
			-- store_selection_keys = "<Tab>",
			-- Event on which to check for exiting a snippet's region
			region_check_events = "InsertEnter",
			delete_check_events = "InsertLeave",
		})
		-- require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })
	end,
}
