vim.pack.add({ "https://github.com/zk-org/zk-nvim" })

local zk = require("zk")

zk.setup({

    picker = "fzf_lua",

    lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
            name = "zk",
            cmd = { "zk", "lsp" },
            filetypes = { "markdown" },
            -- on_attach = ...
            -- etc, see `:h vim.lsp.start()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
            enabled = true,
        },
    },
})

local fzf_lua_picker = require("zk.pickers.fzf_lua")
fzf_lua_picker.note_picker_list_api_selection = { "title", "lead", "absPath", "path" }

local show_note_picker = fzf_lua_picker.show_note_picker
fzf_lua_picker.show_note_picker = function(notes, options, cb)
    for _, note in ipairs(notes) do
        local lead = vim.trim(note.lead or ""):gsub("^#+%s*", "")
        local paper_title = lead:match("^.-%s+—%s+(.+)$")
        local is_literature_note = (note.absPath or ""):match("/lit/") ~= nil

        if is_literature_note and lead ~= "" and lead ~= note.title then
            note.title = note.title .. " — " .. (paper_title or lead)
        end
    end

    show_note_picker(notes, options, cb)
end

local opts = { noremap = true, silent = false }

-- Create a new note after asking for its title.
vim.api.nvim_set_keymap("n", "<leader>on", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)

-- Open notes.
-- Open notes associated with the selected tags.
vim.api.nvim_set_keymap("n", "<leader>ot", "<Cmd>ZkTags<CR>", opts)

local commands = require("zk.commands")
commands.add("ZkOrphans", function(options)
    options = vim.tbl_extend("force", { orphan = true }, options or {})
    zk.edit(options, { title = "Zk Orphans" })
end)

local fzf = require("fzf-lua")
vim.api.nvim_create_user_command("ZkGrep", function()
    fzf.live_grep_native({
        cwd = vim.env.ZK_NOTEBOOK_DIR,
    })
end, {})

vim.api.nvim_set_keymap("n", "<leader>of", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", opts)
-- Search for the notes matching a given query.
vim.api.nvim_set_keymap("n", "<leader>os", "<Cmd>ZkGrep<CR>", opts)
vim.api.nvim_set_keymap("v", "<leader>os", ":'<,'>ZkMatch<CR>", opts)

vim.keymap.set("n", "<leader>oj", function() zk.new({ dir = "journal" }) end, { desc = "New journal note" })


vim.pack.add({
    -- 'https://github.com/nvim-treesitter/nvim-treesitter',
    -- 'https://github.com/nvim-mini/mini.nvim',            -- if you use the mini.nvim suite
    -- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
    -- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
    'https://github.com/jalvesaq/zotcite',
})
require('zotcite').setup({})

vim.keymap.set("n", "<leader>oL", function()
    local output = vim.fn.systemlist("zk-lit --list")

    if vim.v.shell_error ~= 0 then
        vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
        return
    end

    local ok, entries = pcall(vim.json.decode, table.concat(output, "\n"))

    if not ok or type(entries) ~= "table" then
        vim.notify("Could not parse zk-lit output", vim.log.levels.ERROR)
        return
    end

    local lines = {}
    local by_line = {}

    for _, entry in ipairs(entries) do
        local line = entry.label
        table.insert(lines, line)
        by_line[line] = entry
    end

    require("fzf-lua").fzf_exec(lines, {
        prompt = "Zotero entry> ",
        winopts = {
            title = " Create literature note ",
            preview = {
                hidden = "hidden",
            },
        },
        actions = {
            ["default"] = function(selected)
                local line = selected[1]
                local entry = by_line[line]

                if not entry then
                    vim.notify("Could not resolve selected Zotero entry", vim.log.levels.ERROR)
                    return
                end

                local cmd = "zk-lit --create " .. vim.fn.shellescape(entry.citekey)
                local result = vim.fn.systemlist(cmd)

                if vim.v.shell_error ~= 0 then
                    vim.notify(table.concat(result, "\n"), vim.log.levels.ERROR)
                    return
                end

                local note_path = result[#result]

                if not note_path or note_path == "" then
                    vim.notify("zk-lit did not return a note path", vim.log.levels.ERROR)
                    return
                end

                vim.cmd("edit " .. vim.fn.fnameescape(note_path))
            end,
        },
    })
end, { desc = "Create/open literature note from Zotero entry" })

local function get_yaml_field(field)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    if lines[1] ~= "---" then
        return nil
    end

    for i = 2, #lines do
        local line = lines[i]

        if line == "---" then
            break
        end

        local value = line:match("^" .. field .. ":%s*(.+)%s*$")

        if value then
            value = value:gsub('^"', ""):gsub('"$', "")
            value = value:gsub("^'", ""):gsub("'$", "")
            return value
        end
    end

    return nil
end

local function open_lit_pdf()
    local pdf = get_yaml_field("pdf")

    if not pdf or pdf == "" then
        vim.notify("No pdf field found in this note", vim.log.levels.WARN)
        return
    end

    pdf = vim.fn.expand(pdf)

    if pdf:match("^zotero://") or pdf:match("^https?://") then
        vim.ui.open(pdf)
        return
    end

    if vim.fn.filereadable(pdf) ~= 1 then
        vim.notify("PDF file not found: " .. pdf, vim.log.levels.ERROR)
        return
    end

    vim.ui.open(pdf)
end

vim.keymap.set("n", "<leader>op", open_lit_pdf, {
    desc = "Open literature PDF",
})

vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })
