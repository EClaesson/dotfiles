-- The plugin has no tab/layout option: it builds its workspace (sidebar vsplit,
-- welcome buffer in the current window, query pad split) in whatever tabpage is
-- current. So give it a tab of its own and tear that tab down on close.
local function grip_tab()
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local ok, marked = pcall(vim.api.nvim_tabpage_get_var, tab, "grip_tab")
		if ok and marked then
			return tab
		end
	end
end

local function in_grip_tab(cmd)
	return function()
		local tab = grip_tab()
		if tab then
			vim.api.nvim_set_current_tabpage(tab)
		else
			vim.cmd("tabnew")
			vim.t.grip_tab = true
		end
		vim.cmd(cmd)
	end
end

local function grip_close()
	pcall(function()
		require("dadbod-grip.schema").close()
	end)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf):match("^grip://") then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
	local tab = grip_tab()
	if tab and #vim.api.nvim_list_tabpages() > 1 then
		pcall(vim.cmd, "tabclose " .. vim.api.nvim_tabpage_get_number(tab))
	end
end

return {
	"joryeugene/dadbod-grip.nvim",
	dependencies = {
		"tpope/vim-dadbod",
	},
	cmd = { "Grip", "GripStart", "GripConnect" },
	keys = {
		{ "<leader>ec", in_grip_tab("GripConnect"), desc = "[C]onnect" },
		{ "<leader>eg", in_grip_tab("Grip"), desc = "[G]rid" },
		{ "<leader>et", in_grip_tab("GripTables"), desc = "[T]ables" },
		{ "<leader>eq", in_grip_tab("GripQuery"), desc = "[Q]uery Pad" },
		{ "<leader>es", in_grip_tab("GripSchema"), desc = "[S]chema" },
		{ "<leader>eh", in_grip_tab("GripHistory"), desc = "[H]istory" },
		{ "<leader>ex", grip_close, desc = "E[x]it / close grip" },
	},
	opts = {
		picker = "telescope",
		completion = false,
		keymaps = {
			qpad_execute = "<leader>er",
		},
	},
}
