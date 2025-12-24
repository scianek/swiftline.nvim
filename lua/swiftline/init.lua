local M = {}

local runtime = require("swiftline.runtime")

---Render function called by statusline expression
---@return string
function M.render()
    return runtime.render()
end

---Setup the statusline
---@param config swiftline.Config
function M.setup(config)
    local module_specs = require("swiftline.config").parse_config(config)
    runtime.init(module_specs)
    vim.o.statusline = "%{%v:lua.require'swiftline'.render()%}"
end

return M
