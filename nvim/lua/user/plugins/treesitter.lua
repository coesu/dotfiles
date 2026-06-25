-- nvim-treesitter `main` branch. The `master` branch is archived and breaks on
-- Neovim nightly (its markdown conceal queries call APIs removed from nvim's
-- treesitter runtime). `main` is a full rewrite with a different API: there is
-- no `configs.setup{}`; highlight/indent are enabled per-buffer, and parsers
-- are installed via `install()`.
vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",             version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

require("nvim-treesitter").setup({})

-- The `main` branch ships a supported `latex` parser, so the old custom
-- local-checkout override is gone. The parser is named `latex`; map it onto
-- the `tex` filetype so highlighting kicks in for .tex buffers.
vim.treesitter.language.register("latex", { "tex" })

----------------------------------------------------------------------
-- Install parsers (async; a no-op if already installed)
----------------------------------------------------------------------
require("nvim-treesitter").install({
    "vimdoc", "c", "cpp", "lua", "rust", "bash", "python",
    "nix", "markdown", "markdown_inline", "julia", "latex",
})

----------------------------------------------------------------------
-- Enable highlighting + (experimental) indentation for any buffer that
-- has a parser available. Neovim keeps `:syntax` running alongside the
-- treesitter highlighter, which replicates the old
-- `additional_vim_regex_highlighting = { "markdown" }`.
----------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
            return
        end
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

----------------------------------------------------------------------
-- Text objects (nvim-treesitter-textobjects `main` branch)
----------------------------------------------------------------------
require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true, -- automatically jump forward to textobj
    },
})

local select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)

----------------------------------------------------------------------
-- Incremental selection (removed from the `main` branch; small reimpl.)
----------------------------------------------------------------------
local incsel = {}
do
    local stack = {}

    local function range_eq(a, b)
        return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
    end

    local function visual_select(node)
        local srow, scol, erow, ecol = node:range()
        if ecol == 0 and erow > 0 then
            -- range ends at column 0 of `erow`, i.e. end of the previous line
            erow = erow - 1
            ecol = #vim.api.nvim_buf_get_lines(0, erow, erow + 1, true)[1]
        end
        vim.cmd("normal! \27") -- <Esc>: start from normal mode (works from visual too)
        vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
        vim.cmd("normal! v")
        vim.api.nvim_win_set_cursor(0, { erow + 1, math.max(ecol - 1, 0) })
    end

    function incsel.init()
        local node = vim.treesitter.get_node()
        if not node then return end
        stack = { node }
        visual_select(node)
    end

    function incsel.node_incremental()
        local node = stack[#stack]
        if not node then return incsel.init() end
        local parent = node:parent()
        while parent and range_eq({ parent:range() }, { node:range() }) do
            parent = parent:parent()
        end
        if parent then
            stack[#stack + 1] = parent
            node = parent
        end
        visual_select(node)
    end

    function incsel.node_decremental()
        if #stack > 1 then
            table.remove(stack)
        end
        if stack[#stack] then
            visual_select(stack[#stack])
        end
    end
end

vim.keymap.set("n", "<M-o>", incsel.init, { desc = "Init selection" })
vim.keymap.set("x", "<M-o>", incsel.node_incremental, { desc = "Increment selection" })
vim.keymap.set("x", "<M-O>", incsel.node_incremental, { desc = "Increment selection (scope)" })
vim.keymap.set("x", "<M-i>", incsel.node_decremental, { desc = "Decrement selection" })
