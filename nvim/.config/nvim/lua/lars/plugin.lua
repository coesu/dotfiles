local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)



local plugins = {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    'folke/tokyonight.nvim',
    { "nvim-treesitter/nvim-treesitter", lazy = false, }, --, build = ":TSUpdate"},
    'theprimeagen/harpoon',
    'mbbill/undotree',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-omni'},

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
        
    },
    'lervag/vimtex',
    'windwp/nvim-autopairs',
    'christoomey/vim-tmux-navigator',
    "nvim-lualine/lualine.nvim",
    "terrortylor/nvim-comment",
    "folke/zen-mode.nvim",
    -- "ggandor/leap.nvim",
    -- "ggandor/flit.nvim",
    "akinsho/bufferline.nvim",
    "kdheepak/lazygit.nvim",
}

local opts = {}

require("lazy").setup(plugins, opts)
