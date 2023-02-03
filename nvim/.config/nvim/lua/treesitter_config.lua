require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "go", "gomod", "svelte", "bash", "sql" },
	sync_install = true,
	highlight = {
		enable = true,
		-- there's an issue with lua highlighting right now...
		-- the defualt highlighter is good enough for meeee
		disable = { "lua", "help", "vim" },
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}
