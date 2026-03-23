-- lua/plugins/peek.lua
return {
  "toppair/peek.nvim",
  build = "deno task --quiet build",   -- <- change here
  ft    = "markdown",
  keys  = {
    { "<leader>mp", function() require("peek").open() end,  desc = "Markdown preview" },
    { "<leader>mP", function() require("peek").close() end, desc = "Markdown preview • close" },
  },
  opts  = { theme = "dark" },          -- optional
}