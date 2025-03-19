-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle NeoTree', silent = true },
  },
  deactivate = function()
    vim.cmd [[Neotree close]]
  end,
  avante_add_files = function(state)
    local node = state.tree:get_node()
    local filepath = node:get_id()
    local relative_path = require('avante.utils').relative_path(filepath)

    local sidebar = require('avante').get()

    local open = sidebar:is_open()
    -- ensure avante sidebar is open
    if not open then
      require('avante.api').ask()
      sidebar = require('avante').get()
    end

    sidebar.file_selector:add_selected_file(relative_path)

    -- remove neo tree buffer
    if not open then
      sidebar.file_selector:remove_selected_file 'neo-tree filesystem [1]'
    end
  end,

  init = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('Neotree_start_directory', { clear = true }),
      desc = 'Start Neo-tree with directory',
      once = true,
      callback = function()
        if package.loaded['neo-tree'] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == 'directory' then
            require 'neo-tree'
          end
        end
      end,
    })
  end,
  opts = {
    enable_git_status = true,
    enable_diagnostics = true,
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      window = {
        position = 'right',
        mappings = {
          ['oa'] = 'avante_add_files',
          ['<leader>e'] = 'close_window',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<space>'] = 'none',
          ['Y'] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg('+', path, 'c')
            end,
            desc = 'Copy Path to Clipboard',
          },
          ['O'] = {
            function(state)
              require('lazy.util').open(state.tree:get_node().path, { system = true })
            end,
            desc = 'Open with System Application',
          },
        },
      },
    },
  },
}
