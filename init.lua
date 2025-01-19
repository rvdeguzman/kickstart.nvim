require 'options'
require 'keymaps'
require 'autocmds'

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
require('lazy').setup {
  require 'plugins.ui',
  require 'plugins.editor',
  require 'plugins.coding',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.theme',
  require 'rv.plugins.debug',
  require 'rv.plugins.indent_line',
  require 'rv.plugins.lint',
  require 'rv.plugins.autopairs',
  require 'rv.plugins.neo-tree',
  require 'rv.plugins.gitsigns', -- adds gitsigns recommend keymaps

  { import = 'rv.plugins' },
}
