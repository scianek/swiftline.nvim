---@class swiftline.SeparatorSpec
---Normalized separator specification with both sides fully defined.
---@field left swiftline.SeparatorSideSpec Left separator (fully normalized)
---@field right swiftline.SeparatorSideSpec Right separator (fully normalized)

---@class swiftline.SeparatorSideSpec
---Normalized specification for one side of a separator.
---Character(s) and style are guaranteed to be present.
---@field [1] string The separator character(s)
---@field style vim.api.keyset.highlight Style for this separator side (always present, may be empty table)

---@class swiftline.Separator: swiftline.SeparatorSpec
local Separator = {}
Separator.__index = Separator

---Creates a new Separator
---@param left string|swiftline.SeparatorSideSpec|nil Left separator side (string or full spec). If nil, defaults to "".
---@param right string|swiftline.SeparatorSideSpec|nil Right separator side (string or full spec). If nil, defaults to left.
---@return swiftline.Separator
function Separator:new(left, right)
    if left == nil and right == nil then
        left = ""
        right = ""
    elseif right == nil then
        right = left
    end

    if type(left) == "string" then
        left = { left, style = {} }
    end
    if type(right) == "string" then
        right = { right, style = {} }
    end

    return setmetatable({
        left = left,
        right = right,
    }, self)
end

return Separator
