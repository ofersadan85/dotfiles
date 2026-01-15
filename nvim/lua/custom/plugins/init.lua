return {
  {
    'https://github.com/folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('tokyonight').setup {
        transparent = true, -- Disable backgrounds
      }
      vim.cmd.colorscheme 'tokyonight-moon'
    end,
  },

  { -- Highlight todo, notes, etc in comments
    'https://github.com/folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  { -- Persistent terminal window
    'https://github.com/akinsho/toggleterm.nvim',
    version = '*',
    opts = { open_mapping = [[<c-t>]] },
  },

  { -- Easily comment visual regions/lines
    'https://github.com/numToStr/Comment.nvim',
    opts = {
      -- Ctrl + _ is often the same as Ctrl + / in terminals
      -- So we set <C-_> to get <C-/>
      toggler = { line = '<C-_>' },
      opleader = { line = '<C-_>' },
    },
  },

  { -- Welcome screen
    'https://github.com/goolord/alpha-nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.startify'
      alpha.setup(dashboard.opts)
    end,
  },

  { -- Add indentation guides even on blank lines
    'https://github.com/lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  { -- autopairs
    'https://github.com/windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },

  { 'https://github.com/rmagatti/auto-session', lazy = false, opts = {} }, -- Auto save and restore sessions
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
}
