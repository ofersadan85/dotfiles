-- <leader> key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true }

-- Map arrow keys for navigation
vim.keymap.set('n', '<Up>', 'k', opts)
vim.keymap.set('n', '<Down>', 'j', opts)
vim.keymap.set('n', '<Left>', 'h', opts)
vim.keymap.set('n', '<Right>', 'l', opts)

-- undo / redo
vim.keymap.set({ 'n', 'i' }, '<C-z>', '<cmd> undo <CR>', opts)
vim.keymap.set({ 'n', 'i' }, '<C-y>', '<cmd> redo <CR>', opts)

-- save file
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd> w <CR>', opts)

-- quit file
vim.keymap.set({ 'n', 'i' }, '<C-q>', '<cmd> mksession! .session.vim <CR><cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Increment/decrement numbers
vim.keymap.set('n', '<leader>+', '<C-a>', opts) -- increment
vim.keymap.set('n', '<leader>-', '<C-x>', opts) -- decrement

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<A-Up>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<A-Down>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<A-Left>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<A-Right>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Move text up and down
vim.keymap.set('v', '<A-Down>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-Up>', ':m .-2<CR>==', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Replace word under cursor
vim.keymap.set('n', '<leader>j', '*``cgn', opts)

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- Save and load session
vim.keymap.set('n', '<leader>ss', ':mksession! .session.vim<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>sl', ':source .session.vim<CR>', { noremap = true, silent = false })
