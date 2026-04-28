vim.opt.autoread = true
vim.opt.breakindent = true
vim.opt.colorcolumn = { "100" }
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.ignorecase = true
vim.opt.inccommand = "split"
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "help", "tabpages", "winsize", "winpos", "terminal" }
vim.opt.shiftwidth = 0
vim.opt.showbreak = "↪ "
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.wrap = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },

	virtual_text = true,
	virtual_lines = false,

	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor" })
		end,
	},
})
