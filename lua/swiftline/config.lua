---@class swiftline.Config
---@field modules (swiftline.ModuleConfig|swiftline.ProviderSpec|swiftline.Component)[]
---@field default_style? swiftline.StyleConfig|swiftline.Style

---@class swiftline.ModuleConfig
---@field [1] swiftline.ProviderSpec
---@field style? swiftline.StyleConfig|swiftline.Style

local M = {}

local style_resolver = require("swiftline.style-resolver")

local function flatten_modules(modules)
    local flat = {}
    for _, item in ipairs(modules) do
        if type(item) == "table" and item.__swiftline_component == true then
            item.__swiftline_component = nil
            for _, sub_item in ipairs(item) do
                table.insert(flat, sub_item)
            end
        else
            table.insert(flat, item)
        end
    end
    return flat
end

---@param config swiftline.Config
---@return swiftline.ModuleSpec[]
function M.parse_config(config)
    local parsed_modules = {}

    local modules = flatten_modules(config.modules)

    for idx, module in ipairs(modules) do
        local provider, style

        if type(module.get) == "function" then
            provider = module
            style = {}
        else
            provider = module[1]
            style = module.style
        end

        local parsed_style =
            style_resolver.resolve_style(style, config.default_style)

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
