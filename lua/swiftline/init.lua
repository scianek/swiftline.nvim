local M = {}

local module_specs

local render_module = require("swiftline.renderer").render_module

function M.render()
    local segments = {}
    for idx, _ in ipairs(module_specs) do
        segments[idx] = render_module(module_specs[idx])
    end
    return table.concat(segments)
end

---@param config swiftline.Config The configuration table
function M.setup(config)
    module_specs = require("swiftline.config").parse_config(config)
    vim.o.statusline = "%{%v:lua.require'swiftline'.render()%}"
end

return M
