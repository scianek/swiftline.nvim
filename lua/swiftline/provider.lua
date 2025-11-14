---@class swiftline.ProviderSpec
---@field get fun() : string|nil A string to be displayed in the statusline or nil to hide the module

---@class swiftline.Provider: swiftline.ProviderSpec
local Provider = {}
Provider.__index = Provider

---Creates a new Provider
---@param spec swiftline.ProviderSpec
---@return swiftline.Provider
function Provider:new(spec)
    return setmetatable({
        get = spec.get,
    }, self)
end

---Transforms the result of the provider using the given function
---@param fn fun(result: string): string|nil
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
