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

-- NOTE Disabled because llama.vim will cause stutter when leaders are pressed.
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {
        "https://github.com/tpope/vim-fugitive.git",
        "https://github.com/airblade/vim-gitgutter.git",
        "https://github.com/ggml-org/llama.vim.git",
        "https://github.com/ledger/vim-ledger",
    },
    install = { colorscheme = { "default" } },
    checker = { enabled = true },
})

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100
vim.opt.signcolumn = "no"

-- Highlight todo's just like comments
vim.api.nvim_set_hl(0, "Todo", { link = "Comment" })

-- Language servers
vim.lsp.config['*'] = {
    capabilities = { textDocument = { semanticTokens = { multilineTokenSupport = true } } },
    root_markers = { '.git' },
}
vim.diagnostic.config({ virtual_lines = false })

-- Harper spell checking language server
vim.lsp.config['harper'] = {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = { 'markdown', 'tex', 'typst' },
}
vim.lsp.enable('harper')

-- Lua language server
vim.lsp.config['luals'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc' },
    settings = { Lua = { runtime = { version = 'LuaJIT' }, diagnostics = { globals = { 'vim' } } } },
}
vim.lsp.enable('luals')

-- C language server
vim.lsp.config['clangd'] = {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt' },
    settings = { clangd = { fallbackFlags = { '-std=c++20' } } },
}
vim.lsp.enable('clangd')

-- Python language server
vim.lsp.config['pyright'] = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
}
-- NOTE pyright should be installed through a virtual environment.
-- vim.lsp.enable('pyright')

-- Typst language server
vim.lsp.config['tinymist'] = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
}
vim.lsp.enable('tinymist')

-- Open into a scratch buffer by default when no arguments were passed
if vim.fn.argc() == 0 then
    vim.opt.shortmess:append("I")
    vim.opt.buftype = "nofile"
    vim.opt.bufhidden = "hide"
    vim.opt.swapfile = false
end
