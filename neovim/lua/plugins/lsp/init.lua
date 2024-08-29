return {
  -- lspconfig
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/neodev.nvim', opts = {} },
      'joechrisellis/lsp-format-modifications.nvim',
    },
    opts = {
      inlay_hints = { enabled = false },
      codelens = { enabled = false },
      capabilities = {},
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      -- Set up keymaps when lsp attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(args)
          local buffer = vim.api.nvim_get_current_buf()
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require('plugins.lsp.keymaps').on_attach(client, buffer)
          -- If this client supports range formatting make 'gq' motions use it.
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_buf_set_option(buffer, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:250})')
          end


          if client.supports_method('textDocument/rangeFormatting') then
            vim.api.nvim_buf_create_user_command(
              buffer,
              "FormatModifications",
              function()
              end,
              {}
            )
            local augroup_id = vim.api.nvim_create_augroup('FormatModificationsOnSave', { clear = false })
            vim.api.nvim_clear_autocmds({ group = augroup_id })
            vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
              group = augroup_id,
              buffer = buffer,
              callback = function()
                local success = require('lsp-format-modifications').format_modifications(client, buffer, {})
                if not success then vim.lsp.buf.format({ bufnr = buffer }) end
              end,
            })
          end
        end
      })

      -- Register keymaps whenever a capability is registered because keys get mapped only if the capability is
      -- available.
      local register_capability = vim.lsp.handlers['client/registerCapability']

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require('plugins.lsp.keymaps').on_attach(client, buffer)
        return ret
      end

      -- configure vim.diagnostic
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Get all explicitly specified servers and set up their capabilities
      local servers_configs = require('plugins.lsp.servers')
      local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, servers_configs[server] or {})

        -- Do we have a special override setup function for this server
        if server_opts.setup_func then
          if servers_configs[server].setup_func(server, server_opts) then
            return
          end
        end
        require('lspconfig')[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, 'mason-lspconfig')
      local all_mlsp_servers = {}
      if have_mason then
        all_mlsp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, server_config in pairs(servers_configs) do
        if server_config then
          server_config = server_config == true and {} or server_config
          -- run manual setup if mason == false or if this is a server that cannot be installed with mason-lspconfig
          if server_config.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
            setup(server)
          elseif server_config.enabled ~= false then
            table.insert(ensure_installed, server)
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
    end
  },

  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = {
      { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' },
    },
    opts = {
      ensure_installed = {
        'stylua',
        'shfmt',
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          vim.api.nvim_exec_autocmds('FileType', { buffer = vim.api.nvim_get_current_buf() })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
