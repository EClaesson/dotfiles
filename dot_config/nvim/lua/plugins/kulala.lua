return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>Rs", desc = "[S]end request" },
		{ "<leader>Ra", desc = "[S]end [A]ll requests" },
		{ "<leader>Rb", desc = "Open [B]uffer scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		global_keymaps = true,
		global_keymaps_prefix = "<leader>R",
		kulala_keymaps_prefix = "",
	},
}
