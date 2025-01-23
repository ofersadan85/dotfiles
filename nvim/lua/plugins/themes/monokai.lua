return {
  'tanvirtin/monokai.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    local onedark = require('monokai')
    local config = {
      palette = onedark.pro
    }
    onedark.setup(config)
  end,
}
