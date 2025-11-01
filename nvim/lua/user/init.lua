require("user.set")
require("user.keymaps")

local function load_dir(dir)
    local files = vim.fn.globpath(dir, "*.lua", false, true)
    for _, file in ipairs(files) do
        local mod = file:match("lua/(.*)%.lua$")
        mod = mod:gsub("/", ".")
        require(mod)
    end
end

load_dir(vim.fn.stdpath("config") .. "/lua/user/plugins")
