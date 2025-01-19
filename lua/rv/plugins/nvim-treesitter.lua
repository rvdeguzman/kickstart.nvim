return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    -- Combined list of languages from both configs
    ensure_installed = {
      'bash', 'c', 'cpp', 'dart', 'diff', 'go',
      'html', 'java', 'javascript', 'lua', 'luadoc',
      'markdown', 'markdown_inline', 'query', 'rust',
      'vim', 'vimdoc'
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    sync_install = false,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { 
      enable = true,
      disable = { 'ruby' }
    },
  },
  -- There are additional nvim-treesitter modules that you can use to interact
  -- with nvim-treesitter. You should go explore a few and see what interests you:
  --
  --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
  --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
