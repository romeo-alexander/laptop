local no_ul = require("user.no_semantic_underline")

return {
  "catppuccin/nvim",
  name     = "catppuccin",
  priority = 1000,
  opts     = {
    flavour = "mocha",
    highlight_overrides = { all = no_ul },
  },
}
