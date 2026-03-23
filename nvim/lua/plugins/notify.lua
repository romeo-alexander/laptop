-- nvim-notify: pretty toast messages + history
return {
  "rcarriga/nvim-notify",
  lazy = false,                     -- load on start so vim.notify is patched

  opts = {
    stages       = "static",
    timeout      = 1500,            -- ms
    render       = "default",       -- simple two-line format
    top_down     = false,           -- newest at the bottom right
  },

  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)

    -- Make every vim.notify call (including your Harpoon clears) use notify
    vim.notify = notify
  end,
}
