-- Copied config from https://github.com/christoomey/vim-tmux-navigator
return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<C-A-Left>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
    { '<C-A-Down>', '<cmd><C-U>TmuxNavigateDown<cr>' },
    { '<C-A-Up>', '<cmd><C-U>TmuxNavigateUp<cr>' },
    { '<C-A-Right>', '<cmd><C-U>TmuxNavigateRight<cr>' },
    -- { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
  },
}
