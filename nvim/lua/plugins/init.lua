-- Theme
vim.pack.add({ 'https://github.com/folke/tokyonight.nvim' })
require('tokyonight').setup({
  transparent = true, -- Disable backgrounds
})
vim.cmd.colorscheme 'tokyonight-moon'

-- Auto save and restore sessions
vim.pack.add({ 'https://github.com/rmagatti/auto-session' })
require("auto-session").setup({})

-- Detect tabstop and shiftwidth automatically
vim.pack.add({ 'https://github.com/NMAC427/guess-indent.nvim' })

-- Easily comment visual regions/lines
vim.pack.add({ 'https://github.com/numToStr/Comment.nvim' })
require('Comment').setup({
  -- Ctrl + _ is often the same as Ctrl + / in terminals
  -- So we set <C-_> to get <C-/>
  toggler = { line = '<C-_>' },
  opleader = { line = '<C-_>' },
})

-- General lua code for other plugins
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })
-- Nerd Font icons (glyphs)
vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' })
-- Highlight todo, notes, etc in comments
vim.pack.add({ 'https://github.com/folke/todo-comments.nvim' })
require('todo-comments').setup({ signs = false })

-- Persistent terminal window
vim.pack.add({ 'https://github.com/akinsho/toggleterm.nvim' })
require('toggleterm').setup({ open_mapping = [[<c-t>]] })

-- Welcome screen
vim.pack.add({ 'https://github.com/goolord/alpha-nvim' })
local dashboard = require('alpha.themes.startify')
require('alpha').setup(dashboard.opts)

-- Add indentation guides even on blank lines
vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })
require('ibl').setup()

-- Autopairs
vim.pack.add({ 'https://github.com/windwp/nvim-autopairs' })
require('nvim-autopairs').setup({})

