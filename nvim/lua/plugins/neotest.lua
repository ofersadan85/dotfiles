require("neotest").setup({
  adapters = {
    -- Python: pytest (default), unittest also supported
    require("neotest-python")({
      dap = { justMyCode = false },
      runner = "pytest",
      -- Use the project venv's python if available
      python = function()
        if vim.env.VIRTUAL_ENV then
          local is_win = vim.fn.has("win32") == 1
          local exe = is_win and "python.exe" or "python"
          local p = vim.fs.joinpath(vim.env.VIRTUAL_ENV, is_win and "Scripts" or "bin", exe)
          if vim.fn.executable(p) == 1 then
            return p
          end
        end
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end,
    }),

    -- Rust: cargo test / nextest
    require("neotest-rust")({
      args = { "--no-capture" },
    }),

    -- TypeScript/JavaScript: Vitest
    require("neotest-vitest"),
  },

  -- Show diagnostics for failed tests
  diagnostic = { enabled = true },
  output = { enabled = true, open_on_run = "short" },
  output_panel = { enabled = true },
  status = { enabled = true, virtual_text = true, signs = true },
  summary = {
    enabled = true,
    animated = true,
    follow = true,
    expand_errors = true,
  },
})

-- ─── Keymaps ─────────────────────────────────────────────────────────────────
local km = vim.keymap.set
local nt = require("neotest")
km("n", "<leader>nr", function() nt.run.run() end, { desc = "[N]eotest [R]un nearest test" })
km("n", "<leader>nf", function() nt.run.run(vim.fn.expand("%")) end, { desc = "[N]eotest run [F]ile" })
km("n", "<leader>na", function() nt.run.run(vim.fn.getcwd()) end, { desc = "[N]eotest run [A]ll tests" })
km("n", "<leader>nd", function() nt.run.run({ strategy = "dap" }) end, { desc = "[N]eotest [D]ebug nearest" })
km("n", "<leader>ns", function() nt.summary.toggle() end, { desc = "[N]eotest Toggle [S]ummary" })
km("n", "<leader>no", function() nt.output_panel.toggle() end, { desc = "[N]eotest Toggle [O]utput Panel" })
km("n", "<leader>nq", function() nt.run.stop() end, { desc = "[N]eotest [Q]uit / Stop" })
km("n", "]t", function() nt.jump.next({ status = "failed" }) end, { desc = "Next failed test" })
km("n", "[t", function() nt.jump.prev({ status = "failed" }) end, { desc = "Prev failed test" })
