return {
  'dnlhc/glance.nvim',
  -- Lazy will create these key-maps *and* load the plugin on first use
  keys = {
    { 'gd', '<CMD>Glance definitions<CR>',        desc = 'Peek definitions'         },
    { 'gD', '<CMD>Glance type_definitions<CR>',   desc = 'Peek type-definitions'    },
    { 'gr', '<CMD>Glance references<CR>',         desc = 'Peek references'          },
    { 'gi', '<CMD>Glance implementations<CR>',    desc = 'Peek implementations'     },
  },
  opts = {},   -- keep all defaults (window layout, etc.)
}