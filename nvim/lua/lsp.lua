require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "bashls",
    "lua_ls",
    "pyright",
    "ruff",
    "rust_analyzer",
    "ts_ls",
  },
  automatic_enable = true,
})

-- Auto-install formatters and linters via Mason
require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",
    "prettier",
    "shfmt",
  },
  auto_update = false,
  run_on_start = true,
})

local snippets = require("mini.snippets")
local gen_loader = snippets.gen_loader
snippets.setup({
  snippets = {
    gen_loader.from_lang(),
  },
})
snippets.start_lsp_server()

require("mini.completion").setup({
  delay = {
    completion = 80,
    info = 80,
    signature = 25,
  },
  window = {
    info = { border = "rounded" },
    signature = { border = "rounded" },
  },
})

local imap_expr = function(lhs, rhs, desc)
  vim.keymap.set("i", lhs, rhs, { expr = true, desc = desc })
end
imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], "Completion next item")
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], "Completion previous item")

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "List references" })
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
vim.keymap.set("n", "df", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Symbol documentation" }) -- Use <Ctrl-O>K in insert mode
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame symbol" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
vim.keymap.set("n", "<leader>ti", function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
  vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
end, { desc = "[T]oggle [I]nlay Hints" })

vim.diagnostic.config({ virtual_text = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
vim.lsp.config("*", { capabilities = capabilities })

local function detect_project_venv_python(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end

  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  local python_dir = is_windows and "Scripts" or "bin"
  local python_exe = is_windows and "python.exe" or "python"

  for _, venv_name in ipairs({ ".venv", "venv", "env" }) do
    local python_path = vim.fs.joinpath(root_dir, venv_name, python_dir, python_exe)
    if vim.fn.executable(python_path) == 1 then
      return python_path, venv_name
    end
  end
  return nil
end

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      lens = {
        debug = { enable = true },
        enable = true,
        implementations = { enable = true },
        references = {
          adt = { enable = true },
          enumVariant = { enable = true },
          method = { enable = true },
          trait = { enable = true },
        },
        run = { enable = true },
        updateTest = { enable = true },
      },
      cargo = { allFeatures = true },
      procMacro = { enable = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

vim.lsp.config("ruff", {})
vim.lsp.config("ty", {})

vim.lsp.config("ts_ls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        typeCheckingMode = "basic",
      },
    },
  },
})

-- Set VIRTUAL_ENV automatically when opening a Python file, and inform pyright of the venv's python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(args)
    local root_dir = vim.fs.root(args.buf, { ".git", "pyproject.toml", "setup.py", "requirements.txt", ".venv", "venv", "env" })
    if not root_dir then
      return
    end

    local python_path, venv_name = detect_project_venv_python(root_dir)
    if python_path then
      local venv_dir = vim.fs.joinpath(root_dir, venv_name)
      if vim.env.VIRTUAL_ENV ~= venv_dir then
        vim.env.VIRTUAL_ENV = venv_dir
        local bin_dir = vim.fs.dirname(python_path)
        local sep = (vim.fn.has("win32") == 1) and ";" or ":"
        vim.env.PATH = bin_dir .. sep .. vim.env.PATH
      end
      -- Inform pyright of the exact interpreter so it resolves venv packages correctly
      vim.lsp.config("pyright", {
        settings = {
          python = {
            pythonPath = python_path,
          },
        },
      })
    end
  end,
})
