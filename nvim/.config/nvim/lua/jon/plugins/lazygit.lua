return {
  {
    'kdheepak/lazygit.nvim',
    cond = function()
      return vim.fn.executable 'lazygit' == 1
    end,
  },
}
