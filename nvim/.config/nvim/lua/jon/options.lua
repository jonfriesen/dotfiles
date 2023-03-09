-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Set relative line numbering
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Number of spaces a tab counts as
vim.o.tabstop = 4

-- Auto adds shift size when closing parens or visual shifts
vim.o.shiftwidth = 4

-- Amount a tab counts for when mixed with spaces (ew?)
vim.o.softtabstop = 4

-- Don't expand tabs to spaces
vim.o.expandtab = false

-- Adds cursor line
vim.o.cursorline = true

-- Auto reload changed files in their buffer
vim.o.autoread = true

-- Keep all folds open when changing buffers
vim.o.foldlevelstart = 99

-- Keep 7 lines on the screen above/below cursor
vim.o.scrolloff = 7

-- No swap or backup files
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

-- Set clip board
vim.o.clipboard = 'unnamedplus'
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
