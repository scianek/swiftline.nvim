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

---Flips a separator string (reverses and mirrors each character)
---@param sep string
---@return string
local function flip_sep_string(sep)
    if sep == nil or sep == "" then
        return ""
    end

    local chars = vim.fn.split(sep, "\\zs")

    local result = {}
    local separators = require("swiftline.builtin.separators")

    for i = #chars, 1, -1 do
        local curr = chars[i]
        local found = curr

        for _, pair in pairs(separators) do
            if pair.left[1] == curr then
                found = pair.right[1]
                break
            elseif pair.right[1] == curr then
                found = pair.left[1]
                break
            end
        end

        table.insert(result, found)
    end

    return table.concat(result)
end

---Flips the separator specification (swaps left/right and mirrors characters)
---@return swiftline.Style
function Style:flip_sep()
    if not self.sep then
        return vim.deepcopy(self)
    end

    local style = vim.deepcopy(self)

    local function flip_side_spec(spec)
        if type(spec) == "string" then
            return { flip_sep_string(spec), style = {} }
        elseif type(spec) == "table" then
            return {
                flip_sep_string(spec[1]),
                style = spec.style,
            }
        end
        return spec
    end

    local old_left = style.sep.left
    local old_right = style.sep.right

    style.sep.left = flip_side_spec(old_right)
    style.sep.right = flip_side_spec(old_left)

    return style
end

return Style
