return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"j-hui/fidget.nvim",
			tag = "legacy",
			opts = {},
		},

		-- Additional lua configuration, makes nvim stuff amazing
		"folke/neodev.nvim",

		-- Adds pretty symbols in the lsp autocompletion to indicate
		-- the difference between variables, functions, etc
		"onsails/lspkind-nvim",
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local on_attach = function(_, bufnr)
			-- NOTE: Remember that lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself
			-- many times.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
			local nmap = function(keys, func, desc)
				if desc then
					desc = "LSP: " .. desc
				end

				vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
			end

			nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
			nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

			-- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
			nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
			nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
			nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
			nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
			nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

			-- See `:help K` for why this keymap
			nmap("K", vim.lsp.buf.hover, "Hover Documentation")
			nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

			-- Lesser used LSP functionality
			nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
			nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
			nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
			nmap("<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, "[W]orkspace [L]ist Folders")

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.go" },
				callback = function()
					local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
					params.context = { only = { "source.organizeImports" } }

					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
					for _, res in pairs(result or {}) do
						for _, r in pairs(res.result or {}) do
							if r.edit then
								vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
							else
								vim.lsp.buf.execute_command(r.command)
							end
						end
					end
				end,
			})
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local servers = require("jon.plugins.lsp.servers.servers")

		for key, value in pairs(servers) do
			if lspconfig[key] then
				lspconfig[key].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					settings = value,
				})
			end
		end

		-- TODO
		-- this code is from the autoformat.lua and is apparently
		-- not loaded in this new config.
		--
		--
		--
		-- Switch for controlling whether you want autoformatting.
		--  Use :KickstartFormatToggle to toggle autoformatting on or off
		local format_is_enabled = true
		vim.api.nvim_create_user_command("KickstartFormatToggle", function()
			format_is_enabled = not format_is_enabled
			print("Setting autoformatting to: " .. tostring(format_is_enabled))
		end, {})

		-- Create an augroup that is used for managing our formatting autocmds.
		--      We need one augroup per client to make sure that multiple clients
		--      can attach to the same buffer without interfering with each other.
		local _augroups = {}
		local get_augroup = function(client)
			if not _augroups[client.id] then
				local group_name = "kickstart-lsp-format-" .. client.name
				local id = vim.api.nvim_create_augroup(group_name, { clear = true })
				_augroups[client.id] = id
			end

			return _augroups[client.id]
		end

		-- Whenever an LSP attaches to a buffer, we will run this function.
		--
		-- See `:help LspAttach` for more information about this autocmd event.
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach-format", { clear = true }),
			-- This is where we attach the autoformatting for reasonable clients
			callback = function(args)
				local client_id = args.data.client_id
				local client = vim.lsp.get_client_by_id(client_id)
				local bufnr = args.buf

				-- Only attach to clients that support document formatting
				if not client.server_capabilities.documentFormattingProvider then
					return
				end

				-- Tsserver usually works poorly. Sorry you work with bad languages
				-- You can remove this line if you know what you're doing :)
				-- if client.name == 'tsserver' then
				--   return
				-- end

				-- Create an autocmd that will run *before* we save the buffer.
				--  Run the formatting command for the LSP that has just attached.
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = get_augroup(client),
					buffer = bufnr,
					callback = function()
						if not format_is_enabled then
							return
						end

						vim.lsp.buf.format({
							async = false,
							filter = function(c)
								return c.id == client.id
							end,
						})
					end,
				})
			end,
		})
		-- copied code ends
	end,
}
