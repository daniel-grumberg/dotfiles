return {
	'nvim-treesitter/nvim-treesitter',
	version = false,
	build = ':TSUpdate',
	lazy = false, -- Many pluggins rely on treesitter without requiring it, make it available from the start...
	cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
	opts = {
		ensure_installed = {
			'bash',
			'c',
			'cpp',
			'lua',
			'luadoc',
			'markdown',
			'objc',
			'ruby',
			'swift',
			'vim',
			'vimdoc'
		},
		auto_install = false, -- disable autoinstalling grammars
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = { 'ruby' },
		},
		indent = { enable = true, disable = { 'ruby' } },
		config = function (_, opts)
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
	-- Show context of the current function
	{
		'nvim-treesitter/nvim-treesitter-context',
		event = { 'BufReadPre', 'BufNewFile' },
		enabled = true,
		opts = { mode = 'cursor', max_lines = 3 },
		keys = {
			{
				'<leader>Tc',
				function()
					require('treesitter-context').toggle()
				end,
				desc = 'Toggle Treesitter Context',
			},
		},
	},
}
