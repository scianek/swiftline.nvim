---@class swiftline.ProviderResult
---@field content string The text content
---@field highlights? swiftline.ProviderHighlight[] Highlight regions within the content

---@class swiftline.ProviderHighlight
---@field start_pos number Start position in content (1-indexed)
---@field end_pos number End position in content
---@field hl vim.api.keyset.highlight Highlight to apply (fg only, bg inherited)

---@class swiftline.ProviderSpec
---@field get fun() : string|swiftline.ProviderResult|nil A string to be displayed in the statusline or nil to hide the module
---@field events? string[] A list of events that trigger the provider to update

---@class swiftline.Provider: swiftline.ProviderSpec
local Provider = {}
Provider.__index = Provider

---Creates a new Provider
---@param spec swiftline.ProviderSpec
---@return swiftline.Provider
function Provider:new(spec)
    return setmetatable({
        get = spec.get,
        events = spec.events,
    }, self)
end

---Transforms the result of the provider using the given function
---@param fn fun(result: string|swiftline.ProviderResult): string|nil
---@return swiftline.Provider
function Provider:transform(fn)
    return setmetatable({
        get = function()
            local result = self.get()
            if result == nil then
                return nil
            end
            return fn(result)
        end,
        events = self.events,
    }, { __index = self })
end

---Prefixes the result of the provider with the given string
---@param str string
---@return swiftline.Provider
function Provider:prefix(str)
    return self:transform(function(result)
        return str .. result
    end)
end

---Suffixes the result of the provider with the given string
---@param str string
---@return swiftline.Provider
function Provider:suffix(str)
    return self:transform(function(result)
        return result .. str
    end)
end

return Provider
