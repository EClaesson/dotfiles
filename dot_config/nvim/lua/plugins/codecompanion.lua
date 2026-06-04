return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
	keys = {
		{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI [C]hat" },
		{ "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI [I]nline", mode = { "n", "v" } },
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
			acp = IS_WORK_MACHINE and {
				github_copilot = function()
					return require("codecompanion.adapters").extend("copilot_acp", {})
				end,
			} or {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {})
				end,
			},
		},
		interactions = IS_WORK_MACHINE and {
			chat = {
				adapter = "github_copilot",
			},
			inline = {
				adapter = "github_copilot",
			},
		} or {
			chat = {
				adapter = "claude_code",
			},
			inline = {
				adapter = "claude_code",
			},
		},
	},
}
