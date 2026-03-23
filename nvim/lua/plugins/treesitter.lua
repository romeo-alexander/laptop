return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "python", "lua", "bash",
        "json", "yaml", "sql",
        "markdown", "markdown_inline",
      },
    })
  end,
}