local mason_path = vim.fn.stdpath 'data' .. '/mason'
local jdtls_path = mason_path .. '/packages/jdtls'
local debug_path = mason_path .. '/packages/java-debug-adapter'
-- local test_path = mason_path .. '/packages/java-test'
local cwd = vim.fn.getcwd()
local java_root = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }

local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-jar',
    vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    jdtls_path .. '/config_linux', -- or config_mac or config_win
    '-data',
    vim.fn.expand '~/.cache/jdtls-workspace' .. vim.fn.getcwd():gsub('/', '-'),
  },
  root_dir = cwd,
  init_options = {
    bundles = {
      vim.fn.glob(debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true),
    },
  },
}
require('jdtls').start_or_attach(config)
