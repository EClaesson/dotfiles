return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",

			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "debugloop/telescope-undo.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		{
			"LukasPietzschmann/telescope-tabs",
			keys = {
				{
					"<leader>sa",
					function()
						require("telescope-tabs").list_tabs()
					end,
					desc = "[S]earch T[a]bs",
				},
			},
			config = function()
				local function format_tab(tab_id, buffer_ids, file_names, file_paths, is_current)
					local entry_string = table.concat(file_names, ", ")
					return string.format("%d  %s%s", tab_id, entry_string, is_current and " <" or "")
				end

				require("telescope-tabs").setup({
					entry_formatter = format_tab,
					entry_ordinal = format_tab,
				})
			end,
		},
	},
	keys = {
		{ "<leader>su", "<cmd>Telescope undo<cr>", desc = "[S]earch [U]ndo history" },
		{
			"<leader>sh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>sk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "[S]earch [K]eymaps",
		},
		{
			"<leader>sf",
			function()
				require("telescope.builtin").find_files({
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				})
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>sF",
			function()
				require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
			end,
			desc = "[S]earch [F]iles (no ignore)",
		},
		{
			"<leader>ss",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "[S]earch [S]elect Telescope",
		},
		{
			"<leader>sw",
			function()
				require("telescope.builtin").grep_string()
			end,
			mode = { "n", "v" },
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>sg",
			function()
				require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--glob=!.git/*" } })
			end,
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader>sG",
			function()
				require("telescope.builtin").live_grep({
					additional_args = { "--hidden", "--glob=!.git/*", "--no-ignore" },
				})
			end,
			desc = "[S]earch by [G]rep (no ignore)",
		},
		{
			"<leader>sd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<leader>sr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "[S]earch [R]esume",
		},
		{
			"<leader>s.",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = '[S]earch Recent Files ("." for repeat)',
		},
		{
			"<leader>sc",
			function()
				require("telescope.builtin").commands()
			end,
			desc = "[S]earch [C]ommands",
		},
		{
			"<leader><leader>",
			function()
				local actions = require("telescope.actions")
				require("telescope.builtin").buffers({
					sort_mru = true,
					attach_mappings = function(_, map)
						map("i", "<C-x>", actions.delete_buffer)
						map("n", "<C-x>", actions.delete_buffer)
						map("n", "dd", actions.delete_buffer)
						return true
					end,
				})
			end,
			desc = "[ ] Find existing buffers",
		},
		{ "<leader>sy", "<cmd>Telescope neoclip<cr>", desc = "[S]earch [Y]anks" },
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "[S]earch [T]odos" },
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "[S]earch [/] in Open Files",
		},
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "[S]earch [N]eovim files",
		},
	},
	config = function()
		local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }
		table.insert(vimgrep_arguments, "--hidden")
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		require("telescope").setup({
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
				["undo"] = {},
			},
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
			},
		})

		require("telescope").load_extension("undo")
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
	end,
}
