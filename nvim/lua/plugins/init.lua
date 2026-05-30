vim.pack.add({ 
  -- Theme
  "https://github.com/folke/tokyonight.nvim",
  -- Auto save and restore sessions
  "https://github.com/rmagatti/auto-session",
  -- Detect tabstop and shift width automatically
  "https://github.com/NMAC427/guess-indent.nvim",
  -- Easily comment visual regions/lines
  "https://github.com/numToStr/Comment.nvim",
  -- General lua code for other plugins
  "https://github.com/nvim-lua/plenary.nvim",
  -- Nerd Font icons (glyphs)
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- Highlight todo, notes, etc in comments
  "https://github.com/folke/todo-comments.nvim",
  -- Persistent terminal window
  "https://github.com/akinsho/toggleterm.nvim",
  -- Welcome screen
  "https://github.com/goolord/alpha-nvim",
  -- Add indentation guides even on blank lines
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  -- Auto pairs
  "https://github.com/windwp/nvim-autopairs",
  -- Collection of various small independent plugins/modules
  "https://github.com/echasnovski/mini.nvim",
  -- Neovim UI utilities (for neo-tree)
  "https://github.com/MunifTanjim/nui.nvim",
  -- Neo-tree is a Neovim plugin to browse the file system
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  -- FZF sorter for telescope
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  -- Native neovim selections in telescope
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  -- Fuzzy find windows (files, lsp, etc.)
  "https://github.com/nvim-telescope/telescope.nvim",
  -- LazyGit integration
  "https://github.com/kdheepak/lazygit.nvim",
  -- Useful plugin to show you pending key binds.
  "https://github.com/folke/which-key.nvim",
  -- Git signs
  "https://github.com/lewis6991/gitsigns.nvim",
  -- Buffer line
  "https://github.com/akinsho/bufferline.nvim",
  -- Treesitter configurations and abstraction layer for Neovim
  "https://github.com/nvim-treesitter/nvim-treesitter",
  -- LSP configurations for Neovim
  "https://github.com/neovim/nvim-lspconfig",
  -- LSP installer for Neovim
  "https://github.com/mason-org/mason.nvim",
})

require("tokyonight").setup({
  transparent = true, -- Disable backgrounds
})
vim.cmd.colorscheme "tokyonight-moon"
require("auto-session").setup({})
require("Comment").setup({
  -- Ctrl + _ is often the same as Ctrl + / in terminals
  -- So we set <C-_> to get <C-/>
  toggler = { line = "<C-_>" },
  opleader = { line = "<C-_>" },
})
require("todo-comments").setup({ signs = false })
require("toggleterm").setup({ open_mapping = [[<c-t>]] })
local dashboard = require("alpha.themes.startify")
require("alpha").setup(dashboard.opts)
require("ibl").setup()
require("nvim-autopairs").setup({})

-- LazyGit
vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr><cmd>hi LazyGitFloat guibg=NONE guifg=NONE<cr><cmd>setlocal winhl=NormalFloat:LazyGitFloat<cr>", { desc = "LazyGit" })
vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window (0-100)
vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
vim.g.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
vim.g.lazygit_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazygit_config_file_path = {} -- table of custom config file paths

-- Neo-tree
require("neo-tree").setup({
  event_handlers = {
    {
      event = "file_open_requested",
      handler = function()
        -- auto close
        vim.cmd("Neotree close")
        -- OR
        -- require("neo-tree.command").execute { action = "close" }
      end,
    },
  },
  filesystem = {
    window = {
      mappings = {
        ["\\"] = "close_window",
      },
    },
  },
})
vim.keymap.set("n", "\\", "Neotree float<CR>", { desc = "NeoTree Toggle" })
vim.keymap.set("n", "<leader>ngs", ":Neotree float git_status<CR>", { desc = "Neotree Open Git Status Window" })

-- Better Around/Inside textobjects
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
local statusline = require 'mini.statusline'
-- set use_icons to true if you have a Nerd Font
statusline.setup { use_icons = vim.g.have_nerd_font }

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

-- Move any selection in any direction
require('mini.move').setup({
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
    left = '<M-Left>',
    right = '<M-Right>',
    down = '<M-Down>',
    up = '<M-Up>',

    -- Move current line in Normal mode
    line_left = '<M-Left>',
    line_right = '<M-Right>',
    line_down = '<M-Down>',
    line_up = '<M-Up>',
  },

  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})
