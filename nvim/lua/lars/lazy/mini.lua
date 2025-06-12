return {
    "echasnovski/mini.nvim",
    config = function()
        require("mini.ai").setup() -- a/i textobjects
        require("mini.surround").setup() -- surround
    end,
}
