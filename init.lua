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
        "tpope/vim-fugitive",
    },
    {
        'stevearc/oil.nvim',
        opts = {
            columns = {
                "icon",
                "permission",
                "size",
                "mtime",
            },
            delete_to_trash = true,
            git = {
                add = function(path)
                    return true
                end,
                mv = function(src_path, dest_path)
                    return true
                end,
                rm = function(path)
                    return true
                end,
            },
        },
        lazy = false,
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
})

vim.o.termguicolors = true
vim.o.mouse = "a"

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.signcolumn = "yes"

vim.cmd [[syntax enable]]

vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>o", ":Oil<CR>", { desc = "Open file explorer" })
