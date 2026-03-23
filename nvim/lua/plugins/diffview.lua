-- lua/plugins/diffview.lua
-- Side-by-side diff viewer with file tree navigation
return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview: open' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Diffview: close' },
    { '<leader>ghf', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview: file history' },
    { '<leader>gm', function()
        -- Auto-detect base branch (master or main)
        local base = vim.fn.systemlist("git symbolic-ref refs/remotes/origin/HEAD")[1]
        if base then
          base = base:gsub("refs/remotes/", "")
        else
          base = "origin/master"  -- fallback
        end
        vim.cmd("DiffviewOpen " .. base .. "...HEAD")
      end, desc = 'Diffview: vs base branch' },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      merge_tool = {
        layout = "diff3_mixed",
      },
    },
  },
}
