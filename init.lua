vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true

vim.o.expandtab = true
vim.o.tabstop = 4 
vim.o.wrap = false
vim.o.swapfile = false
vim.o.shiftwidth = 4 
vim.o.softtabstop = 4 

vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<C-q>', '<cmd>qa!<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>')
vim.keymap.set('n', '<C-l>', '<C-w><C-l>')
vim.keymap.set('n', '<C-j>', '<C-w><C-j>')
vim.keymap.set('n', '<C-k>', '<C-w><C-k>')

vim.pack.add({
    {src = "https://github.com/morhetz/gruvbox"}
})
vim.cmd("colorscheme gruvbox")

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('hl-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Split window mappings
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>')
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>')
vim.keymap.set('n', '<leader>wd', '<C-W>c')

-- diagnostic jumping
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
