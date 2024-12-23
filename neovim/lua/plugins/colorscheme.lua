return {
  {
    enabled = false,
    'folke/tokyonight.nvim',
    lazy = false, -- This really needs to be loaded at startup
    -- make sure to load this before all other plugins as some other ones might
    -- try and query colors for hlgroups and other such things.
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('tokyonight-night')
    end
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false, -- This really needs to be loaded at startup
    -- make sure to load this before all other plugins as some other ones might
    -- try and query colors for hlgroups and other such things.
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        illuminate = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        notify = true,
        semantic_tokens = true,
        fzf = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
