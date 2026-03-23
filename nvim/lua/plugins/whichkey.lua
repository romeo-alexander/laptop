-- lua/plugins/whichkey.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Suppress non-critical startup warnings
    notify = false,
    
    -- Hide Harpoon 1-9 mappings to reduce clutter
    -- Using expanded leader (space) instead of <leader>
    ignore = {
      " 1", " 2", " 3",
      " 4", " 5", " 6",
      " 7", " 8", " 9",
    },
    
    icons = {
      breadcrumb = "»",
      separator = "→",  -- Using arrow from screenshot
      group = "",       -- Remove the default "+" icon to avoid double icons
    },
    
    -- Filter to hide Harpoon 1-9 mappings
    filter = function(map)
      -- If map.lhs is not available, default to showing the map
      if not map.lhs then
        return true
      end
      
      -- Get the actual leader character (space in your config)
      local leader_char = vim.g.mapleader or " "
      
      -- Check if this is a Harpoon 1-9 mapping
      for i = 1, 9 do
        local harpoon_mapping = leader_char .. tostring(i)
        if map.lhs == harpoon_mapping then
          return false  -- Hide this mapping
        end
      end
      
      -- Alternative: Also check by description pattern
      if map.desc and type(map.desc) == "string" and map.desc:match("^Harpoon jump %d$") then
        return false  -- Hide mappings with "Harpoon jump N" description
      end
      
      return true  -- Show all other mappings
    end,
  },
  config = function(_, opts)
    local whichkey = require("which-key")
    whichkey.setup(opts)

    -- Register key mapping groups WITHOUT emojis
    -- which-key will use its default nerd font icons
    whichkey.register({
      ["<leader>"] = {
        b = { name = "Bad Practices" },   -- No emoji
        c = { name = "Code/Colors" },     -- For colors
        d = { name = "Diagnostics" },     -- For LSP diagnostics
        E = { name = "Explorer" },        -- No emoji
        f = { name = "Find/Filetree" },   -- No emoji
        g = { name = "Git" },             -- No emoji
        h = { name = "Harpoon" },         -- No emoji
        i = { name = "Indent" },          -- No emoji
        l = { name = "LSP" },             -- No emoji
        o = { name = "Octo (GitHub)" },   -- GitHub PR/issue management
        r = { name = "Run/Reload" },      -- For run commands
        s = { name = "Search" },          -- For search
        t = { name = "Toggle" },          -- For UI toggles
      }
    })

    -- Octo review subgroup
    whichkey.register({
      ["<leader>or"] = { name = "Review" },
    })
  end,
}