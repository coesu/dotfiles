vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" })

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix
-----------------------------------------------

ls.config.set_config({
    history = false,
    enable_autosnippets = true,
    override_builtin = true,
    updateevents = "TextChanged,TextChangedI",
    region_check_events = "InsertEnter",
    delete_check_events = "InsertLeave",
})
-- require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })

vim.snippet.expand = ls.lsp_expand

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.active = function(filter)
    filter = filter or {}
    filter.direction = filter.direction or 1

    if filter.direction == 1 then
        return ls.expand_or_jumpable()
    else
        return ls.jumpable(filter.direction)
    end
end

---@diagnostic disable-next-line: duplicate-set-field
vim.snippet.jump = function(direction)
    if direction == 1 then
        if ls.expandable() then
            return ls.expand_or_jump()
        else
            return ls.jumpable(1) and ls.jump(1)
        end
    else
        return ls.jumpable(-1) and ls.jump(-1)
    end
end

vim.snippet.stop = ls.unlink_current

-- ================================================
--      My Configuration
-- ================================================
-- ls.config.set_config({
-- 	history = true,
-- 	updateevents = "TextChanged,TextChangedI",
-- 	override_builtin = true,
-- })

-- for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
-- 	loadfile(ft_path)()
-- end

vim.keymap.set({ "i", "s" }, "<c-u>", function()
    return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1)
end, { silent = true, desc = "testy" })

vim.keymap.set({ "i", "s" }, "<c-b>", function()
    return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1)
end, { silent = true, desc = "testy" })

require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
