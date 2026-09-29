return {
	"rest-nvim/rest.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<leader>Rs", "<cmd>Rest run<cr>", desc = "[S]end Request" },
		{ "<leader>Rr", "<cmd>Rest last<cr>", desc = "[R]eplay Last Request" },
		{ "<leader>Ro", "<cmd>Rest open<cr>", desc = "[O]pen Result Pane" },
		{
			"<leader>Re",
			function()
				require("telescope").extensions.rest.select_env()
			end,
			desc = "Select [E]nvironment",
		},
	},
	ft = { "http" },
	config = function()
		require("telescope").load_extension("rest")
	end,
}
