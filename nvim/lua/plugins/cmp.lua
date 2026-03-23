return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",

  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    { "L3MON4D3/LuaSnip", submodules = false },
    "saadparwaiz1/cmp_luasnip",
  },

  opts = function()
    local cmp = require("cmp")
    local ls  = require("luasnip")

    return {
      completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
        completeopt  = "menuone,noinsert,noselect",
      },

      -- transparent popup (you won’t notice it)
      window = {
        completion = cmp.config.window.bordered({
          winblend = 100,
          border   = "none",
          winhighlight = "Normal:Normal,FloatBorder:Normal",
        }),
        documentation = cmp.config.disable,
      },

      experimental = { ghost_text = { hl_group = "Comment" } },

      snippet = { expand = function(args) ls.lsp_expand(args.body) end },

      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
          elseif ls.expand_or_jumpable() then
            ls.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif ls.jumpable(-1) then
            ls.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<C-Space>"] = cmp.mapping.complete(), -- explicit menu
        ["<CR>"]      = function(fallback) fallback() end,
      }),

      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
        { name = "luasnip" },
      },
    }
  end,
}
