return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
  keys = {
    { "<leader>fe", "<Cmd>NvimTreeToggle<CR>",    desc = "File tree toggle" },
    { "<leader>E", "<Cmd>NvimTreeFindFile<CR>",  desc = "Reveal file in tree" },
  },
  opts = {
    view = {
      -- **Adaptive width**: grows just enough for the longest entry
      adaptive_size = true,
      signcolumn = "no",
      preserve_window_proportions = true,
    },
    renderer = {
      root_folder_label = false,        -- don't shorten the project root
      highlight_opened_files = "name",
      indent_width = 1,
    },
    git      = { ignore = false },      -- show everything (even in .gitignore)
    filters  = { dotfiles = false },
    hijack_cursor = true,               -- keep cursor in tree on open
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}