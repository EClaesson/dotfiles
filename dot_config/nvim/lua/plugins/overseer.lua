return {
	"stevearc/overseer.nvim",
	cmd = { "OverseerRun", "OverseerToggle", "OverseerQuickAction", "OverseerTaskAction", "OverseerInfo" },
	opts = {},
	keys = {
		{ "<leader>uo", "<cmd>OverseerToggle<cr>", desc = "Toggle [O]verseer" },
		{ "<leader>ur", "<cmd>OverseerRun<cr>", desc = "Overseer [R]un" },
		{ "<leader>uq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer [Q]uick Action" },
		{ "<leader>ut", "<cmd>OverseerTaskAction<cr>", desc = "Overseer [T]ask Action" },
	},
}
