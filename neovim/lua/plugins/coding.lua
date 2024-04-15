return {
	{
		'hrsh7th/nvim-cmp',
		version = false, -- releases are extremely infrequent
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
		},
		opts = function()
			vim.api.nvim_set_hl(0, 'CmpGhostText', { link = 'Comment', default = true })
			local cmp = require('cmp')
			local defaults = require('cmp.config.default')()
			local luasnip = require('luasnip')
			return {
				-- Add the relevant filetype if the lsp server doesn't correctly insert bracets.
				auto_brackets = {},
				snippet= {
					expand= function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-l>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { 'i', 's' }),
					['<C-h>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'path' },
				}, {
					{ name = 'luasnip' },
					{ name = 'buffer' },
				}),
				experimental = {
					ghost_text = {
						hl_group = 'CmpGhostText'
					},
				},
				sorting = defaults.sorting,
			}
		end,
		config = function(_, opts)
			for index, source  in ipairs(opts.sources) do
				source.group_index = source.group_index or index
			end
			local cmp = require('cmp')
			local Kind = cmp.lsp.CompletionItemKind
			cmp.setup(opts)
			cmp.event:on('confirm_done', function(event)
				if not vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
					return
				end
				local entry = event.entry
				local item = entry:get_completion_item()
				if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
					local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
					vim.api.nvim_feedkeys(keys, 'i', true)
				end
			end)
		end,
	},
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		opts = {},
		keys = {
			{
				'<leader>tp',
				function ()
					vim.g.minipairs_disable = not vim.g.minipairs_disable
					if vim.g.minipairs_disable then
						vim.api.nvim_echo({'Disabled auto pairs.'}, false)
					else
						vim.api.nvim_echo({'Enabled auto pairs.'}, false)
					end
				end,
				desc = 'Toggle Auto Pairs',
			},
		},
	},
	-- comments
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	{
		'echasnovski/mini.comment',
		event = 'VeryLazy',
		opts = {
			options = {
				custom_commentstring = function()
					return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
				end,
			},
		},
	},
}
