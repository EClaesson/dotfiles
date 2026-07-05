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
				show_token_count = true,
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
				opts = {
					show_preset_actions = true,
					show_preset_prompts = true,
				},
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
				opts = {
					show_presets = false,
				},
				github_copilot = function()
					return require("codecompanion.adapters").extend("copilot_acp", {
						defaults = {
							session_config_options = {
								model = "claude-opus-4.8",
							},
						},
					})
				end,
			} or {
				opts = {
					show_presets = false,
				},
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						defaults = {
							session_config_options = {
								model = "claude-opus-4-8",
							},
						},
					})
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
		interactions = {
			chat = {
				adapter = IS_WORK_MACHINE and "github_copilot" or "opencode",
				opts = {
					context_management = {
						enabled = false,
					},
				},
			},
			inline = {
				adapter = IS_WORK_MACHINE and "github_copilot" or "opencode",
			},
		},
	},
}
