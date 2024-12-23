local M = {}

M._keys = nil

-- Additional implementation for switching between source and header files for servers that support it...
-- only clangd afaik.
local function switch_source_header_handler(_err, uri)
	if not uri or uri == "" then
		vim.api.nvim_echo({ { "Corresponding file cannot be determined" } }, false, {})
		return
	end
	local file_name = vim.uri_to_fname(uri)
	vim.api.nvim_cmd({
		cmd = "edit",
		args = { file_name },
	}, {})
end

local function switch_source_header()
	vim.lsp.buf_request(0, "textDocument/switchSourceHeader", {
		uri = vim.uri_from_bufnr(0),
	}, switch_source_header_handler)
end

function M.get()
	if M._keys then
		return M._keys
	end
	M._keys = {
		{ '<leader>ci', '<cmd>LspInfo<cr>', desc = 'LSP Info' },
		{
			'gd',
			function()
        require('fzf-lua').lsp_definitions({ reuse_win = true })
      end,
      desc = 'Goto Definition',
      has = 'definition'
    },
    {
      '<leader>cd',
      function()
        require('fzf-lua').lsp_definitions({ reuse_win = true })
			end,
			desc = 'Goto Definition',
			has = 'definition'
		},
		{ 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration', has = 'declaration' },
    { 'gr',         function() require('fzf-lua').lsp_references() end, desc = 'Goto References',  has = 'references' },
    { '<leader>cr', function() require('fzf-lua').lsp_references() end, desc = 'Goto References',  has = 'references' },
		{
			'gI',
			function()
        require('fzf-lua').lsp_implementations({ reuse_win = true })
			end,
			desc = 'Goto Implementation',
			has = 'implementation',
		},
		{
			'<leader>cI',
			function()
        require('fzf-lua').lsp_implementations({ reuse_win = true })
			end,
			desc = 'Goto Implementation',
			has = 'implementation',
		},
		{ 'K', vim.lsp.buf.hover, desc = 'Hover', has = 'hover' },
		{ '<leader>ch', vim.lsp.buf.hover, desc = 'Hover', has = 'hover' },
		{ '<leader>cH', switch_source_header, desc = 'Switch Source/Header', has = 'switchSourceHeader' },
		{ 'gK', vim.lsp.buf.signature_help, desc = 'Signature Help', has = 'signatureHelp' },
		{ '<leader>cK', vim.lsp.buf.signature_help, desc = 'Signature Help', has = 'signatureHelp' },
		{ '<c-k>', vim.lsp.buf.signature_help, mode = 'i', desc = 'Signature Help', has = 'signatureHelp' },
		{ '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'v' }, has = 'codeAction' },
		{ '<leader>cR', vim.lsp.buf.rename,                                                 desc = 'Rename',               has = 'rename' },
    { '<leader>cs', function() require('fzf-lua').lsp_document_symbols() end, desc = 'Goto Symbol',          has = '' },
		{
			'<leader>cS',
			function()
        require('fzf-lua').lsp_live_workspace_symbols()
			end,
			desc = 'Goto Symbol (Workspace)',
			has = ''
		},
		{ '<leader>cf', vim.lsp.buf.format, desc = 'Format', mode = { 'n', 'v' }, has = 'formatting' }
	}
	return M._keys
end

function M.has(buffer, method)
	method = method:find('/') and method or 'textDocument/' .. method
  local clients = vim.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

function M.resolve(buffer)
	local servers = require('plugins.lsp.servers')
  local clients = vim.lsp.get_clients({ bufnr = buffer })
	local keyspec = M.get()
	for _, client in ipairs(clients) do
		local maps = servers[client.name] and servers[client.name].keys or {}
		vim.list_extend(keyspec, maps)
	end
	return keyspec
end

local function get_key_opts(key_spec, buffer)
	return {
		silent = key_spec.silent ~= false,
		buffer = buffer,
		desc = key_spec.desc,
	}
end

function M.on_attach(_, buffer)
	local keymaps = M.resolve(buffer)
	for _, keyspec in pairs(keymaps) do
		if not keyspec.has or M.has(buffer, keyspec.has) then
			vim.keymap.set(keyspec.mode or 'n', keyspec[1], keyspec[2], get_key_opts(keyspec, buffer))
		end
	end
end

return M
