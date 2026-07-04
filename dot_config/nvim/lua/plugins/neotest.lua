return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"mrcjkb/rustaceanvim",
		"fredrikaverpil/neotest-golang",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
	},
	keys = {
		{
			"<leader>nr",
			function()
				require("neotest").run.run()
			end,
			desc = "Neotest [R]un Nearest",
		},
		{
			"<leader>nf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Neotest Run [F]ile",
		},
		{
			"<leader>na",
			function()
				require("neotest").run.run(vim.uv.cwd())
			end,
			desc = "Neotest Run [A]ll",
		},
		{
			"<leader>ns",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Neotest [S]ummary",
		},
		{
			"<leader>no",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Neotest [O]utput",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("rustaceanvim.neotest"),
				require("neotest-golang"),
				require("neotest-vitest"),
				require("neotest-jest"),
			},
		})
	end,
}
