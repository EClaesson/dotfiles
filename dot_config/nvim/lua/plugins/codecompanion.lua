return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
	keys = {
		{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "[A]I [C]hat" },
		{ "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "[A]I [I]nline", mode = { "n", "v" } },
	},
	opts = {
		display = {
			chat = {
				window = {
					width = 0.25,
				},
			},
			diff = {
				enabled = true,
				threshold_for_chat = 0,
				word_highlights = {
					additions = true,
					deletions = true,
				},
			},
		},
		adapters = {
			acp = {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {})
				end,
			},
		},
		interactions = {
			chat = {
				adapter = "claude_code",
			},
			inline = {
				adapter = "claude_code",
			},
		},
	},
}
