vim.pack.add({
    { src = 'https://github.com/echasnovski/mini.nvim' },
})

require('mini.ai').setup()
require('mini.surround').setup()
require('mini.bracketed').setup()
require('mini.comment').setup()
require('mini.pick').setup()
require('mini.starter').setup()
require('mini.statusline').setup()
require('mini.fuzzy').setup()
require('mini.icons').setup()
require('mini.extra').setup()

local pick = require('mini.pick')
local extra = require('mini.extra')

vim.keymap.set('n', '<leader><leader>', function() pick.builtin.files() end)
vim.keymap.set('n', '<leader>,', function() pick.builtin.grep_live() end)

vim.keymap.set('n', '<leader>ss', function()
    extra.pickers.lsp({ scope = 'document_symbol' })
end)

vim.keymap.set('n', '<leader>sw', function()
    extra.pickers.lsp({ scope = 'workspace_symbol' })
end)
