-- netrw config
-- NOTE: I only really use p or <CR> to open files from netrw, so settings may be wonky for o, v, etc.
vim.g.netrw_banner = 0  -- disable banner
vim.g.netrw_preview = 1  -- preview shown in vertical split
-- vim.g.netrw_alto = 1 -- open horizontal splits below (netrw stays above)
-- NOTE: the above is what I prefer for horz splits, but it causes previews to open on the left when netrw_preview = 1
vim.g.netrw_altv = 1  -- open vertical splits right (netrw stays left)
vim.g.netrw_winsize = 30  -- files opened in a split take up 70% of the columns
vim.g.netrw_liststyle = 3  -- tree view

-- netrw custom binds
-- be sure to include { buffer = true } so the binds only apply to netrw
vim.api.nvim_create_augroup('netrw', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    group = 'netrw',
    pattern = 'netrw',
    callback = function()
        vim.api.nvim_command('setlocal buftype=nofile')  -- do not treat the buffer like a normal file
        vim.api.nvim_command('setlocal bufhidden=wipe')  -- when buffer becomes hidden, dispose of it
        vim.keymap.set('n', '<S-p>', ':pclose<CR>', {
            buffer = true, noremap = true, silent = true,
            desc = 'Close netrw file preview'
        })
    end,
})

-- quick netrw cheatsheet (the commands I care about anyways)
--
-- - -> go up one directory
-- gn -> change tree root directory to the dir under cursor or parent dir to file under cursor
-- % -> make a file
-- d -> make a directory
-- D -> delete a file or emtpy directory
-- R -> rename a file or directory
-- gh -> toggle hidden files
-- p -> preview file under cursor
-- (my own bind set above) <S-p> -> close preview
