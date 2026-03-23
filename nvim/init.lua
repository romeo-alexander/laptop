--───────────────────────────────────────────────────────────────────────────
--  init.lua – core config (Neogit-only version)
--───────────────────────────────────────────────────────────────────────────

--------------------------------------------------------------------- OPTIONS
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true
vim.opt.smartindent = true
vim.opt.hidden      = true
vim.g.mapleader     = " "
vim.opt.clipboard   = "unnamedplus"    -- Use system clipboard
vim.opt.timeoutlen  = 300              -- reduce timeout for mappings (default 1000ms)
vim.opt.termguicolors = true           -- Enable true colors and squiggly lines

vim.opt.fillchars:append({ diff = " " })  -- blank diff filler lines
vim.opt.laststatus = 3                    -- single statusline
vim.opt.cmdheight  = 0                    -- share row with cmd-line
vim.opt.shortmess:append("FW")            -- hide “written / yanked” spam

local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg and type(msg) == "string" and msg:match("which%-key") and level == vim.log.levels.WARN then
    return -- Suppress which-key warnings
  end
  orig_notify(msg, level, opts)
end
----------------------------------------------------------------- BOOTSTRAP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------- LOAD PLUGINS
require("lazy").setup({ import = "plugins" })

--------------------------------------------------------------------- KEYMAPS
local builtin = require("telescope.builtin")

-- Telescope pickers --------------------------------------------------------
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep"  })
vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers"    })

-- PR-changed files picker --------------------------------------------------
vim.keymap.set("n", "<leader>gp", function()
  -- Get the base branch dynamically
  local base_branch = vim.fn.systemlist("git symbolic-ref refs/remotes/origin/HEAD")[1]
  if base_branch then
    base_branch = base_branch:gsub("refs/remotes/origin/", "")
  else
    base_branch = "master" -- fallback
  end
  
  builtin.find_files({
    prompt_title = "PR-changed files",
    find_command = { "git", "diff", "--name-only", "origin/" .. base_branch .. "...HEAD" },
  })
end, { desc = "Telescope: PR files" })

-- PR files to Harpoon -------------------------------------------------------
vim.keymap.set("n", "<leader>ghp", function()
  -- Load current PR files into Harpoon for easy cycling
  local harpoon = require('harpoon')
  local list = harpoon:list()
  list:clear()
  
  -- Get the base branch dynamically
  local base_branch = vim.fn.systemlist("git symbolic-ref refs/remotes/origin/HEAD")[1]
  if base_branch then
    base_branch = base_branch:gsub("refs/remotes/origin/", "")
  else
    base_branch = "master" -- fallback
  end
  
  local root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local files = vim.fn.systemlist('git diff --name-only origin/' .. base_branch .. '...HEAD')
  
  for _, rel in ipairs(files) do
    rel = vim.fn.trim(rel)
    if rel ~= '' then
      local abs = vim.fn.fnamemodify(root .. '/' .. rel, ':p')
      if vim.fn.filereadable(abs) == 1 then
        list:add({ value = abs, context = { row = 1, col = 1 } })
      end
    end
  end
  
  if list.sync then list:sync() end
  vim.notify('Harpooned ' .. list:length() .. ' PR files 🎯', vim.log.levels.INFO)
end, { desc = "Harpoon: load PR files" })

-- reload this config -------------------------------------------------------
vim.keymap.set("n", "<leader>rc", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("init.lua reloaded ✅", vim.log.levels.INFO)
end, { desc = "Reload init.lua" })

-- Manual formatter (uses conform.nvim) --------------------------------------
vim.keymap.set("n", "<leader>rf", function()
  require("conform").format({ bufnr = 0 })
end, { desc = "Format buffer" })

--───────────────────────────────────────────────────────────────────────────
-- Theme cycler --------------------------------------------------------------
vim.keymap.set("n", "<leader>cs", function()
  local themes = { "catppuccin", "tokyonight", "onedark", "rose-pine" }
  local current = vim.g.colors_name or ""
  local pos = 1
  for i, v in ipairs(themes) do
    if vim.startswith(current, v) then pos = i; break end
  end
  local next = themes[(pos % #themes) + 1]
  if pcall(vim.cmd.colorscheme, next) then
    vim.notify("Theme: " .. next, vim.log.levels.INFO)
  else
    vim.notify("Theme not installed: " .. next, vim.log.levels.WARN)
  end
end, { desc = "Cycle colourscheme" })

----------------------------------------------------------------- DEFAULT THEME
pcall(vim.cmd.colorscheme, "onedark")  -- set default theme

-- Force diagnostic underlines to be squiggly (must be after colorscheme)
local function set_diagnostic_undercurl()
  vim.cmd([[
    let &t_Cs = "\e[4:3m"   " Smulx
    let &t_Ce = "\e[4:0m"   " Rmulx (4:0 turns underline off)
  ]])

  vim.cmd [[
    highlight DiagnosticUnderlineError  cterm=undercurl ctermfg=160 gui=undercurl guisp=#FF5555
    highlight DiagnosticUnderlineWarn   cterm=undercurl ctermfg=214 gui=undercurl guisp=#FFA500
    highlight DiagnosticUnderlineInfo   cterm=undercurl ctermfg=117 gui=undercurl guisp=#61AFEF
    highlight DiagnosticUnderlineHint   cterm=undercurl ctermfg=251 gui=undercurl guisp=#AAAAAA
  ]]
end

set_diagnostic_undercurl()

-- Reapply undercurl when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_diagnostic_undercurl,
})

-------------------------------------------------------------------------------
-- Quick toggles for UI bars --------------------------------------------------
-------------------------------------------------------------------------------
local ui_toggles = {
  statusline  = function() vim.opt.laststatus = vim.opt.laststatus:get() == 0 and 3 or 0 end,
  tabline     = function() vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 2 or 0 end,
  cursorline  = function() vim.opt.cursorline  = not vim.opt.cursorline:get() end,
}

vim.keymap.set("n", "<leader>ts", ui_toggles.statusline, { desc = "Toggle statusline" })
vim.keymap.set("n", "<leader>tt", ui_toggles.tabline,    { desc = "Toggle tabline" })
vim.keymap.set("n", "<leader>tc", ui_toggles.cursorline, { desc = "Toggle cursorline" })
