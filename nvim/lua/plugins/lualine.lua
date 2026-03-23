-- lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  event   = "VeryLazy",
  opts    = { options = { theme = "auto", section_separators = "", component_separators = "" } },
  config  = function(_, opts) require("lualine").setup(opts) end,
}