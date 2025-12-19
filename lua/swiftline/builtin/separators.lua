local Separator = require("swiftline.separator")

---Built-in separators for swiftline
---@class swiftline.Separators
local separators = {
    empty = Separator:new(""),
    space = Separator:new(" "),
    block = Separator:new("█"),
    rounded = Separator:new("", ""),
    slanted = Separator:new("", ""),
}

return separators
