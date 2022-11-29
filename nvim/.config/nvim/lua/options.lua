vim.o.mouse = a
vim.o.cursorline = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
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
