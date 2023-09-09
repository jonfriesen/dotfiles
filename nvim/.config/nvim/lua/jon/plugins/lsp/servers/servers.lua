return {
  gopls = {
    cmd = { 'gopls', '--remote=auto' },
    gopls = {
      -- I use these build tags commonly though it'd be nice to be able
      -- to set it on a project to project basis...
      buildFlags = { "-tags=e2e integration sandbox" },
      completeUnimported = true,
      staticcheck = true,
      -- gofumpt = true,
      -- analyses = {
      -- 	unusedparams = true,
      -- },
    },
  },
  golangci_lint_ls = {},
  bashls = {},
  jsonls = {},
  yamlls = {},
  sqlls = {},
  tsserver = {},
  svelte = {},
  tailwindcss = {},
  lua_ls = {
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}
