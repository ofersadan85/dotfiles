require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    python = { "ruff_format", "ruff_organize_imports" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
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
