vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.signcolumn = 'no'

vim.api.nvim_set_hl(0, 'Todo', { link = 'Comment' })

vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter.git',
    'https://github.com/neovim/nvim-lspconfig.git',
    'https://github.com/stevearc/oil.nvim.git',
    'https://github.com/tpope/vim-fugitive.git',
    'https://github.com/ledger/vim-ledger.git',
}

require('oil').setup {}

local to_delete = vim.iter(vim.pack.get())
    :filter(function(x) return not x.active end)
    :map(function(x) return x.spec.name end)
    :totable()
if #to_delete ~= 0 then
    vim.pack.del(to_delete)
end

vim.lsp.config['*'] = {
    capabilities = { textDocument = { semanticTokens = { multilineTokenSupport = true } } },
    root_markers = { '.git' },
}

local function on_jump(diagnostic, bufnr)
    if not diagnostic then return end

    vim.diagnostic.show(
        diagnostic.namespace,
        bufnr,
        { diagnostic },
        { virtual_lines = { current_line = true }, virtual_text = false }
    )
end

vim.keymap.set('n', 'gK', function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.diagnostic.config({ virtual_lines = false, jump = { on_jump = on_jump } })

vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('tinymist')

vim.lsp.config['harper_ls'] = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'tex', 'typst', 'gitcommit' },
    root_markers = { '.harper-dictionary.txt' },
}
vim.lsp.enable('harper_ls')
