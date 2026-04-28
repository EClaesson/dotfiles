local git_cache = {}
local git_inflight = {}
local git_cache_ttl = 10000
local repo_root_cache = {}

local function current_repo_root()
	local buf_dir
	local bufname = vim.api.nvim_buf_get_name(0)

	if bufname == "" then
		buf_dir = vim.uv.cwd()
	else
		buf_dir = vim.fs.dirname(bufname)
	end

	if not buf_dir then
		return nil
	end

	local cached = repo_root_cache[buf_dir]
	if cached ~= nil then
		return cached ~= "" and cached or nil
	end

	local found = vim.fs.find(".git", { upward = true, path = buf_dir })[1]
	local root = found and vim.fs.dirname(found) or ""
	repo_root_cache[buf_dir] = root
	return root ~= "" and root or nil
end

vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained" }, {
	callback = function()
		for _, entry in pairs(git_cache) do
			entry.mtime = 0
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "NeogitStatusRefreshed",
	callback = function()
		for _, entry in pairs(git_cache) do
			entry.mtime = 0
		end
	end,
})

vim.api.nvim_create_autocmd("DirChanged", {
	callback = function()
		repo_root_cache = {}
	end,
})

local function schedule_update(root)
	if git_inflight[root] then
		return
	end
	git_inflight[root] = true

	vim.system(
		{ "git", "-C", root, "status", "--porcelain=v1", "--ignore-submodules" },
		{ text = true },
		function(result)
			git_inflight[root] = nil

			if result.code ~= 0 then
				git_cache[root] =
					{ added = 0, changed = 0, removed = 0, renamed = 0, untracked = 0, mtime = vim.uv.now() }
				return
			end

			local added, changed, removed, renamed, untracked = 0, 0, 0, 0, 0
			for line in result.stdout:gmatch("[^\n]+") do
				local x, y = line:sub(1, 1), line:sub(2, 2)
				if x == "?" and y == "?" then
					untracked = untracked + 1
				elseif x == "R" or y == "R" then
					renamed = renamed + 1
				elseif x == "A" or y == "A" then
					added = added + 1
				elseif x == "D" or y == "D" then
					removed = removed + 1
				elseif x == "M" or y == "M" then
					changed = changed + 1
				end
			end

			git_cache[root] = {
				added = added,
				changed = changed,
				removed = removed,
				renamed = renamed,
				untracked = untracked,
				mtime = vim.uv.now(),
			}

			vim.schedule(function()
				vim.cmd("redrawtabline")
			end)
		end
	)
end

local function git_repo_status()
	local root = current_repo_root()
	if not root then
		return ""
	end

	local entry = git_cache[root]
	local now = vim.uv.now()
	if not entry or (now - entry.mtime) >= git_cache_ttl then
		schedule_update(root)
	end

	if not entry then
		return ""
	end

	local parts = {}
	if entry.added > 0 then
		table.insert(parts, "+" .. entry.added)
	end
	if entry.changed > 0 then
		table.insert(parts, "~" .. entry.changed)
	end
	if entry.removed > 0 then
		table.insert(parts, "-" .. entry.removed)
	end
	if entry.renamed > 0 then
		table.insert(parts, "→" .. entry.renamed)
	end
	if entry.untracked > 0 then
		table.insert(parts, "?" .. entry.untracked)
	end

	return table.concat(parts, " ")
end

local function workspace_diagnostics()
	local counts = { error = 0, warn = 0, info = 0, hint = 0 }
	local sev = vim.diagnostic.severity

	for _, d in ipairs(vim.diagnostic.get(nil)) do
		if d.severity == sev.ERROR then
			counts.error = counts.error + 1
		elseif d.severity == sev.WARN then
			counts.warn = counts.warn + 1
		elseif d.severity == sev.INFO then
			counts.info = counts.info + 1
		elseif d.severity == sev.HINT then
			counts.hint = counts.hint + 1
		end
	end

	return counts
end

local function progress()
	local line = vim.fn.line(".")
	local total = vim.fn.line("$")

	if total == 0 then
		return ""
	end

	local pct = math.floor((line / total) * 100)
	return string.format("%d%%%%/%d", pct, total)
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	keys = {
		{
			"<leader>ir",
			function()
				local name = vim.fn.input("New tab name: ")
				vim.cmd("LualineRenameTab " .. name)
			end,
			desc = "[R]ename Tab",
		},
	},
	opts = {
		sections = {
			lualine_b = { "diff" },
			lualine_c = {
				{
					"filename",
					path = 1,
					shorting_target = 40,
					newfile_status = true,
				},
			},
			lualine_x = { "searchcount", "diagnostics", "filetype" },
			lualine_y = { progress },
		},
		tabline = {
			lualine_a = {
				{
					"tabs",
					mode = 2,
					show_modified_status = false,
				},
			},
			lualine_x = {
				{
					"diagnostics",
					sources = { workspace_diagnostics },
					sections = { "error", "warn", "info", "hint" },
					symbols = {
						error = "󰅚 ",
						warn = "󰀪 ",
						info = "󰋽 ",
						hint = "󰌶 ",
					},
					colored = true,
					update_in_insert = false,
					always_visible = false,
				},
			},
			lualine_y = {
				{ git_repo_status },
			},
			lualine_z = {
				{
					"branch",
				},
			},
		},
	},
}
