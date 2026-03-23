-- lua/plugins/gitlinker.lua  (replace the old key block)
return {
  'linrongbin16/gitlinker.nvim',
  event = 'VeryLazy',
  config = function()
    require('gitlinker').setup()          -- mandatory!
  end,
  keys = {
    -- yank to clipboard
    { '<leader>gy', '<cmd>GitLink<cr>',  mode = { 'n', 'v' },
      desc = 'GitLink: yank permalink' },

    -- open in default browser (the "!" makes it open instead of copy)
    { '<leader>go', '<cmd>GitLink!<cr>', mode = { 'n', 'v' },
      desc = 'GitLink: open permalink' },
  },
}