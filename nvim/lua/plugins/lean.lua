-- Lean 4 support: LSP, infoview, treesitter highlighting
return {
  "Julian/lean.nvim",
  event = { "BufReadPre *.lean", "BufNewFile *.lean" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    lsp = {},
    mappings = true, -- default keybindings
  },
}
