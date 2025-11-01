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
    auto_install = true,
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
            lookahead = true,             -- Automatically jump forward to textobj
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
