-- lua/plugins/octo.lua
-- GitHub PR/issue management inside Neovim
return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>op', '<cmd>Octo pr list<cr>', desc = 'Octo: list PRs' },
    { '<leader>oo', '<cmd>Octo pr browser<cr>', desc = 'Octo: open current PR' },
    { '<leader>oc', '<cmd>Octo pr create<cr>', desc = 'Octo: create PR' },
    { '<leader>ors', '<cmd>Octo review start<cr>', desc = 'Octo: start review' },
    { '<leader>orS', '<cmd>Octo review submit<cr>', desc = 'Octo: submit review' },
    { '<leader>ord', '<cmd>Octo review discard<cr>', desc = 'Octo: discard review' },
  },
  opts = {
    use_local_fs = true,  -- LSP works in PR diffs
    enable_builtin = true,
    default_to_projects_v2 = true,
  },
}
