local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

-- Parses .bib file and extracts key + title
local function parse_bib_entries(bibfile)
    local entries = {}
    local current_key = nil
    local current_title = nil

    for line in io.lines(bibfile) do
        -- Match entry start
        local key = line:match("^@%w+{(.-),")
        if key then
            current_key = key
            current_title = nil
        end

        -- Match title line
        if current_key then
            local title = line:match("title%s*=%s*[{\"](.-)[}\"]")
            if title then
                current_title = title
                table.insert(entries, {
                    display = string.format("%s  |  %s", current_key, current_title),
                    citation_key = current_key,
                })
                current_key = nil
            end
        end
    end

    return entries
end

-- Main citation picker
local function insert_citation(cite_command)
    local bibfile = vim.fn.expand("~/Nextcloud/master-thesis/thesis/master-thesis.bib") -- Change path if needed
    local entries = parse_bib_entries(bibfile)

    pickers.new({}, {
        prompt_title = "Citations",
        finder = finders.new_table {
            results = entries,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.display,
                }
            end
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry().value
                local citation = cite_command .. "{" .. selection.citation_key .. "}"
                vim.api.nvim_put({ citation }, "c", true, true)
            end)
            return true
        end,
    }):find()
end

-- Keybindings
vim.keymap.set("i", "<C-P>", function() insert_citation("\\cite") end, { desc = "Insert \\cite{...}" })
