return {
	"nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local main = require('nvim-treesitter')
        main.setup {
            install_dir = vim.fn.stdpath('data') .. '/site'
        }

        main.install {
            "bash",
            "c",
            "diff",
            "git_config",
            "git_rebase",
            "gitcommit",
            "gitignore",
            "gitattributes",
            "haskell",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "nix",
            "printf",
            "python",
            "query",
            "regex",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "xml",
            "yaml",
        }
    end,
}
