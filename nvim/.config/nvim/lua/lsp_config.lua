-- huge shoutout to bashbunni for this section 
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- leaving only what I actually use...
	buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
	buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

	buf_set_keymap("n", "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

	buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>", opts)
	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>ca", "<cmd>Telescope lsp_code_actions<CR>", opts)
	buf_set_keymap("n", "gt", "<cmd> lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "gi", "<cmd> lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<leader>dj", "<cmd> lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>dk", "<cmd> lua vim.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", opts)
	buf_set_keymap("n", "<leader>r", "<cmd> lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<leader>ca", "<cmd> lua vim.lsp.buf.code_action()<CR>", opts)

		vim.cmd([[
			augroup formatting
				autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                autocmd BufWritePre <buffer> lua OrganizeImports(150)
			augroup END
		]])

	-- Set autocommands conditional on server_capabilities
		vim.cmd([[
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]])
end

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "sumneko_lua",
        "gopls",
        "golangci_lint_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "sqlls",
        "tsserver",
        "svelte",
        "tailwindcss",
    },
})

-- LSP options and configs can be found here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim', 'a' }
            }
        }
    }
}

lspconfig.gopls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
        debounce_text_change = 150,
    },
    settings = {
        gopls = {
            -- I use this build tag commonly though it'd be nice to be able
            -- to set it on a project to project basis...
            buildFlags = { "-tags=e2e" },
        },
    },
}


lspconfig.golangci_lint_ls.setup{
	capabilities = capabilities,
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
}

lspconfig.bashls.setup{}

lspconfig.jsonls.setup{}

lspconfig.yamlls.setup{}

lspconfig.sqlls.setup{}

lspconfig.tsserver.setup{}

lspconfig.svelte.setup{}

lspconfig.tailwindcss.setup{}

-- Fidget needs to be loaded after the lsp's are setup
require("fidget").setup{}

-- organize imports (thanks bashbunni)
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function OrganizeImports(timeoutms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeoutms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end
