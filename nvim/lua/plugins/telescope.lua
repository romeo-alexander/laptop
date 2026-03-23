-- lua/plugins/telescope.lua  ─────────────────────────────────────────────
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-project.nvim",
  },

  config = function()
    local telescope    = require("telescope")
    local actions      = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local harpoon      = require("harpoon")
    local pickers      = require("telescope.pickers")
    local finders      = require("telescope.finders")
    local previewers   = require("telescope.previewers")
    local conf         = require("telescope.config").values

    ----------------------------------------------------------------------
    --  Helper: always add files *with* context                          |
    ----------------------------------------------------------------------
    local function add_to_harpoon(path)
      harpoon:list():add({
        value   = vim.fn.fnamemodify(path, ":p"),
        context = { row = 1, col = 1 },
      })
    end

    ----------------------------------------------------------------------
    --  Telescope action: send selected entries → Harpoon               |
    ----------------------------------------------------------------------
    local function send_selected_to_harpoon(prompt_bufnr)
      local picker     = action_state.get_current_picker(prompt_bufnr)
      local selections = picker:get_multi_selection()
      if vim.tbl_isempty(selections) then
        table.insert(selections, action_state.get_selected_entry())
      end

      local added = 0
      for _, entry in ipairs(selections) do
        local file = entry.filename or entry.path or entry.value
        if file and #file > 0 then
          add_to_harpoon(file)
          added = added + 1
        end
      end
      vim.notify(("Harpooned %d file%s 🚀"):format(added, added ~= 1 and "s" or ""),
                 vim.log.levels.INFO)
    end

    ----------------------------------------------------------------------
    --  (rest of your Telescope setup unchanged)                         |
    ----------------------------------------------------------------------
    telescope.setup({
      defaults = {
        vimgrep_arguments = {
          "rg", "--hidden", "--smart-case", "--color=never",
          "--no-heading", "--with-filename", "--line-number", "--column",
        },
        file_ignore_patterns = { "^.git/" },
        mappings = {
          i = { ["<C-a>"] = actions.toggle_all,
                ["<C-e>"] = send_selected_to_harpoon },
          n = { ["<C-a>"] = actions.toggle_all,
                ["<C-e>"] = send_selected_to_harpoon },
        },
      },
      pickers = {
        find_files = {
          hidden       = true,
          find_command = {
            "fd", "--type", "f", "--strip-cwd-prefix",
            "--hidden", "--exclude", ".git",
          },
        },
      },
    })

    -- load extra extensions / custom pickers exactly as before …
    telescope.load_extension("project")
    -- keymaps for <leader>gfc, <leader>gS, etc. (unchanged)
  end,
}