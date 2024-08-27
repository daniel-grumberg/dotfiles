local function isNotMacOS()
	return vim.loop.os_uname().sysname != 'Darwin'
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
		mason = isNotMacOS(), -- set to false to prevent this server from being installed with mason
		-- keys = {}
		root_dir = function(fname)
			local util = require('lspconfig.util')
			return util.root_pattern('compile_commands.json')(fname) or util.find_git_ancestor(fname)
		end,
		cmd = {
			'clangd',
			'--background-index',
			'--clang-tidy',
			'--header-insertion=iwyu',
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
		-- define to override the default setup function for this server
		---@diagnostic disable-next-line: unused-local
		setup_func = function(server, server_opts)
			-- If on macOS run clangd from xcrun.
			if isMacOS() then
				table.insert(server_opts.cmd, 1, 'xcrun')
			end
			return false -- ensure that lspconfig is still called for this.
		end
	},
}
