vim.cmd("set nu")
vim.cmd("set cursorline")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set incsearch")
vim.cmd("set expandtab")
vim.cmd("set smartcase")
vim.cmd("set ignorecase")
vim.cmd("set laststatus=3")
vim.cmd("set showcmd")
vim.cmd("set hidden")
vim.cmd("set splitbelow splitright")
vim.cmd("set ruler")
vim.cmd("set cindent")
vim.cmd("set autoindent")
vim.o.signcolumn = "number"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    { 
        'nvim-telescope/telescope.nvim', tag = '0.1.6', dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        }
    },
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    { "rose-pine/neovim", name = "rose-pine" },
    { "EdenEast/nightfox.nvim" },
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = {}}
}

local opts = {}

require("lazy").setup(plugins, opts)
require("catppuccin").setup()
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "clangd" },
}
require("lspconfig").lua_ls.setup {}
require("lspconfig").clangd.setup {}

local builtin = require('telescope.builtin')
local configs = require("nvim-treesitter.configs")

configs.setup({
          ensure_installed = { "c", "cpp", "python", "lua", "vim" },
          highlight = { enable = true },
          indent = { enable = true },
        })

vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-r>', builtin.live_grep, {})
vim.keymap.set('n', '<C-q>', ':Neotree filesystem reveal left<CR>', {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', '<C-k>', vim.lsp.buf.format, {})
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, {noremap = true, silent = true, buffer = bufnr})
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

require("rose-pine").setup({
    variant = "auto", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,
    --disable_background = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = false,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.o.background = "dark" -- or "light" for light mode

-- vim.cmd([[colorscheme gruvbox]])
vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme rose-pine-main")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")
-- vim.cmd.colorscheme "catppuccin" -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
--vim.cmd("colorscheme carbonfox")


-- jump to last edit position on opening file
vim.api.nvim_create_autocmd(
	'BufReadPost',
	{
		pattern = '*',
		callback = function(ev)
			if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
				-- except for in git commit messages
				-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
				if not vim.fn.expand('%:p'):find('.git', 1, true) then
					vim.cmd('exe "normal! g\'\\""')
				end
			end
		end
	}
)
