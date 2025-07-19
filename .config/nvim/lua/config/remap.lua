-- global keybinds
--
-- find local keybinds in their respective file
--   (e.g. netrw exclusive binds -> ~/.config/nvim/lua/config/netrw.lua)
--   (for plugins it will be in the specfile in ~/.config/nvim/lua/plugins/)

vim.g.mapleader = ' '

-- netrw
vim.keymap.set('n', '-', vim.cmd.Ex, { noremap = true, desc = 'Open netrw' })
vim.keymap.set('n', '<leader>~', ':edit ~/<CR>', { silent = true, noremap = true, desc = 'Open netrw in ~/' })

-- editing
vim.keymap.set('n', '<leader>w', vim.cmd.w, { desc = 'Save file' })
vim.keymap.set('i', '<S-Tab>', '<C-V><Tab>', { desc = 'Insert a tab character' })
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Replace current word' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection up a line' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection down a line' })
vim.keymap.set('n', '<C-a>', 'goVG', { silent = true, desc = 'Select all text in file' })

-- a little big of register trickery
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete to void register' })

-- bash scripting wet dream
vim.keymap.set('n', '<leader>X', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make current file executable' })

vim.keymap.set('n', '<Esc><Esc>', vim.cmd.nohlsearch, { silent = true, desc = 'Clear search highlighting' })

-- don't move cursor for J
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true })

-- keep cursor centered-ish when going through search matches
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })

-- keep cursor centered when using C-d or C-u
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true })

-- Q mode is a scary place to be
vim.keymap.set('n', 'Q', '<nop>')

-- moving between splits
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- resizing splits
vim.keymap.set('', '<C-up>', '<C-W>+')
vim.keymap.set('', '<C-down>', '<C-W>-')
vim.keymap.set('', '<C-left>', '<C-W><')
vim.keymap.set('', '<C-right>', '<C-W>>')

-- telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })

-- harpoon
local harpoon = require('harpoon')
harpoon:setup()
vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Add current buffer to harpoon' })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon quick menu' })
vim.keymap.set('n', '<leader>j', function() harpoon:list():select(1) end, { desc = 'Switch to harpoon buffer 1' })
vim.keymap.set('n', '<leader>k', function() harpoon:list():select(2) end, { desc = 'Switch to harpoon buffer 2' })
vim.keymap.set('n', '<leader>l', function() harpoon:list():select(3) end, { desc = 'Switch to harpoon buffer 3' })
vim.keymap.set('n', '<leader>;', function() harpoon:list():select(4) end, { desc = 'Switch to harpoon buffer 4' })
vim.keymap.set('n', '<leader>p', function() harpoon:list():prev() end, { desc = 'Prev harpoon buffer' })
vim.keymap.set('n', '<leader>n', function() harpoon:list():next() end, { desc = 'Next harpoon buffer' })
