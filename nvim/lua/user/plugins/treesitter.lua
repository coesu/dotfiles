vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "vimdoc",
        "c",
        "cpp",
        "lua",
        "rust",
        "bash",
        "python",
        "nix",
        "markdown",
        "markdown_inline",
        "julia",
    },
    sync_install = false,
    modules = {},
    ignore_install = {},
    auto_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
    },
    indent = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<M-o>",
            scope_incremental = "<M-O>",
            node_incremental = "<M-o>",
            node_decremental = "<M-i>",
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                -- You can also add custom ones
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },

})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.latex = {
    install_info = {
        -- The path to your local grammar folder
        url = "~/.local/share/nvim/tree-sitter-latex",
        files = { "src/parser.c" }, -- add "src/scanner.c" if your grammar has one
        -- Crucial: Tell Neovim NOT to run 'tree-sitter generate'
        requires_generate_from_grammar = false,
    },
    filetype = "tex",
}
