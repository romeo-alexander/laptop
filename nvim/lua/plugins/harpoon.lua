-- lua/plugins/harpoon.lua  ────────────────────────────────────────────────
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",

  config = function()
    ----------------------------------------------------------------------
    --  Helper so *every* add gets a context                             |
    ----------------------------------------------------------------------
    local function add_with_context(list, path, row, col)
      list:add({
        value   = vim.fn.fnamemodify(path, ":p"),
        context = { row = row or 1, col = col or 1 },
      })
    end

    ----------------------------------------------------------------------
    --  Standard Harpoon setup                                           |
    ----------------------------------------------------------------------
    local hp   = require("harpoon")
    hp:setup({
      settings = {
        save_on_toggle = false,  -- don't persist to disk
        save_on_change = false,
      },
    })
    local list = hp:list()
    local map, notify = vim.keymap.set, vim.notify
    local idx = 1

    -- one-time sanitiser (in case old items are still missing context)
    do
      local dirty = false
      for i, it in ipairs(list.items or {}) do
        if not it.context then
          it.context = { row = 1, col = 1 }
          dirty = true
        end
      end
      -- persistence disabled
    end

    ----------------------------------------------------------------------
    --  <leader>ha  – add current file                                   |
    ----------------------------------------------------------------------
    map("n", "<leader>ha", function()
      add_with_context(list,
        vim.api.nvim_buf_get_name(0),
        vim.fn.line("."),
        vim.fn.col("."))
      idx = list:length()
      notify("Harpooned " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
    end, { desc = "Harpoon add file" })

    ----------------------------------------------------------------------
    --  <leader>hr  – remove current file                                |
    ----------------------------------------------------------------------
    map("n", "<leader>hr", function()
      local cur = vim.api.nvim_buf_get_name(0)
      for i, it in ipairs(list.items) do
        if it.value == cur then
          list:remove_at(i)
          -- no sync needed
          if idx >= i then idx = math.max(1, idx - 1) end
          notify("Removed " .. vim.fn.expand("%:t") .. " from Harpoon",
                 vim.log.levels.INFO)
          return
        end
      end
      notify("File not in Harpoon list", vim.log.levels.WARN)
    end, { desc = "Harpoon remove file" })

    ----------------------------------------------------------------------
    --  Quick-menu & navigation                                          |
    ----------------------------------------------------------------------
    map("n", "<leader>hm", function() hp.ui:toggle_quick_menu(list) end,
        { desc = "Harpoon menu" })

    for i = 1, 9 do
      map("n", "<leader>" .. i, function()
        if vim.api.nvim_get_option_value("modified", { buf = 0 }) then
          vim.cmd("update")
        end
        list:select(i); idx = i
      end, { desc = "Harpoon jump " .. i })
    end

    local function jump(step)
      local len = list:length()
      if len == 0 then notify("Harpoon list empty", vim.log.levels.INFO); return end
      idx = ((idx - 1 + step) % len) + 1
      list:select(idx)
    end

    map("n", ";", function() if vim.api.nvim_get_option_value("modified",{buf=0}) then vim.cmd("update") end ; jump(1)  end,
        { desc = "Harpoon next" })
    map("n", ",", function() if vim.api.nvim_get_option_value("modified",{buf=0}) then vim.cmd("update") end ; jump(-1) end,
        { desc = "Harpoon prev" })

    ----------------------------------------------------------------------
    --  <leader>hx – clear everything                                    |
    ----------------------------------------------------------------------
    map("n", "<leader>hx", function()
      list:clear(); -- no sync needed
      notify("Harpoon list cleared 🗑️", vim.log.levels.INFO)
    end, { desc = "Harpoon clear all" })
  end,
}