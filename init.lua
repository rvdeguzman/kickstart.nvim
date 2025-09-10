-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--     local lazyrepo = "https://github.com/folke/lazy.nvim.git"
--     local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
--     if vim.v.shell_error ~= 0 then
--         vim.api.nvim_echo({
--             { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
--             { out,                            "WarningMsg" },
--             { "\nPress any key to exit..." },
--         }, true, {})
--         vim.fn.getchar()
--         os.exit(1)
--     end
-- end
-- vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

-- require("lazy").setup({
--     spec = {
--         -- { import = "plugins" },
--     },
-- })



-- requires
require('lsp')
require('opts')
require('plug.oil')
require('plug.nvim-tree')
require('plug.undotree')
require('plug.harpoon')
require('plug.tmux')
require('plug.mini')
require('plug.gitsigns')
require('plug.telescope')
require('plug.flash')

-- keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-q>', '<cmd>qa!<CR>')
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>')
vim.keymap.set('n', '<leader>wd', '<cmd>close<CR>')

vim.pack.add({
    -- themes
    { src = 'https://github.com/rktjmp/lush.nvim' },
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
    { src = 'https://github.com/sainnhe/gruvbox-material' },
    { src = 'https://github.com/rebelot/kanagawa.nvim' },
    { src = 'https://github.com/sainnhe/edge' },
    { src = 'https://github.com/zenbones-theme/zenbones.nvim' },
    { src = 'https://github.com/thesimonho/kanagawa-paper.nvim' },
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/metalelf0/black-metal-theme-neovim' },
    -- ui
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
})

vim.cmd.colorscheme 'dark-funeral'

-- lualine
require('lualine').setup {
    options = {
        theme = 'auto',
        globalstatus = true,
        section_separators = '',
        component_separators = '',
    },
    sections = {
        lualine_c = {
            {
                'filename',
                path = 1,
            }
        }
    },
}

-- indent blankline
require("ibl").setup()

-- autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({
            timeout = 75,
        })
    end,
})
