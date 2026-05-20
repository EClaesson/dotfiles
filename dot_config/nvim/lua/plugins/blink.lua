return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	branch = "v1",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					event = "InsertEnter",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
	},
	opts = {
		keymap = {
			preset = "default",
			["<Tab>"] = false,
			["<C-Tab>"] = { "snippet_forward", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 0 },
		},
		sources = {
			default = { "lsp", "path", "snippets" },
		},
		cmdline = {
			keymap = { preset = "inherit" },
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = {
			enabled = true,
			window = {
				show_documentation = true,
			},
		},
	},
}
