-- Formatting (conform.nvim) for markdown.
vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
})

-- FORMATTER: deno fmt (already on PATH, preserves prose) --------------------
local conform = require("conform")

-- deno reads from stdin with `-`; `--ext md` tells it to treat it as markdown.
conform.formatters.deno_fmt = {
    command = "deno",
    args = { "fmt", "--ext", "md", "-" },
    stdin = true,
}

conform.setup({
    formatters_by_ft = {
        markdown = { "deno_fmt" },
    },
    -- Format on save, consistent with the LSP format-on-save in lsp.lua.
    format_on_save = {
        timeout_ms = 1000,
        lsp_format = "never",
    },
})

-- Manual format (uppercase F; <leader>f is taken by fzf files).
vim.keymap.set({ "n", "v" }, "<leader>F", function()
    conform.format({ async = true, lsp_format = "never" })
end, { desc = "[F]ormat buffer" })
