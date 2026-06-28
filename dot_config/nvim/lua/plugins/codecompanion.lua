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
		{ "<leader>ar", "<cmd>CodeCompanionActions refresh<cr>", desc = "AI [R]efresh Actions" },
		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI [A]ction Palette" },
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
			action_palette = {
				provider = "telescope",
			},
		},
		prompt_library = {
			markdown = {
				dirs = {
					vim.fn.getcwd() .. "/.prompts",
					"~/.config/codecompanion/prompts",
				},
			},
		},
		adapters = {
			http = {
				opts = {
					show_presets = false,
				},
			},
			acp = IS_WORK_MACHINE and {
				github_copilot = function()
					return require("codecompanion.adapters").extend("copilot_acp", {})
				end,
			} or {
				opts = {
					show_presets = false,
				},
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {})
				end,
				opencode = function()
					return require("codecompanion.adapters").extend("opencode", {
						defaults = {
							model = "openrouter/z-ai/glm-5.2",
						},
					})
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
				adapter = "opencode",
			},
			inline = {
				adapter = "opencode",
			},
		},
	},
}
