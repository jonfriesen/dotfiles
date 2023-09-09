-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap add jk = esc
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("v", "Jk", "<ESC>")
vim.keymap.set("i", "jK", "<ESC>")
vim.keymap.set("v", "JK", "<ESC>")

-- Breaknig bad habits
vim.keymap.set("n", "<UP>", "<NOP>")
vim.keymap.set("n", "<DOWN>", "<NOP>")
vim.keymap.set("n", "<LEFT>", "<NOP>")
vim.keymap.set("n", "<RIGHT>", "<NOP>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Resize with arrows
vim.keymap.set("n", "<S-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<S-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<S-Right>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<S-Left>", ":vertical resize +2<CR>")

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- LazyGit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")

-- Neotree
vim.keymap.set("n", "<leader>t", "<CMD>NeoTreeShowToggle<CR>")
vim.keymap.set("n", "<leader>tt", "<CMD>NeoTreeFloatToggle<CR>")

-- Note: these aren't working
-- Note: J is used in v/x to join lines
-- Move text up and down
-- vim.keymap.set("v", "<A-j>", ":m .+1<CR>==")
-- vim.keymap.set("v", "<A-k>", ":m .-2<CR>==")
-- vim.keymap.set("v", "p", '"_dP')

-- Move text up and down
-- vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv")
-- vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv")
-- vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv")
-- vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv")
