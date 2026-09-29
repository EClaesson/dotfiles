local function hunk_operator(action)
	return function()
		_G.gitsigns_hunk_operator = function()
			require("gitsigns")[action]({ vim.fn.line("'["), vim.fn.line("']") })
		end
		vim.o.operatorfunc = "v:lua.gitsigns_hunk_operator"
		return "g@"
	end
end

local function hunk_visual(action)
	return function()
		local first, last = vim.fn.line("v"), vim.fn.line(".")
		require("gitsigns")[action]({ math.min(first, last), math.max(first, last) })
	end
end

return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = "Gitsigns",
	keys = {
		{ "gh", hunk_operator("stage_hunk"), expr = true, desc = "Stage Hunk (Operator)" },
		{ "gH", hunk_operator("reset_hunk"), expr = true, desc = "Reset Hunk (Operator)" },
		{ "gh", hunk_visual("stage_hunk"), mode = "x", desc = "Stage Selected Lines" },
		{ "gH", hunk_visual("reset_hunk"), mode = "x", desc = "Reset Selected Lines" },
		{
			"gh",
			function()
				require("gitsigns").select_hunk()
			end,
			mode = "o",
			desc = "Hunk",
		},
		{ "[h", "<cmd>Gitsigns nav_hunk prev<cr>", desc = "Previous Hunk" },
		{ "]h", "<cmd>Gitsigns nav_hunk next<cr>", desc = "Next Hunk" },
		{ "[H", "<cmd>Gitsigns nav_hunk first<cr>", desc = "First Hunk" },
		{ "]H", "<cmd>Gitsigns nav_hunk last<cr>", desc = "Last Hunk" },
	},
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		signcolumn = true,
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 300,
		},
	},
}
