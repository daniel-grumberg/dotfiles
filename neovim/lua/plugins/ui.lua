return {
	-- Better `vim.notify()`
	{
		'rcarriga/nvim-notify',
		event = 'VeryLazy',
		keys = {
			{
				'<leader>nd',
				function()
					require('notify').dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss All Notifications"
			}
		},
		opts = {
			stages = 'static',
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			op_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
	},
	{
		'nvim-lualine/lualine.nvim',
		event = 'VeryLazy',
		opts = {
			options = {
				theme = 'auto',
				globalstatus = true,
				component_separators = { left = '|' , right = '|' },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = {
					{ 'branch' },
					{
						"diff",
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					{
						'diagnostics',
						symbols = { error = 'E', warn = 'W', info = 'I', hint = 'H' },
					},
				},
				lualine_c = {
					{ 'filename', path = 1},
					{ 'filetype', icons_enabled = false }
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{ 'progress', separator = ' ', padding = { left = 1, right = 0} },
					{ 'location', padding = { left = 0, right = 1} }
				}
			}
		}
	}
}
