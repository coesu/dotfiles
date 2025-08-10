return {
    "RRethy/base16-nvim",
    config = function()
        vim.cmd("colorscheme base16-gruvbox-dark-hard")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", fg = "#FFFFFF" })
        vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
    end,
}
