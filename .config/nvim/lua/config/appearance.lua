-- For colorscheme see ~/.config/nvim/lua/plugins/colorscheme.lua

-- color :)
vim.opt.termguicolors = true

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- fat cursor
vim.opt.guicursor = ""

-- line highlights
vim.opt.cursorline = true
vim.opt.colorcolumn = '120'

-- scroll screen when cursor is within 7 lines
vim.opt.scrolloff = 7

-- always show gutter which can have icons in it for lsp warnings etc
vim.opt.signcolumn = "yes"

-- show live update of search
vim.opt.incsearch = true

-- move cursor (temporarily) to show matching parens, brackets, etc.
vim.opt.showmatch = true
vim.opt.mat = 2

-- indent behavior
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- include subdirs in find path
table.insert(vim.opt.path, '**')

