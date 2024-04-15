local M = {}
local defaults = {
	lazy_keymaps = true,
}

local function load(name)
	require('config.' .. name)
end

function M.setup(opts)
	local options = vim.tbl_deep_extend('force', defaults, opts or {}) or {}
	load('options')

	-- autocmds can be loaded lazily when not opening a file
	local lazy_autocmds = vim.fn.argc(-1) == 0
	if not lazy_autocmds then
		load('autocmds')
	end

	if not options.lazy_keymaps then
		load('keymaps')
	end

	local lazy_load_configs = function()
		if lazy_autocmds then
			load('autocmds')
		end

		if options.lazy_keymaps then
			load('keymaps')
		end

	end

	if vim.v.vim_did_enter == 1 then
		lazy_load_configs()
	else
		local group = vim.api.nvim_create_augroup("Config", { clear = true })
		vim.api.nvim_create_autocmd('VimEnter', {
			group = group,
			callback = lazy_load_configs
		})
	end
end

return M

