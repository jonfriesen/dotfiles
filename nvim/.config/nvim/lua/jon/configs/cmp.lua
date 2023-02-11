-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local ok, lspkind = pcall(require, "lspkind")
if not ok then
  print "not ok"
  return
end

lspkind.init()

cmp.setup {
    window = {
        completion = {
            border = "rounded",
            scrollbar = "",
        },
        documentation = {
            border = "rounded",
            scrollbar = "",
        },
    },
    snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs( -4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable( -1) then
            luasnip.jump( -1)
          else
            fallback()
          end
        end, { 'i', 's' }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer",                 keyword_length = 5 },
        { name = "nvim_lsp_signature_help" },
    },
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
            },
        },
    },

    experimental = {
        ghost_text = true,
    },
}

-- Insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done()
)
