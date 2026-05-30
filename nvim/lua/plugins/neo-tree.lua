-- Neo-tree is a Neovim plugin to browse the file system
vim.pack.add({ 'https://github.com/nvim-lua/plenary.nvim' })  -- General lua code for other plugins
vim.pack.add({ 'https://github.com/nvim-tree/nvim-web-devicons' })  -- Nerd Font icons (glyphs)
vim.pack.add({ 'https://github.com/MunifTanjim/nui.nvim' })  -- Neovim UI utilities
vim.pack.add({ 'https://github.com/nvim-neo-tree/neo-tree.nvim' })
require('neo-tree').setup({
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
})
vim.keymap.set('n', '\\', 'Neotree float<CR>', { desc = 'NeoTree Toggle' })
vim.keymap.set('n', '<leader>ngs', ':Neotree float git_status<CR>', { desc = 'Neotree Open Git Status Window' })

