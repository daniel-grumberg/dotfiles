local map = vim.keymap.set

local i = 'i'
local o = 'o'
local n = 'n'
local v = 'v'
local x = 'x'
local nx = { 'n', 'x' }
local ni = { 'n', 'i' }

-- Improve vertical cursor movement
map(nx, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true})
map(nx, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true})
map(nx, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true})
map(nx, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true})

-- Windows
map(n, '<leader>w<Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
map(n, '<leader>w<Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
map(n, '<leader>w<Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
map(n, '<leader>w<Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

map(n, '<leader>wh', '<C-w>h', { desc = 'Go to Left Window' })
map(n, '<leader>wj', '<C-w>j', { desc = 'Go to Lower Window' })
map(n, '<leader>wk', '<C-w>k', { desc = 'Go to Upper Window' })
map(n, '<leader>wl', '<C-w>l', { desc = 'Go to Right Window' })
map(n, '<leader>ww', '<C-W>p', { desc = 'Other Window' })
map(n, '<leader>wd', '<C-W>c', { desc = 'Delete Window' })
map(n, '<leader>ws', '<C-W>s', { desc = 'Split Window Below' })
map(n, '<leader>wv', '<C-W>v', { desc = 'Split Window Right' })
map(n, '<leader>w=', '<cmd>wincmd =<cr>', { desc = 'Equalizes Windows' })
-- TODO: figure out how better to handle tab page.
map(n, '<leader>wt', vim.cmd.tabnext, { desc = 'Next Tab' })
map(n, '<leader>wT', vim.cmd.tabNext, { desc = 'Previous Tab' })

-- Buffers
map(n, '<leader>bp', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
map(n, '[b', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
map(n, '<leader>bn', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map(n, ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
map(n, '<leader>bo', '<cmd>edit #<cr>', { desc = 'Other Buffer' })

-- Clear search with <esc>
map(ni, '<esc>', '<cmd>nohlsearch<cr><esc>', { desc = 'Escape and clear hlsearch' })
map(i, 'jk', '<cmd>nohlsearch<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- Files
map({'i', 'x', 'n', 's' }, '<C-s>', '<cmd>write<cr><esc>', { desc = 'Save file' })
map(n, '<leader>fs', '<cmd>write<cr><esc>', { desc = 'Save file' })
map(n, '<leader>fN', ':e %:h/', { desc = 'New file (here)' })
map(n, '<leader>fn', ':e ', { desc = 'New file' })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map(n, '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map(n, ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map(n, '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map(n, ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map(n, '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map(n, ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map(n, '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })
