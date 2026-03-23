-- lua/plugins/telescope-ui-select.lua
return {
  "nvim-telescope/telescope-ui-select.nvim",
  event = "VeryLazy",
  config = function()
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({})
        }
      }
    })
    require("telescope").load_extension("ui-select")
    
    -- Override vim.ui.select to use telescope
    vim.ui.select = function(...)
      require("telescope").extensions["ui-select"].select(...)
    end
  end,
}