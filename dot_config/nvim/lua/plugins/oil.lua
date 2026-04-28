return {
	"stevearc/oil.nvim",
	dependencies = {
		{ "nvim-mini/mini.icons" },
		{
			"malewicz1337/oil-git.nvim",
			opts = {
				show_file_highlights = true,
				show_directory_highlights = false,
				show_ignored_files = true,
			},
		},
		{
			"JezerM/oil-lsp-diagnostics.nvim",
			opts = {},
		},
	},
	lazy = false,
	keys = {
		{ "ö", "<cmd>Oil<cr>", desc = "Open Oil (current dir)" },
		{
			"Ö",
			function()
				require("oil").open(vim.uv.cwd())
			end,
			desc = "Open Oil (cwd)",
		},
	},
	opts = {
		default_file_explorer = true,
		columns = {
			"icon",
		},
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			natural_order = true,
			case_insensitive = true,
		},
	},
}
