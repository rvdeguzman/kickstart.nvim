local config = {
  -- cmd = { '/opt/homebrew/bin/jdtls' },
  cmd = { '~/.local/share/nvim/mason/bin/jdtls' },
  -- root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  root_dir = vim.fn.getcwd(),
  init_options = {
    bundles = {
      vim.fn.glob('~/repos/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', true),
    },
  },
}
require('jdtls').start_or_attach(config)
