require("conform").setup({
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_organize_imports" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
  },

  formatters = {
    shfmt = {
      -- -i,  --indent uint       0 for tabs (default), >0 for number of spaces
      -- -bn, --binary-next-line  binary ops like && and | may start a line
      -- -ci, --case-indent       switch cases will be indented
      -- -sr, --space-redirects   redirect operators will be followed by a space
      -- -kp, --keep-padding      keep column alignment paddings
      -- -fn, --func-next-line    function opening braces are placed on a separate line
      -- -mn, --minify             minify the code to reduce its size (implies -s)
      append_args = { "--indent", "2", "--binary-next-line", "--case-indent", "--space-redirects" },
    },
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat Local buffer" })
