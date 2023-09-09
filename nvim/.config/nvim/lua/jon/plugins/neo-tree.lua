return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local status_ok, neo_tree = pcall(require, "neo-tree")
			if not status_ok then
				vim.notify("Neotree not found")
				return
			end

			-- (for neo-tree) Disable netrw at the very start of your init.lua (strongly advised)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			neo_tree.setup({
				close_if_last_window = false,
				enable_diagnostics = false,
				popup_border_style = "rounded",
				enable_git_status = true,
				source_selector = {
					winbar = true,
					content_layout = "center",
					sources = {
						{ source = "filesystem", display_name = " 󰉓 Files " },
						{ source = "buffers", display_name = " ➜ Buffs " },
						{ source = "git_status", display_name = " 󰊢 Git " },
					},
				},
				default_component_configs = {
					indent = {
						padding = 0,
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "",
					},
					git_status = {
						symbols = {
							added = "",
							deleted = "",
							modified = "",
							renamed = "",
							untracked = "",
							ignored = "",
							unstaged = "",
							staged = "",
							conflict = "",
						},
					},
				},
				window = {
					width = 30,
					mappings = {
						["o"] = "open",
						["v"] = "open_vsplit",
					},
				},
				filesystem = {
					follow_current_file = true,
					hijack_netrw_behavior = "open_current",
					use_libuv_file_watcher = true,
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = true,
					},
				},
				event_handlers = {
					{
						event = "neo_tree_buffer_enter",
						handler = function(_)
							vim.opt_local.signcolumn = "auto"
						end,
					},
				},
			})
		end,
	},
}
