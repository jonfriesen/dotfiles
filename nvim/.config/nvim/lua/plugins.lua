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

    -- lsp
    use({
        "williamboman/mason.nvim",
        config = function() require("lsp_config") end,
        requires = {
            "williamboman/mason-lspconfig.nvim",
        },
    })
    use({
        "neovim/nvim-lspconfig",
    --     after = "williamboman/mason.nvim",
    })
    use({ "onsails/lspkind-nvim" })

    use({ "Mofiqul/dracula.nvim" })
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({
        "akinsho/bufferline.nvim",
        tag = "v3.*",
        requires = "nvim-tree/nvim-web-devicons",
        config = function() require("bufferline").setup{} end,
    })
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
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config =function () require("treesitter_config") end,
    })
    use({
        "hrsh7th/nvim-cmp",
        config = function() require("cmp_config") end,
        requires = {
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
        },
    })
    use({
        'L3MON4D3/luasnip',
        requires = {
            'rafamadriz/friendly-snippets',
        },
    })
    use({
        -- this plugin requires lazygit to be installed
        "kdheepak/lazygit.nvim",
    })
    use({
        "numToStr/Comment.nvim",
        module = "Comment",
        keys = { "gc", "gb" },
        config = function() require("Comment").setup {} end,
    })
    use({
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end,
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
