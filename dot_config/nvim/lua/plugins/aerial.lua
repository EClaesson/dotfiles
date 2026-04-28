return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
	},
	keys = {
		{ "<leader>co", "<cmd>AerialToggle<CR>", desc = "[C]ode [O]utline" },
		{ "<leader>so", "<cmd>Telescope aerial<CR>", desc = "[S]earch [O]utline" },
	},
	config = function()
		require("aerial").setup({
			backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
			layout = {
				default_direction = "float",
			},
			close_on_select = true,
			show_guides = true,
			float = {
				relative = "win",
			},
		})
	end,
}
