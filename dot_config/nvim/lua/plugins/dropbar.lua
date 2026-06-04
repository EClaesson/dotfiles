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
			desc = "Pick Symbols in Winbar",
		},
	},
	config = function()
		vim.ui.select = require("dropbar.utils.menu").select
	end,
}
