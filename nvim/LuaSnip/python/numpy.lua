local helpers = require("lars.luasnip-helper-funcs")
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {
	-- NP.LOADTXT
	s(
		{ trig = "nlt", snippetType = "autosnippet" },
		fmta(
			[[
          np.loadtxt(<>)
        ]],
			{
				d(1, get_visual),
			}
		)
	),
	-- NP.LINSPACE
	s(
		{ trig = "nlp", snippetType = "autosnippet" },
		fmta(
			[[
          np.linspace(<>)
        ]],
			{
				d(1, get_visual),
			}
		)
	),
	-- NP.ZEROS_LIKE
	s(
		{ trig = "nzl", snippetType = "autosnippet" },
		fmta(
			[[
          np.zeros_like(<>)
        ]],
			{
				d(1, get_visual),
			}
		)
	),
	-- NP.ZEROS
	s(
		{ trig = "npz", snippetType = "autosnippet" },
		fmta(
			[[
          np.zeros(<>)
        ]],
			{
				d(1, get_visual),
			}
		)
	),
}
