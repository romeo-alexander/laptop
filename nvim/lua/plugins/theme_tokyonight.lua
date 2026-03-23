local no_ul = require("user.no_semantic_underline")

return {
  "folke/tokyonight.nvim",
  name     = "tokyonight",
  priority = 1000,
  opts     = {
    style = "night",
    on_highlights = function(hl, _)
      for g, spec in pairs(no_ul) do hl[g] = spec end
    end,
  },
}
