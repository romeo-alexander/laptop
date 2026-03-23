-- Neovim LSP setup: Pyright · Ruff · JSON
-- Nvim 0.11+ using vim.lsp.config / vim.lsp.enable
-- Silent-until-asked philosophy:
--   • No automatic hover pop-ups
--   • No inline virtual-text diagnostics
--   • Diagnostics float only on <leader>ld

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",  -- still needed for configs in lsp/
    "b0o/schemastore.nvim",
  },

  config = function()
    ---------------------------------------------------------------- Mason
    require("mason").setup({ PATH = "prepend" })
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "ruff", "jsonls" },
      automatic_installation = true,
    })

    ---------------------------------------------------------------- Diagnostic UI (global)
    vim.diagnostic.config({
      virtual_text     = false,
      underline        = true,
      signs            = false,
      update_in_insert = false,
      severity_sort    = true,
    })

    ---------------------------------------------------------------- Capabilities
    local caps = vim.lsp.protocol.make_client_capabilities()
    caps.offsetEncoding = { "utf-16", "utf-8" }
    caps = require("cmp_nvim_lsp").default_capabilities(caps)

    ---------------------------------------------------------------- LspAttach autocmd (keymaps + ruff tweak)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- Disable hover for ruff (pyright handles it)
        if client and client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end
        -- Diagnostics float keymap
        vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float,
          { buffer = args.buf, desc = "Line diagnostics" })
      end,
    })

    ---------------------------------------------------------------- Server configs
    local schemastore = require("schemastore")

    vim.lsp.config("pyright", {
      capabilities = caps,
      root_markers = { "pyproject.toml", "setup.cfg", "requirements.txt", ".git" },
    })

    vim.lsp.config("ruff", {
      capabilities = caps,
      init_options = {
        settings = { organizeImports = true, fixAll = true, format = { preview = false } },
      },
    })

    vim.lsp.config("jsonls", {
      capabilities = caps,
      settings = {
        json = {
          schemas  = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    })

    ---------------------------------------------------------------- Enable all servers
    vim.lsp.enable({ "pyright", "ruff", "jsonls" })
  end,
}
