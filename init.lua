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
        'tpope/vim-fugitive',
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
        opts = {
            columns = {
                'icon',
                'permission',
                'size',
                'mtime',
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
        'lewis6991/gitsigns.nvim',
    },
})

vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.wrap = false
vim.o.laststatus = 0

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.signcolumn = 'yes'

vim.cmd [[syntax enable]]
vim.cmd [[colorscheme default]]

vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>o', ':Oil<CR>', { desc = 'Open file explorer' })
