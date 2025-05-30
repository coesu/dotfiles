local helpers = require("lars.luasnip-helper-funcs")
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	-- COMMON IMPORTS
	s(
		{ trig = "1pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 1P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "2pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 2P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "3pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 3P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "4pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 4P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "5pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 5P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "6pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 6P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "7pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 7P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "8pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 8P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "9pp", snippetType = "autosnippet" },
		fmt(
			[[
            #== 9P ==
        ]],
			{}
		),
		{ condition = line_begin }
	),
}
