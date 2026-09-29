return {
	"saghen/blink.cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	branch = "v1",
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
			per_filetype = {
				sql = { "dadbod_grip", inherit_defaults = true },
			},
			providers = {
				dadbod_grip = { name = "Grip SQL", module = "dadbod-grip.completion.blink" },
			},
		},
		cmdline = {
			keymap = { preset = "cmdline" },
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
