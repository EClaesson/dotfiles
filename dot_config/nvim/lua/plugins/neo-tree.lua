return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"antosha417/nvim-lsp-file-operations",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file [E]xplorer" },
	},
	opts = {
		close_if_last_window = true,
		enable_git_status = true,
		enable_diagnostics = true,
		sort_case_insensitive = true,
		window = {
			width = 34,
		},
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignored = false,
			},
			follow_current_file = {
				enabled = true,
			},
		},
	},
}
