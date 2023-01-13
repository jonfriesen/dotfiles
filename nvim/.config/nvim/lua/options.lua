vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = false
vim.o.autoread = true
vim.o.mark = true
vim.o.foldlevelstart = 99
vim.o.scrolloff = 7
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.wo.signcolumn = 'yes'

-- numbering
vim.o.number = true
vim.o.relativenumber = true

-- disabling netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- theme
vim.cmd[[colorscheme dracula]]
require('lualine').setup {
	options = {
		theme = 'dracula-nvim',
		-- there's a bug in nvim that makes this an issue for highlighting
		-- in an autocmd. 
		-- ref: https://www.reddit.com/r/neovim/comments/xpp9fc/comment/iqgcidv
		refresh = { statusline = vim.api.nvim_get_option("updatetime") + 100 },
	}
}

-- this was set as part of the indent-blankline plugin
vim.opt.list = true
vim.opt.listchars:append "space:⋅"
