local no_ul = require("user.no_semantic_underline")

return {
  "rose-pine/neovim",
  name     = "rose-pine",
  priority = 1000,
  opts     = {
    variant          = "main",
    highlight_groups = no_ul,
  },
}
