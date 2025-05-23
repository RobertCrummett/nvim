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
        dependencies = { 'nvim-tree/nvim-web-devicons', opts = {}},
        opts = {
            columns = {
                'icon',
                'permissions',
                'size',
                'mtime',
            },
            delete_to_trash = true,
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
        'folke/noice.nvim',
        event = 'VeryLazy',
        opts = {
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
        },
        dependencies = {
            'MunifTanjim/nui.nvim',
            { 'rcarriga/nvim-notify', opts = {
                top_down = false,
                timeout = 2500,
            }},
        }
    },
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'nvim-telescope/telescope.nvim', 
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
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

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<Leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<Leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<Leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<Leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('telescope').load_extension('noice')

vim.keymap.set('n', '<leader>nd', '<cmd>NoiceDismiss<CR>', {desc = 'Dismiss Noice Message'})
