local M = {}

local render_module = require("swiftline.renderer").render_module

---@type swiftline.ModuleSpec[]
local module_specs = nil
local cached_provider_results = {}

---Update cache for modules that listen to the given event
---@param event_name string
local function update_cache(event_name)
    for idx, module in ipairs(module_specs) do
        if module.provider.events then
            for _, event in ipairs(module.provider.events) do
                if event == event_name then
                    cached_provider_results[idx] = module.provider.get()
                    break
                end
            end
        end
    end
end

---Setup autocmds for all event-based providers
local function setup_autocmds()
    local events = {}
    for _, module in ipairs(module_specs) do
        if module.provider.events then
            for _, event in ipairs(module.provider.events) do
                events[event] = true
            end
        end
    end

    for event in pairs(events) do
        local event_name = event
        local pattern = nil

        if event:match("^User%s") then
            event_name = "User"
            pattern = event:match("User%s+(.+)")
        end

        vim.api.nvim_create_autocmd(event_name, {
            pattern = pattern,
            callback = function()
                update_cache(event)
            end,
        })
    end
end

---Initialize runtime with parsed module specs
---@param specs swiftline.ModuleSpec[]
function M.init(specs)
    module_specs = specs

    -- Initialize cache for event-based providers
    for idx, module in ipairs(module_specs) do
        if module.provider.events and #module.provider.events > 0 then
            cached_provider_results[idx] = module.provider.get()
        end
    end

    -- Setup event handlers
    setup_autocmds()
end

---Generate the complete statusline string
---@return string
function M.render()
    local segments = {}
    for idx, module in ipairs(module_specs) do
        local provider_result

        if module.provider.events and #module.provider.events > 0 then
            -- Use cached provider result
            provider_result = cached_provider_results[idx]
        else
            -- Get fresh result for live providers
            provider_result = module.provider.get()
        end

        -- Always render (re-evaluates dynamic styles every time)
        segments[idx] = render_module(module, provider_result)
    end
    return table.concat(segments)
end

return M
