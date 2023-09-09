-- (for neo-tree) Disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Core
-- require('jon.options')
-- require('jon.keymaps')
require('jon.core')
require('jon.lazy')
-- require('jon.plugins')

-- Plugin configs
-- require('jon.configs.telescope')
-- require('jon.configs.treesitter')
-- require('jon.configs.lsp')
-- require('jon.configs.cmp')
-- require('jon.configs.neo-tree')


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
