local helpers = require("user.luasnip-helper-funcs")
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local tex = {}
tex.in_mathzone = require("user/detect-mathzone").in_mathzone
tex.in_text = function()
	return not tex.in_mathzone()
end
tex.in_tikz = function()
	local is_inside = vim.fn["vimtex#env#is_inside"]("tikzpicture")
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

return {
	s(
		{ trig = "tl", snippetType = "autosnippet" },
		fmta(
			[[
            \node[ltensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "ltl", snippetType = "autosnippet" },
		fmta(
			[[
            \node[ltensor, label=\(<>\)]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2), i(3) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "tr", snippetType = "autosnippet" },
		fmta(
			[[
            \node[rtensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "ltr", snippetType = "autosnippet" },
		fmta(
			[[
            \node[rtensor, label=\(<>\)]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2), i(3) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "tw", snippetType = "autosnippet" },
		fmta(
			[[
            \node[wtensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "ltw", snippetType = "autosnippet" },
		fmta(
			[[
            \node[widetensor, label=\(<>\)]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2), i(3) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "te", snippetType = "autosnippet" },
		fmta(
			[[
            \node[etensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "lte", snippetType = "autosnippet" },
		fmta(
			[[
            \node[etensor, label=\(<>\)]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2), i(3) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "to", snippetType = "autosnippet" },
		fmta(
			[[
            \node[notensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "ta", snippetType = "autosnippet" },
		fmta(
			[[
            \node[atensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "lta", snippetType = "autosnippet" },
		fmta(
			[[
            \node[atensor, label=\(<>\)]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2), i(3) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "td", snippetType = "autosnippet" },
		fmta(
			[[
            \node[dtensor]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "ltd", snippetType = "autosnippet" },
		fmta(
			[[
            \node[dtensor, label=\(<>\)]    (A<>) at (<>) {};
        ]],
			{ i(1), i(2), i(3) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "indr", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.east) -- +(0.5, 0) node[right, idx_label] {$<>$};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "indl", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.west) -- +(-0.5, 0) node[left, idx_label] {$<>$};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "indu", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.north) -- +(0, 0.5) node[above, idx_label] {$<>$};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "indb", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.south) -- +(0, -0.5) node[below, idx_label] {$<>$};
        ]],
			{ i(1), i(2) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "drr", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.east) -- +(0.5, 0);
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "drl", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.west) -- +(-0.5, 0);
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "dru", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.north) -- +(0, 0.5);
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "drd", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>.south) -- +(0, -0.5);
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "drc", snippetType = "autosnippet" },
		fmta(
			[[
            \draw (A<>) --
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "dco", snippetType = "autosnippet" },
		fmta(
			[[
            (A<>) --
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "dce", snippetType = "autosnippet" },
		fmta(
			[[
            (A<>);
        ]],
			{ i(1) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "rcl", snippetType = "autosnippet" },
		fmta(
			[[
            \draw[rounded corners] (<>) -- +(-0.5, 0) -- +(-0.5, -2) -- <>;
        ]],
			{ i(1), c(2, { t("+(0, -2)"), i(nil, "()") }) }
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "rcr", snippetType = "autosnippet" },
		fmta(
			[[
            \draw[rounded corners] (<>) -- +(0.5, 0) -- +(0.5, -2) -- <>;
        ]],
			{ i(1), c(2, { t("+(0, -2)"), i(nil, "()") }) }
		),
		{ condition = tex.in_tikz }
	),
	-- Index notations
	s(
		{ trig = "idu", snippetType = "autosnippet" },
		fmta(
			[[
            node[above, idx_label] {$j$}
        ]],
			{}
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "idr", snippetType = "autosnippet" },
		fmta(
			[[
            node[right, idx_label] {$j$}
        ]],
			{}
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "idd", snippetType = "autosnippet" },
		fmta(
			[[
            node[below, idx_label] {$j$}
        ]],
			{}
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "idl", snippetType = "autosnippet" },
		fmta(
			[[
            node[left, idx_label] {$j$}
        ]],
			{}
		),
		{ condition = tex.in_tikz }
	),
	s(
		{ trig = "ttk", snippetType = "autosnippet" },
		fmta(
			[[
        \begin{tikzpicture}[tensornetwork]
            <>
        \end{tikzpicture}
      ]],
			{
				i(0),
			}
		)
	),
}
