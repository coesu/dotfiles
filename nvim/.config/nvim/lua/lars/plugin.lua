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
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true},
    'folke/tokyonight.nvim',
    'rebelot/kanagawa.nvim',
    { "catppuccin/nvim", name = "catppuccin" },
    { "nvim-treesitter/nvim-treesitter", lazy = false, }, --, build = ":TSUpdate"},
    'theprimeagen/harpoon',
    'mbbill/undotree',
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
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
            { 'hrsh7th/cmp-omni' },

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
    -- "akinsho/bufferline.nvim",
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
    },
    -- {
    --     "goolord/alpha-nvim",
    --     config = function()
    --         require('alpha').setup(require 'alpha.themes.startify'.config)
    --     end
    -- },
    { 'luk400/vim-jukit',                lazy = true },
    {
        'vimwiki/vimwiki',
        event = "BufEnter *.md",
        init = function()
            vim.g.vimwiki_global_ext = 0
            vim.g.vimwiki_list = {
                {
                    path             = '~/Nextcloud/vimwiki',
                    syntax           = 'markdown',
                    ext              = '.md',
                    auto_diary_index = 1,
                }
            }
            vim.g.vimwiki_ext2syntax = {
                ['.md'] = 'markdown',
                ['.markdown'] = 'markdown',
                ['.mdown'] = 'markdown',
            }
            vim.g.vimwiki_filetypes = { "md" }
        end
    },

    {
      "epwalsh/obsidian.nvim",
      lazy = true,
      event = {  "BufReadPre /home/lars/Nextcloud/obsidian/**.md"},
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
      -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
      dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
      },
      opts = {
        dir = "~/Nextcloud/obsidian/",  -- no need to call 'vim.fn.expand' here

        -- see below for full list of options 👇
      },
    }
}


local opts = {}

require("lazy").setup(plugins, opts)
