-- mappings
vim.g.mapleader = ' '
vim.o.clipboard = 'unnamedplus'

local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

-- remap esc
key_mapper('i', 'jk', '<ESC>')
key_mapper('v', 'jk', '<ESC>')

-- breaking bad habits :')
key_mapper('', '<up>', '<nop>')
key_mapper('', '<down>', '<nop>')
key_mapper('', '<left>', '<nop>')
key_mapper('', '<right>', '<nop>')

-- opens Explore
key_mapper('n', '<leader>pv', '<cmd>Ex<CR>')

-- telescope
key_mapper('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find hidden=true<CR>')
key_mapper('n', '<leader>ff', '<cmd>Telescope find_files hidden=true<CR>')
key_mapper('n', '<leader>fg', '<cmd>Telescope live_grep hidden=true<CR>')
key_mapper('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
key_mapper('n', '<leader>fh', '<cmd>Telescope help_tags<CR>')

-- lazygit
key_mapper('n', '<leader>gg', '<cmd>LazyGit<CR>')

-- nvim-tree
key_mapper('n', '<leader>tt', '<cmd>NvimTreeToggle<CR>')
key_mapper('n', '<leader>ttf', '<cmd>NvimTreeFindFile<CR>')
