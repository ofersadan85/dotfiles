-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree toggle position=left<CR>', silent = true, desc = 'NeoTree Toggle' },
    { '<leader>ngs', ':Neotree float git_status<CR>', silent = true, desc = 'Neotree Open Git Status Window' },
  },
  opts = {
    event_handlers = {
      {
        event = 'file_open_requested',
        handler = function()
          -- auto close
          vim.cmd 'Neotree close'
          -- OR
          -- require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
