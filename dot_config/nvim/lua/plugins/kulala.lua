return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>Rs", desc = "[S]end Request" },
		{ "<leader>Ra", desc = "Send [A]ll Requests" },
		{ "<leader>Rb", desc = "Open Scratchpad [B]uffer" },
	},
	ft = { "http", "rest" },
	opts = {
		global_keymaps = true,
		global_keymaps_prefix = "<leader>R",
		kulala_keymaps_prefix = "",
	},
}
