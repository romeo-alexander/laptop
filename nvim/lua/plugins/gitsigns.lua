-- lua/plugins/gitsigns.lua -------------------------------------------------
-- Git gutter + on‑demand hunk preview (no automatic pop‑ups)

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    -- GitLens‑style blame, but you can dial it back via <leader>gb if needed
    current_line_blame      = true,
    current_line_blame_opts = {
      virt_text_pos = "eol",
      delay         = 300,   -- ms before showing blame
    },

    -- Signs (left gutter symbols) – tweak to taste
    signs = {
      add          = { text = "│" },
      change       = { text = "│" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
  },

  keys = {
    -- Manual hunk actions --------------------------------------------------
    { "<leader>hp", function() require("gitsigns").preview_hunk() end,
      desc = "Git: preview hunk" },
    { "<leader>hs", function() require("gitsigns").stage_hunk() end,
      desc = "Git: stage hunk" },
    { "<leader>hu", function() require("gitsigns").undo_stage_hunk() end,
      desc = "Git: undo stage" },
    { "<leader>hd", function() require("gitsigns").diffthis() end,
      desc = "Git: diff this file" },

    -----------------------------------------------------------------------
    -- Open current line’s commit/PR in the browser (same as before)
    -----------------------------------------------------------------------
    { "<leader>gbo", function()
        local gs   = package.loaded.gitsigns
        if not gs then return end
        local blame = gs.blame_line({ full = true })
        local sha   = blame and blame.commit and blame.commit.hash
        if not sha or sha == "0000000000000000000000000000000000000000" then
          vim.notify("No commit for this line", vim.log.levels.WARN); return
        end
        local ok = os.execute(string.format("gh browse %s --web >/dev/null 2>&1", sha))
        if ok == 0 then
          vim.notify("Opened commit " .. sha:sub(1,7) .. " in browser", vim.log.levels.INFO)
        else
          vim.notify("gh cli failed (is it installed & authed?)", vim.log.levels.ERROR)
        end
      end,
      mode = "n",
      desc = "Git: browse commit online" },
  },

  config = function(_, opts)
    local gs = require("gitsigns")
    gs.setup(opts)      -- <— no CursorHold auto‑preview this time 👌
  end,
}
