local helpers = require("lars.luasnip-helper-funcs")
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	-- GENERIC HEADER INCLUDE
	s(
		{ trig = "hh", snippetType = "autosnippet" },
		fmt([[#include <{}>]], {
			d(1, get_visual),
		}),
		{ condition = line_begin }
	),
	-- IOSTREAM HEADER
	s({ trig = "hio", snippetType = "autosnippet" }, { t("#include <iostream>") }, { condition = line_begin }),
}
