vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

-- requires
require('lsp')
require('opts')
require('plugins.oil')
require('plugins.nvim-tree')
require('plugins.undotree')
require('plugins.harpoon')
require('plugins.tmux')
require('plugins.mini')
require('plugins.gitsigns')

-- keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-q>', '<cmd>qa!<CR>')
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>')
vim.keymap.set('n', '<leader>wd', '<cmd>close<CR>')

vim.pack.add({
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
})

vim.cmd.colorscheme 'gruvbox'

-- indent blankline
require("ibl").setup()

-- autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 75 })
    end,
})

