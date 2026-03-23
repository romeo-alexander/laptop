return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs").setup({
      -- add JSON, YAML, and Markdown (incl. inline) parsers
      ensure_installed = {
        "python", "lua", "bash",
        "json", "yaml", "sql",
        "markdown", "markdown_inline",
      },

      highlight = { enable = true },
      indent    = { enable = true },
    })
  end,
}