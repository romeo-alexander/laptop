-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts  = {
    formatters_by_ft = {
      python = { "ruff_format" },
    },

    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
}