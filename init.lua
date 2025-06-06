local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
			{ out, 'WarningMsg' },
			{ '\nPress any key to exit...' },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function ()
			local configs = require('nvim-treesitter.configs')

			configs.setup({
				ensure_installed = {};
				auto_install = true,
				sync_install = false,
				ignore_install = {},
				modules = {},
				highlight = { enable = false },
				indent = { enable = false },
				additional_vim_regex_highlighting = false,
			})
		end
	},
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			'nvim-telescope/telescope.nvim',
		},
	},
	{
		'tpope/vim-surround',
	},
	{
		'tpope/vim-commentary',
	},
	{
		'tpope/vim-endwise',
	},
	{
		'tpope/vim-dispatch',
	},
	{
		'stevearc/oil.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opts = {}},
		opts = {
			columns = {
				'icon',
				'permissions',
				'size',
				'mtime',
			},
		},
		lazy = false,
	},
	{
		'kshenoy/vim-signature',
	},
	{
		'lewis6991/gitsigns.nvim',
	},
	{
		'nvim-telescope/telescope.nvim', 
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		'slugbyte/lackluster.nvim',
		lazy = false,
--		priority = 1000,
--		config = function()
--			vim.cmd([[colorscheme lackluster]])
--		end,
	},
})

vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.wrap = false
vim.o.laststatus = 0

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = false

vim.o.signcolumn = 'yes'

vim.cmd [[syntax enable]]

vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>o', ':Oil<CR>', { desc = 'Open file explorer' })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<CR>', {desc = 'Dismiss Noice Message'})

-- https://lsp-zero.netlify.app/blog/lsp-config-overview.html
vim.diagnostic.config({
	virtual_text = false,
	signs = false,
	underline = false,
})

vim.lsp.config('*', {
	capabilities = {
		textDocument = {
			semanticTokens = {
				multilineTokenSupport = true,
			}
		}
	},
	root_markers = { '.git' },
})

vim.lsp.enable('luals')
vim.lsp.enable('clangd')
vim.lsp.enable('fortls')
vim.lsp.enable('pyright')
vim.lsp.enable('typescript-language-server')

vim.api.nvim_create_user_command('DiagnosticToggle', function()
	local config = vim.diagnostic.config
	local vt = config().virtual_text
	config {
		virtual_text = not vt,
		signs = not vt,
		underline = not vt,
	}
end, { desc = 'Toggle diagnostics' })

-- Set ripgrep as the default grep program
if vim.fn.executable('rg') == 1 then
	vim.o.grepprg = 'rg --vimgrep --smart-case'
	vim.o.grepformat = '%f:%l:%c:%m'
end
