---@class swiftline.Config
---@field modules (swiftline.ModuleConfig|swiftline.ProviderSpec)[]
---@field default_style? swiftline.StyleConfig|swiftline.Style

---@class swiftline.ModuleConfig
---@field [1] swiftline.ProviderSpec
---@field style? swiftline.StyleConfig|swiftline.Style

local M = {}

local style_resolver = require("swiftline.style-resolver")

---@param config swiftline.Config
---@return swiftline.ModuleSpec[]
function M.parse_config(config)
    local parsed_modules = {}
    for idx, module in ipairs(config.modules) do
        local provider = module[1]
        local parsed_style =
            style_resolver.resolve_style(module.style, config.default_style)
        local parsed_module = {
            provider = provider,
            style = parsed_style,
            module_idx = idx,
        }
        table.insert(parsed_modules, parsed_module)
    end
    return parsed_modules
end

return M
