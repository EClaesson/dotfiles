return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		},
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<Leader>;",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Pick symbols in winbar",
		},
		{
			"[;",
			function()
				require("dropbar.api").goto_context_start()
			end,
			desc = "Go to start of current context",
		},
		{
			"];",
			function()
				require("dropbar.api").select_next_context()
			end,
			desc = "Select next context",
		},
	},
	config = function()
		vim.ui.select = require("dropbar.utils.menu").select
	end,
}
