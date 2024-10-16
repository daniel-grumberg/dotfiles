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
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
    end
  },

  -- Fuzzy Finder
  -- TODO: Add support for Trouble here
  {
    'nvim-telescope/telescope.nvim',
    version = false, -- use HEAD as telescope doesn't really do releases
    cmd = 'Telescope',
    dependencies = {
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S . -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        enabled = vim.fn.executable('cmake') == 1
      },
      { 'nvim-lua/plenary.nvim' }
    },
    keys = {
      -- Replicate old emacs setup
      { '<leader>:',       function() require('telescope.builtin').commands() end,   desc = 'Run Command' },
      { '<leader><space>', function() require('telescope.builtin').find_files() end, desc = 'Find Files (Root Directory)' },
      -- file/find
      {
        '<leader>fb',
        function()
          require('telescope.builtin').buffers({ sort_mru = true, sort_lastused = true })
        end,
        desc = 'Find Buffer'
      },
      { '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find Files (Root Directory)' },
      {
        '<leader>fF',
        function()
          require('telescope.builtin').find_files({ cwd = require('telescope.utils').buffer_dir() })
        end,
        desc = 'Find Files Here'
      },
      { '<leader>fr', function() require('telescope.builtin').oldfiles() end,   desc = 'Find Recent Files (Root Directory)' },
      {
        '<leader>fR',
        function()
          require('telescope.builtin').oldfiles({ cwd = require('telescope.utils').buffer_dir() })
        end,
        desc = 'Find Recent Files (cwd)'
      },
      -- help
      { '<leader>hk', function() require('telescope.builtin').keymaps() end,                          desc = 'Keymaps' },
      { '<leader>hm', function() require('telescope.builtin').man_pages() end,                        desc = 'Man Pages' },
      { '<leader>ht', function() require('telescope.builtin').help_tags() end,                        desc = 'Help Tags' },
      -- search
      { '<leader>s"', function() require('telescope.builtin').registers() end,                        desc = 'Registers' },
      { '<leader>sa', function() require('telescope.builtin').autocommands() end,                     desc = 'Auto Commands' },
      { '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end,        desc = 'Buffer' },
      { '<leader>sc', function() require('telescope.builtin').commands() end,                         desc = 'Commands' },
      { '<leader>sC', function() require('telescope.builtin').command_history() end,                  desc = 'Command History' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end,         desc = 'Document Diagnostics' },
      { '<leader>sD', function() require('telescope.builtin').diagnostics() end,                      desc = 'Workspace Diagnostics' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end,                        desc = 'Grep (Root Directory)' },
      { '<leader>sG', function() require('telescope.builtin').live_grep({ cwd = false }) end,         desc = 'Grep (cwd)' },
      { '<leader>sR', function() require('telescope.builtin').resume() end,                           desc = 'Telescope Resume' },
      { '<leader>sw', function() require('telescope.builtin').grep_string({ word_match = '-w' }) end, desc = 'Word (Root Dir)' },
      {
        '<leader>sW',
        function()
          require('telescope.builtin').grep_string({ cwd = false, word_match = '-w' })
        end,
        desc = 'Word (cwd)'
      },
      { '<leader>sw', function() require('telescope.builtin').grep_string() end, mode = 'v', desc = 'Selection (Root Dir)' },
      {
        '<leader>sW',
        function()
          require('telescope.builtin').grep_string({ cwd = false })
        end,
        mode = 'v',
        desc = 'Selection (cwd)'
      },
    },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension('fzf')
    end
  },
  -- Flash does emacs avy style movement
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', function() require('flash').jump() end, mode = { 'n', 'x', 'o' }, desc = 'Flash' },
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

  -- Setup project detection
  {
    'ahmedkhalf/project.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      patterns = {
        '.git',
        '.xcodeproj',
        '.xcworkspace',
        '.proj_root',
        'Makefile',
      },
      silent_chdir = false,
      show_hidden = false,
    },
    config = function(_, opts)
      require('project_nvim').setup(opts)
      require('telescope').load_extension('projects')
    end,
    keys = {
      { "<leader>pp", function() require("telescope").extensions.projects.projects() end, desc = 'Open Project' },
    },
  },

  -- Finds and lists all of TODO, HACK, BUG, etc comments in project and loads them into a browsable list.
  -- TODO: Add support for trouble
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTelescope' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
    keys = {
      { ']t',         function() require('todo-comments').jump_next() end,  desc = 'Next Todo Comment' },
      { '[t',         function() require('todo-comments').jump_prev() end,  desc = 'Previous Todo Comment' },
      { '<leader>st', '<cmd>TodoTelescope<cr>',                             desc = 'Todo' },
      { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME,XXX<cr>', desc = 'Todo/Fix/Fixme/xxx' },
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
