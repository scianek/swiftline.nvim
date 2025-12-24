---@class swiftline.Component
local Component = {}
Component.__index = Component

---Creates a new Component (a group of modules)
---@param modules table[] Array of module configs
---@return swiftline.Component Marked array that will be flattened during config parsing
function Component:new(modules)
    modules["__swiftline_component"] = true
    return modules
end

return Component
