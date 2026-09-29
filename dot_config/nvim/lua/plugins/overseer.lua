return {
	"stevearc/overseer.nvim",
	cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction" },
	opts = {},
	keys = {
		{ "<leader>uo", "<cmd>OverseerToggle<cr>", desc = "Toggle [O]verseer" },
		{ "<leader>ur", "<cmd>OverseerRun<cr>", desc = "Overseer [R]un" },
		{ "<leader>ut", "<cmd>OverseerTaskAction<cr>", desc = "Overseer [T]ask Action" },
	},
}
