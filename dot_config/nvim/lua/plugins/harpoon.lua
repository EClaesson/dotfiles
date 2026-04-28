local function harpoon_telescope_picker()
	local harpoon = require("harpoon")
	local conf = require("telescope.config").values
	local entry_display = require("telescope.pickers.entry_display")
	local harpoon_files = harpoon:list()

	local file_paths = {}
	for i, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, { index = i, path = item.value })
	end

	local displayer = entry_display.create({
		separator = "  ",
		items = { {}, { remaining = true } },
	})

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({
				results = file_paths,
				entry_maker = function(entry)
					local display_path = vim.fn.fnamemodify(entry.path, ":~:.")
					return {
						value = entry.path,
						display = function()
							return displayer({
								{ tostring(entry.index), "TelescopeResultsNumber" },
								display_path,
							})
						end,
						ordinal = tostring(entry.index) .. " " .. display_path,
						path = entry.path,
						lnum = 1,
					}
				end,
			}),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>ha",
			function()
				require("harpoon"):list():add()
			end,
			desc = "[A]dd",
		},
		{
			"<leader>h1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "Select [1]",
		},
		{
			"<leader>h2",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "Select [2]",
		},
		{
			"<leader>h3",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "Select [3]",
		},
		{
			"<leader>h4",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "Select [4]",
		},
		{
			"<leader>h5",
			function()
				require("harpoon"):list():select(5)
			end,
			desc = "Select [5]",
		},
		{
			"<leader>hl",
			harpoon_telescope_picker,
			desc = "[L]ist",
		},
	},
	config = function()
		require("harpoon"):setup({})
	end,
}
