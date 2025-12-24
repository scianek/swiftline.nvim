local M = {}

local render_module = require("swiftline.renderer").render_module

---@type swiftline.ModuleSpec[]
local module_specs = nil
local cached_segments = {}

---Update cache for modules that listen to the given event
---@param event_name string
local function update_cache(event_name)
    for idx, module in ipairs(module_specs) do
        if module.provider.events then
            for _, event in ipairs(module.provider.events) do
                if event == event_name then
                    cached_segments[idx] = render_module(module)
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
            cached_segments[idx] = render_module(module)
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
        if module.provider.events and #module.provider.events > 0 then
            -- Cached provider - use cached value
            segments[idx] = cached_segments[idx] or ""
        else
            -- Live provider - always re-evaluate
            segments[idx] = render_module(module)
        end
    end
    return table.concat(segments)
end

return M
