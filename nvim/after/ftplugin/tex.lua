-- Set local options for LaTeX files
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true

-- Set VimTeX options
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_quickfix_mode = 0

-- Set concealment options
vim.opt_local.conceallevel = 2
vim.g.tex_conceal = "abdmg"

-- Add any custom keymappings for LaTeX files
vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<CR>", { buffer = true })
vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<CR>", { buffer = true })

vim.keymap.set({ "i", "n" }, "<M-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { buffer = true })
