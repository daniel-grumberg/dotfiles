local function isMacOS()
  return vim.loop.os_uname().sysname == 'Darwin'
end

return {
  lua_ls = {
    -- mason = false -- set to false to prevent this server from being installed with mason
    -- keys = {}
    -- define to override the default setup function for this server
    -- setup_func = function(server, server_opts) end
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { callSnippet = 'Replace' },
      },
    },
  },

  clangd = {
    mason = not isMacOS(), -- set to false to prevent this server from being installed with mason
    -- keys = {}
    root_dir = function(fname)
      local util = require('lspconfig.util')
      return util.root_pattern('compile_commands.json')(fname) or util.find_git_ancestor(fname)
    end,
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion-decorators',
      '--completion-style=detailed',
      '--function-arg-placeholders',
      '--fallback-style=llvm',
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
    ---@diagnostic disable-next-line: unused-local
    setup_func = function(server, server_opts)
      -- If on macOS run clangd from xcrun.
      if isMacOS() then
        table.insert(server_opts.cmd, 1, 'xcrun')
      end
      return false -- ensure that lspconfig is still called for this.
    end
  },

  sourcekit = {
    mason = not isMacOS(),
    filetypes = { 'swift' },
    capabilities = {
      workspace = {
        didChangeConfiguration = {
          dynamicRegistration = true,
        },
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
    cmd = {
      'sourcekit-lsp',
      '--experimental-feature',
      'background-indexing',
    },
    ---@diagnostic disable-next-line: unused-local
    setup_func = function(server, server_opts)
      -- If on macOS run clangd from xcrun.
      if isMacOS() then
        table.insert(server_opts.cmd, 1, 'xcrun')
      end
      return false -- ensure that lspconfig is still called for this.
    end
  },

  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  },
}
