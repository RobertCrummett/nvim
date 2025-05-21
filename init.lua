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
                ensure_installed = {};
                auto_install = true,
                sync_install = false,
                ignore_install = {},
                modules = {},
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
        'Mofiqul/vscode.nvim',
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        lazy = false,
    },
    {
        'neovim/nvim-lspconfig',
    },
    {
        'mason-org/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            { 'mason-org/mason.nvim', opts = {} },
            'neovim/nvim-lspconfig',
        },
        config = function()
            require('mason-lspconfig').setup()
        end,
    },
    {
        'kshenoy/vim-signature',
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    icons_enabled = true,
                    component_separators = '|',
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = {
                        'branch',
						{
							'diff',
							symbols = {
								added = ' ',
								modified = ' ',
								removed = ' ',
							},
						},
						'diagnostics',
					},
					lualine_c = { 'filename' },
					lualine_x = { 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
			})
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
	},
	{
		'neomake/neomake',
	},
	{
		'hrsh7th/nvim-cmp'
	},
	{
		'hrsh7th/cmp-nvim-lsp'
	},
})

vim.o.termguicolors = true

vim.o.mouse = "a"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.signcolumn = "yes"

vim.o.autoindent = true

vim.cmd [[
    syntax enable
    colorscheme lunaperche
]]

vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>o", ":Oil<CR>", { desc = "Open file explorer" })

vim.keymap.set("n", "<Leader>ds", vim.diagnostic.open_float, { desc = "Show diagnostic" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

local virtual_text_enabled = true
vim.keymap.set("n", "<leader>dv", function()
	vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, { desc = "Toggle diagnostics virtual text" })
