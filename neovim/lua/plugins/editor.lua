return {
  -- Show help popup for partially completed keysequences
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      icons = {
        mappings = false,
      },
      plugins = {
        spelling = true
      },
      spec = {
        {
          mode = { 'n', 'v' },
          { ']',          group = '+next' },
          { '[',          group = '+previous' },
          { 's',          group = '+surround' },
          { '<leader>b',  group = '+buffer' },
          { '<leader>c',  group = '+code' },
          { '<leader>f',  group = '+file/find' },
          { '<leader>g',  group = '+git' },
          { '<leader>gh', group = '+hunks' },
          { '<leader>h',  group = '+help' },
          { '<leader>n',  group = '+notifications' },
          { '<leader>p',  group = '+project' },
          { '<leader>s',  group = '+search' },
          { '<leader>t',  group = '+text' },
          { '<leader>T',  group = '+Treesitter' },
          { '<leader>w',  group = '+windows' },
        },
      },
      triggers = {
        { 's', mode = { 'n', 'x' } },
        { 'S',        mode = { 'n', 'x' } },
        { 'g',        mode = { 'n', 'x' } },
        { ']',        mode = { 'n', 'x' } },
        { '[',        mode = { 'n', 'x' } },
        { '<leader>', mode = { 'n', 'v' } },
      }
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
    end
  },

  -- Fuzzy Finder
  -- TODO: Add support for Trouble here
  {
    'ibhagwan/fzf-lua',
    keys = {
      -- Replicate old emacs setup
      { '<leader>:',       function() require('fzf-lua').commands() end,              desc = 'Run Command' },
      { '<leader><space>', function() require('fzf-lua').files() end,                 desc = 'Find Files' },
      -- file/find
      { '<leader>bb',      function() require('fzf-lua').buffers() end,               desc = 'Find Buffer' },
      { '<leader>ff',      function() require('fzf-lua').files() end,                 desc = 'Find Files' },
      { '<leader>fr',      function() require('fzf-lua').oldfiles() end,              desc = 'Find Recent Files' },
      -- help
      { '<leader>hk',      function() require('fzf-lua').keymaps() end,               desc = 'Keymaps' },
      { '<leader>hm',      function() require('fzf-lua').manpages() end,              desc = 'Man Pages' },
      { '<leader>ht',      function() require('fzf-lua').helptags() end,              desc = 'Help Tags' },
      -- search
      { '<leader>s"',      function() require('fzf-lua').registers() end,             desc = 'Registers' },
      { '<leader>sa',      function() require('fzf-lua').autocmds() end,              desc = 'Auto Commands' },
      { '<leader>sb',      function() require('fzf-lua').lgrep_curbuf() end,          desc = 'Buffer' },
      { '<leader>sc',      function() require('fzf-lua').commands() end,              desc = 'Commands' },
      { '<leader>sC',      function() require('fzf-lua').command_history() end,       desc = 'Command History' },
      { '<leader>sd',      function() require('fzf-lua').diagnostics_document() end,  desc = 'Document Diagnostics' },
      { '<leader>sD',      function() require('fzf-lua').diagnostics_workspace() end, desc = 'Workspace Diagnostics' },
      { '<leader>sg',      function() require('fzf-lua').live_grep() end,             desc = 'Grep' },
      { '<leader>sR',      function() require('fzf-lua').resume() end,                desc = 'FzfLua Resume' },
      { '<leader>sw',      function() require('fzf-lua').grep() end,                  desc = 'Word' },
      { '<leader>sw',      function() require('fzf-lua').grep_visual() end,           mode = 'v',                    desc = 'Selection' },
    },
  },
  -- Flash does emacs avy style movement
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 'S', function() require('flash').jump() end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
    },
  },

  -- Automatically highlights other instances of the word under your cursor.
  -- This works with LSP, Treesitter, and regexp matching to find other instances.
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { 'lsp' },
      },
    },
    config = function(_, opts)
      require('illuminate').configure(opts)
      local function map(key, direction, desc_prefix, buffer)
        vim.keymap.set('n', key, function()
          require('illuminate')['goto_' .. direction .. '_reference'](false)
        end, { desc = desc_prefix .. ' Reference', buffer = buffer })
      end

      map(']]', 'next', 'Next')
      map('[[', 'prev', 'Previous')

      -- Also set the keymaps after loading filetype plugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map(']]', 'next', 'Next', buffer)
          map('[[', 'prev', 'Previous', buffer)
        end
      })
    end,
    keys = {
      { ']]', desc = 'Next Reference' },
      { '[[', desc = 'PreviousReference' },
    },
  },

  -- Remove buffer
  {
    "echasnovski/mini.bufremove",
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- Finds and lists all of TODO, HACK, BUG, etc comments in project and loads them into a browsable list.
  -- TODO: Add support for trouble
  {
    'folke/todo-comments.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    cmd = { 'TodoFzfLua' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
    keys = {
      { ']t',         function() require('todo-comments').jump_next() end,  desc = 'Next Todo Comment' },
      { '[t',         function() require('todo-comments').jump_prev() end,  desc = 'Previous Todo Comment' },
      { '<leader>st', '<cmd>TodoFzfLua<cr>',                               desc = 'Todo' },
      { '<leader>sT', '<cmd>TodoFzfLua keywords=TODO,FIX,FIXME,XXX<cr>',   desc = 'Todo/Fix/Fixme/xxx' },
    },
  },

  -- Strip trailing whitespace on save on modified lines.
  {
    'lewis6991/spaceless.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },
  -- enable integration with terminal multiplexer
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      {
        '<C-h>',
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = { 'n', 't' },
        desc = "Go to left window",
      },
      {
        '<C-j>',
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { 'n', 't' },
        desc = "Go to lower window",
      },
      {
        '<C-k>',
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { 'n', 't' },
        desc = "Go to upper window",
      },
      {
        '<C-l>',
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { 'n', 't' },
        desc = "Go to right window",
      },
      {
        '<A-h>',
        function()
          require("smart-splits").resize_left()
        end,
        mode = { 'n', 't' },
        desc = "Go to left window",
      },
      {
        '<A-j>',
        function()
          require("smart-splits").resize_down()
        end,
        mode = { 'n', 't' },
        desc = "Go to lower window",
      },
      {
        '<A-k>',
        function()
          require("smart-splits").resize_up()
        end,
        mode = { 'n', 't' },
        desc = "Go to upper window",
      },
      {
        '<A-l>',
        function()
          require("smart-splits").resize_right()
        end,
        mode = { 'n', 't' },
        desc = "Go to right window",
      },
    },
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
      ignored_buftypes = { "nofile" }
    },
  },
}
