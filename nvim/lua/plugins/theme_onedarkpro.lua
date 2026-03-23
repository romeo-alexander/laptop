-- lua/plugins/theme_onedarkpro.lua  ← final version
local no_ul = {
  ["@lsp.type.property"]  = { style = "NONE" },
  ["@lsp.type.field"]     = { style = "NONE" },
  ["@lsp.type.variable"]  = { style = "NONE" },
  ["@lsp.type.parameter"] = { style = "NONE" },
}

return {
  "olimorris/onedarkpro.nvim",
  name     = "onedarkpro",
  priority = 1000,
  opts     = {
    options    = { terminal_colors = true },
    highlights = no_ul,      -- <- **table**, not a function
  },
}