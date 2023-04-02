-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- LSP Configuration & Plugins
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            {
                'j-hui/fidget.nvim',
                opts = {},
            },

            -- Additional lua configuration, makes nvim stuff amazing
            'folke/neodev.nvim',

            -- Adds pretty symbols in the lsp autocompletion to indicate
            -- the difference between variables, functions, etc
            "onsails/lspkind-nvim",
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer'
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },

    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'nvim-treesitter/nvim-treesitter-context',
        },
        config = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    },

    -- Shows menu of next key action
    {
        'folke/which-key.nvim',
        opts = {},
    },

    -- Git related plugins
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    -- Theme inspired by Atom
    {
        'navarasu/onedark.nvim',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme 'onedark'
        end,
    },

    -- Fancier statusline
    {
        'nvim-lualine/lualine.nvim',
        opts = {
            -- icons_enabled = false,
            theme = 'onedark',
            component_separators = '|',
            section_separators = '',
        },
    },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        opts = {
            char = '┊',
            show_trailing_blankline_indent = false,
        },
    },

    -- "gc" to comment visual regions/lines
    {
        'numToStr/Comment.nvim',
        opts = {},
    },

    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'BurntSushi/ripgrep'
        },
    },

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },

    -- Shows ui line with all of the open vim buffers at the telescope of the window.
    {
        "akinsho/bufferline.nvim",
        version = "v3.*",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {},
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
    },

    -- Completes common pairs, eg. {}, "", []...
    {
        "windwp/nvim-autopairs",
        opts = {},
    },

    -- lazy git interface, looks similar to vscodes src control interface.
    {
        'kdheepak/lazygit.nvim',
        cond = function()
            return vim.fn.executable 'lazygit' == 1
        end,
    },

    -- vim-go convience go commands
    -- {
    --     "fatih/vim-go",
    --     config = function()
    --         -- disable gopls in vim-go because I use the default LSP.
    --         vim.g.go_gopls_enabled = 0
    --     end,
    -- },

    -- github copilot
    {
        "github/copilot.vim",
    },

    -- Testing at the speed of thought.
    {
        'vim-test/vim-test',
    },
    -- load in plugins
    --  Note: this should work to load all plugins in the plugins folders
    --  but it seems to be broken. I'm not sure why.
    --  Once this is fixed, I'll migrate all the custom configs from jon/configs
    --  to this folder.
    -- {
    --     import = 'jon.plugins',
    -- },
    require 'jon.plugins.autoformat',
    require 'jon.plugins.debug',

}, {})
