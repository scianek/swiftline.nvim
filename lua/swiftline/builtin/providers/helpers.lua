local M = {}

local Provider = require("swiftline.provider")

---A provider that returns the fill string "%="
---@return swiftline.Provider
function M.fill()
    return Provider:new({
        get = function()
            return "%="
        end,
    })
end

---A provider that returns a static text
---@param text string
---@return swiftline.Provider
function M.text(text)
    return Provider:new({
        get = function()
            return text
        end,
    })
end

return M
