vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
vim.api.nvim_command("packadd packer.nvim")
-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_setup(name)
  return string.format('require("setup/%s")', name)
end

return require("packer").startup({
  function(use)
    -- Packer can manage itself
    use({ "wbthomason/packer.nvim" })

    -- Mason is a lsp/formatter/linter/debugger package manager.
    -- It needs to be used in conjunction with other plugins like
    -- mason-lspconfig. 
    use({
        "williamboman/mason.nvim",
        config = function() require("lsp_config") end,
        requires = {
            "williamboman/mason-lspconfig.nvim",
        },
    })
    -- Manages LSP configs
    use({
        "neovim/nvim-lspconfig",
        requires = {
            "j-hui/fidget.nvim",
        },
    })
    -- Adds pretty symbols in the lsp autocompletion to indicate
    -- the difference between variables, functions, etc
    use({ "onsails/lspkind-nvim" })

    -- Themeh
    use({ "Mofiqul/dracula.nvim" })
    -- Styled status line
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    -- Shows ui line with all of the open vim buffers at the telescope
    -- of the window.
    use({
        "akinsho/bufferline.nvim",
        tag = "v3.*",
        requires = "nvim-tree/nvim-web-devicons",
        config = function() require("bufferline").setup{} end,
    })
    -- The ultimate searching tool.
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            -- this allows live_grep and grep_string to work
            -- requires ripgrep to be installed, eg:
            --  $ brew install ripgrep
            "BurntSushi/ripgrep"
        },
    })
    -- Adds better syntax highlighting than the default
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config =function () require("treesitter_config") end,
    })
    -- Completion interface. The required packages within this
    -- block offer things like filesystem path, buffer, and lsp completion.
    use({
        "hrsh7th/nvim-cmp",
        config = function() require("cmp_config") end,
        requires = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
    })
    -- snippets
    -- I don't think this is working?
    use({
        'L3MON4D3/luasnip',
        requires = {
            'rafamadriz/friendly-snippets',
        },
    })
    -- lazy git interface, looks similar to vscodes src control interface.
    use({
        -- this plugin requires lazygit to be installed
        "kdheepak/lazygit.nvim",
    })
    -- Easily adds group/block commenting
    use({
        "numToStr/Comment.nvim",
        module = "Comment",
        keys = { "gc", "gb" },
        config = function() require("Comment").setup {} end,
    })
    -- Completes common pairs, eg. {}, "", []...
    use({
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end,
    })
    -- nvim-tree is a file explorer
    use({
        "nvim-tree/nvim-tree.lua",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function() require("nvim-tree").setup() end,
    })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    display = {
      open_fn = require("packer.util").float,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
})
