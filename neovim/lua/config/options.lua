-- This file is automatically loaded very early during setup
-- Set useful global vim options to customize the default experience.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

local opt = vim.opt

-- Prevent automatic CWD changing we handle this later via automcommand
opt.autochdir = false

-- Confirm to save changes when exiting a modified buffer
opt.confirm = true

-- Use ripgrep
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'

-- Show absolute line number for current line and relative line number for all
-- others lines.
opt.number = true
opt.relativenumber = true

-- Allow mouse mode, can be useful for resizing splits for example.
opt.mouse = 'a'

opt.showmode = false -- it's already in the status line...

-- Use the same clipboard as the OS
if not vim.env.SSH_TTY then
	opt.clipboard = 'unnamedplus'
end

-- True color support
opt.termguicolors = true

-- Make wrapped line appear with the correct indentation.
opt.breakindent = true

-- Enable storing undo history in a file on the system.
opt.undofile = true

-- Enable the sign column to be as big as needed.
opt.signcolumn = 'yes'

-- Allow cursor to move where there is no text in visual block mode
opt.virtualedit = 'block'

-- Decrease mapped sequence time, in practice this displays the which-key popup
-- sooner.
opt.timeout = true
opt.timeoutlen = 300

-- Vertical splits on the right and horizontal splits below
opt.splitright = true
opt.splitbelow = true

-- Sets how neowill display certain whitespace characters in the editor.
opt.list = true
opt.listchars = { tab = '> ', lead = '·', trail = '·', nbsp = '␣' }

-- Preview substiutions live as typed.
opt.inccommand = 'nosplit'

-- Minimal number of lines to preserve above/below the cursor when moving to
-- offscreen location.
opt.scrolloff = 10

-- Enable smoothscrolling when possible natively
if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
end

-- Set the default formatting options
opt.smarttab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.textwidth = 120

