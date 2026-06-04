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
					desc = "Search T[a]bs",
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
		{ "<leader>su", "<cmd>Telescope undo<cr>", desc = "Search [U]ndo History" },
		{
			"<leader>sh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Search [H]elp",
		},
		{
			"<leader>sk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Search [K]eymaps",
		},
		{
			"<leader>sf",
			function()
				require("telescope.builtin").find_files({
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				})
			end,
			desc = "Search [F]iles",
		},
		{
			"<leader>sF",
			function()
				require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
			end,
			desc = "Search [F]iles (No Ignore)",
		},
		{
			"<leader>ss",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "Search [S]elect Telescope",
		},
		{
			"<leader>sw",
			function()
				require("telescope.builtin").grep_string()
			end,
			mode = { "n", "v" },
			desc = "Search Current [W]ord",
		},
		{
			"<leader>sg",
			function()
				require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--glob=!.git/*" } })
			end,
			desc = "Search By [G]rep",
		},
		{
			"<leader>sG",
			function()
				require("telescope.builtin").live_grep({
					additional_args = { "--hidden", "--glob=!.git/*", "--no-ignore" },
				})
			end,
			desc = "Search By [G]rep (No Ignore)",
		},
		{
			"<leader>sd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Search [D]iagnostics",
		},
		{
			"<leader>sr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Search [R]esume",
		},
		{
			"<leader>s.",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = '[S]earch Recent Files ("." For Repeat)',
		},
		{
			"<leader>sc",
			function()
				require("telescope.builtin").commands()
			end,
			desc = "Search [C]ommands",
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
		{ "<leader>sy", "<cmd>Telescope neoclip<cr>", desc = "Search [Y]anks" },
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search [T]odos" },
		{
			"<leader>/",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			desc = "[/] Fuzzy Search in Buffer",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			desc = "Search [/] in Open Files",
		},
		{
			"<leader>sn",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Search [N]eovim Files",
		},
		{
			"<leader>sb",
			function()
				require("telescope.builtin").git_bcommits()
			end,
			desc = "Search [B]uffer Commits",
		},
		{
			"<leader>sS",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "Search Git [S]tatus",
		},
		{
			"<leader>s:",
			function()
				require("telescope.builtin").command_history()
			end,
			desc = "Search [:] Command History",
		},
		{
			"<leader>s?",
			function()
				require("telescope.builtin").search_history()
			end,
			desc = "Search [?] History",
		},
		{
			"<leader>sj",
			function()
				require("telescope.builtin").jumplist()
			end,
			desc = "Search [J]umplist",
		},
		{
			"<leader>si",
			function()
				require("telescope.builtin").lsp_incoming_calls()
			end,
			desc = "Search [I]ncoming Calls",
		},
		{
			"<leader>sO",
			function()
				require("telescope.builtin").lsp_outgoing_calls()
			end,
			desc = "Search [O]utgoing Calls",
		},
		{
			"<leader>sm",
			function()
				require("telescope.builtin").treesitter()
			end,
			desc = "Search Treesitter Sy[m]bols",
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
