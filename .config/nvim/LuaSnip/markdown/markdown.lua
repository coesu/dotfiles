local helpers = require('lars.luasnip-helper-funcs')
local get_visual = helpers.get_visual

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return
{
    -- TODO NOTE
    s({ trig = "TODOO", snippetType = "autosnippet" },
        {
            t("**TODO:** "),
        }
    ),
    -- LINK; CAPTURE TEXT IN VISUAL
    s({ trig = "LL", wordTrig = true, snippetType = "autosnippet" },
        fmta(
            [[[<>](<>)]],
            {
                d(1, get_visual),
                i(2),
            }
        )
    ),
    -- LINK; CAPTURE URL IN VISUAL
    s({ trig = "LU", wordTrig = true, snippetType = "autosnippet" },
        fmta(
            [[[<>](<>)]],
            {
                i(1),
                d(2, get_visual),
            }
        )
    ),
    -- BOLDFACE TEXT
    s({ trig = "tbb", snippetType = "autosnippet" },
        fmta(
            [[**<>**]],
            {
                d(1, get_visual),
            }
        )
    ),
    -- ITALIC TEXT
    s({ trig = "tii", snippetType = "autosnippet" },
        fmta(
            [[*<>*]],
            {
                d(1, get_visual),
            }
        )
    ),
    -- UNDERLINED TEXT
    s({ trig = "uu", snippetType = "autosnippet" },
        fmt(
            [[<u>{}</u>]],
            {
                d(1, get_visual),
            }
        )
    ),
    s({ name = "Inline Maths", trig = "mm", snippetType = "autosnippet" },
        fmta(
            "<>$<>$",
            {
                -- Function node just inserts regex capture groups from
                -- snippet’s trigger back into the snippet body.
                f(function(_, snip) return snip.captures[1] end),
                -- Allows to implement visual selection.
                -- :help luasnip-dynamicnode
                d(1, get_visual)
            }
        )
    ),

    s({ name = "Display Maths", trig = "dm", snippetType = "autosnippet" },
        fmta(
            "<>$$ <> $$ <>",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
                i(0)
            }
        )
    ),

    s({ name = "Align Math", trig = "alm", snippetType = "autosnippet" },
        fmta([[
                <>
                $$
                \begin{align}
                    <>
                \end{align}
                $$
                <>
                ]],
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
                i(0)
            }
        )
    ),

    s({ name = "Cases Math", trig = "csm", snippetType = "autosnippet" },
        fmta([[
                <>
                $$
                \begin{cases}
                    <>
                \end{cases}
                $$
                <>
                ]],
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
                i(0)
            }
        )
    ),

    s({ name = "Align Math", trig = "alim", snippetType = "autosnippet" },
        fmta([[
                <>
                $$
                \begin{align}
                    <>
                \end{align}
                $$
                <>
                ]],
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
                i(0)
            }
        )
    ),

    s({ name = "Q&A", trig = "qa", snippetType = "autosnippet" },
        fmta([[
                    **Q<>:** <>
                    **A:** <>

                    *Answer:*
                ]],
            {
                i(1),
                d(2, get_visual),
                i(3),
            }
        )
    ),

    s({ name = "File Link", trig = "fll", snippetType = "autosnippet" },
        fmta(
            "[[./<>|<>]]",
            {
                i(1),
                d(2, get_visual)
            }
        )
    ),
}
