local helpers = require("lars.luasnip-helper-funcs")
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	s(
		{ trig = "pp", snippetType = "autosnippet" },
		fmta(
			[[
      std::cout <<<< <> <<<< "\n";
      ]],
			{
				i(1),
			}
		),
		{ condition = line_begin }
	),
	s(
		{ trig = "ccout", snippetType = "autosnippet" },
		fmta(
			[[
      std::cout <<<< <> <<<< std::endl;
      ]],
			{
				i(1),
			}
		),
		{ condition = line_begin }
	),
}
