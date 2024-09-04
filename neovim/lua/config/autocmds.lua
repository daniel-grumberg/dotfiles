local function augroup(name)
	return vim.api.nvim_create_augroup('config-' .. name, { clear = true })
end

-- Check if we need to reload the file when it changed.
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	group = augroup('checktime'),
	callback = function()
		if vim.o.buftype ~= 'nofile' then
			vim.cmd('checktime')
		end
	end
})

-- Highlight on yank.
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking text',
	group = augroup('highlight-on-yank'),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits if window got resized.
vim.api.nvim_create_autocmd('VimResized', {
	group = augroup('resize-splits'),
	callback = function()
		local current_tab = vim.tabpagenr()
		vim.cmd('tabdo wincmd =')
		vim.cmd('tabnext ' .. current_tab)
	end
})

-- Go to the last location when opening a buffer.
vim.api.nvim_create_autocmd('BufReadPost', {
	group = augroup('last-loc'),
	callback = function(event)
		local exclude = { 'gitcommit' }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close-with-q'),
  pattern = {
    'help',
    'lspinfo',
    'notify',
    'qf',
    'Neogit*',
    'query',
    'checkhealth',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.api.nvim_buf_set_keymap(event.buf, 'n', 'q', '<cmd>close<cr>', { silent = true })
  end
})

-- Check spelling for certain text filetypes
vim.api.nvim_create_autocmd('FileType', {
	group = augroup('text-spell'),
	pattern = {
		'gitcommit',
		'markdown',
	},
	callback = function()
		vim.opt_local.spell = true
	end
})

-- Auto create missing directories when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
	group = augroup('auto-create-dirs'),
	callback = function(event)
		-- don't do anything for files with a uri e.g. 'ftp://.*'
		if event.match:match('^%w%w+:[\\/][\\/]') then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
	end
})

-- Automatically change CWD to match project when possible
local root_cache = {}
local function find_root()
	local root_patterns = {
		'compile_commands.json',
		'Package.swift',
	}

	local dir_path = vim.fn.expand('%:p:h')

	-- Check the cache before starting the traversal
	local cache_hit = root_cache[dir_path]
	if cache_hit ~= nil then return cache_hit end

	local root_file = vim.fs.find(function(name, path)
		return root_cache[path] ~= nil -- cache hit stop walking up
			or vim.tbl_contains(root_patterns, name)
			or name:match('.git$')
			or name:match('.xcodeproj$') -- sigh...
			or name:match('.xcworkspace$') -- sigh...
			or path:match('.config/nvim$')
	end, {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = dir_path,
	})[1]

	if root_file ~= nil then
		root_file = vim.fn.dirname(root_file)

		-- check if we short-sircuited the traversal due to a cache hit
		cache_hit = root_cache[root_file]
		if cache_hit ~= nil then
			-- forward the hit to the directory lower down the tree
			root_cache[dir_path] = cache_hit
			return cache_hit
		else
			if type(root_file) ~= 'string' then return end
			if not vim.fn.isdirectory(root_file) then return end
			root_cache[dir_path] = root_file
		end

	else
		return
	end

	if type(root) ~= 'string' then return end
	root = vim.fn.fnamemodify(root, ':p')
	if not vim.fn.isdirectory(root) then return end
	root_cache[dir_path] = root

	return root
end
