---@class swiftline.StyleSpec: vim.api.keyset.highlight
---Normalized style specification used internally.
---All fields are guaranteed to be present and fully expanded after parsing.
---@field sep swiftline.SeparatorSpec Fully normalized separator specification

---@class swiftline.Style: swiftline.StyleSpec
local Style = {}
Style.__index = Style

---Creates a new Style
---@param style_spec? swiftline.StyleSpec|nil
---@return swiftline.Style
function Style:new(style_spec)
    return setmetatable(style_spec or {}, self) --[[@as swiftline.Style]]
end

---Extend style with new spec, returning a new Style
---@param style_spec? swiftline.StyleSpec
---@return swiftline.Style
function Style:extend(style_spec)
    local new_style = vim.tbl_extend("force", self, style_spec)
    return setmetatable(new_style, self)
end

return Style
