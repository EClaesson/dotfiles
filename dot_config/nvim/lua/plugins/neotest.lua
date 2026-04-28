return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"mrcjkb/rustaceanvim",
	},
	keys = {
		{
			"<leader>nr",
			function()
				require("neotest").run.run()
			end,
			desc = "[N]eotest [R]un nearest",
		},
		{
			"<leader>nf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "[N]eotest run [F]ile",
		},
		{
			"<leader>ns",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "[N]eotest [S]ummary",
		},
		{
			"<leader>no",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "[N]eotest [O]utput",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("rustaceanvim.neotest"),
			},
		})
	end,
}
