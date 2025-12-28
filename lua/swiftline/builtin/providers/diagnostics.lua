local M = {}

local Provider = require("swiftline.provider")

---A provider that returns the number of error diagnostics in the current buffer
---@return swiftline.Provider
function M.diagnostics_errors()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.ERROR,
            })
            return count > 0 and tostring(count) or nil
        end,
        events = { "DiagnosticChanged" },
    })
end

---A provider that returns the number of warning diagnostics in the current buffer
---@return swiftline.Provider
function M.diagnostics_warnings()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.WARN,
            })
            return count > 0 and tostring(count) or nil
        end,
        events = { "DiagnosticChanged" },
    })
end

---A provider that returns the number of hint diagnostics in the current buffer
---@return swiftline.Provider
function M.diagnostics_hints()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.HINT,
            })
            return count > 0 and tostring(count) or nil
        end,
        events = { "DiagnosticChanged" },
    })
end

---A provider that returns the number of info diagnostics in the current buffer
---@return swiftline.Provider
function M.diagnostics_info()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.INFO,
            })
            return count > 0 and tostring(count) or nil
        end,
        events = { "DiagnosticChanged" },
    })
end

return M
