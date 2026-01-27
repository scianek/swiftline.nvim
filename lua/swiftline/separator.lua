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
---@param left string|swiftline.SeparatorSideSpec|nil
---@param right string|swiftline.SeparatorSideSpec|nil
---@return swiftline.Separator
function Separator:new(left, right)
    if left == nil and right == nil then
        left = { "", style = {} }
        right = { "", style = {} }
    elseif right == nil then
        right = left
    end

    -- Convert strings to table format
    if type(left) == "string" then
        left = { left, style = {} }
    end
    if type(right) == "string" then
        right = { right, style = {} }
    end

    -- Now guaranteed to be tables, deepcopy is safe
    return setmetatable({
        left = vim.deepcopy(left --[[@as table]]),
        right = vim.deepcopy(right --[[@as table]]),
    }, self)
end

---Create a copy with modified left separator style
---@param style_overrides vim.api.keyset.highlight
---@return swiftline.Separator
function Separator:with_left_style(style_overrides)
    local copy = vim.deepcopy(self)
    copy.left.style = vim.tbl_extend("force", copy.left.style, style_overrides)
    return setmetatable(copy, Separator)
end

---Create a copy with modified right separator style
---@param style_overrides vim.api.keyset.highlight
---@return swiftline.Separator
function Separator:with_right_style(style_overrides)
    local copy = vim.deepcopy(self)
    copy.right.style =
        vim.tbl_extend("force", copy.right.style, style_overrides)
    return setmetatable(copy, Separator)
end

---Create a copy with modified both separator styles
---@param style_overrides vim.api.keyset.highlight
---@return swiftline.Separator
function Separator:with_style(style_overrides)
    local copy = vim.deepcopy(self)
    copy.left.style = vim.tbl_extend("force", copy.left.style, style_overrides)
    copy.right.style =
        vim.tbl_extend("force", copy.right.style, style_overrides)
    return setmetatable(copy, Separator)
end

return Separator
