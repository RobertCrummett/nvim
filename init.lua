local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function () 
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "cpp", "fortran", "matlab", "markdown", "make", "cmake", "json", "python", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },  
				additional_vim_regex_highlighting = false,
			})
		end
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = {"nvim-tree/nvim-web-devicons"},
		config = function()
			local configs = require("fzf-lua")

			configs.setup({
				git_icons = false,
				file_icons = false,
				color_icons = false,
			})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"m4xshen/hardtime.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {}
	},
})

vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.number = true
