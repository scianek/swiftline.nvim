local M = {}

local Provider = require("swiftline.provider")

---A provider that returns the current cursor percentage in the file
---@return swiftline.Provider
function M.percentage()
    return Provider:new({
        get = function()
            local current_line = vim.fn.line(".")
            local total_lines = vim.fn.line("$")

            if total_lines == 0 then
                return "0%"
            end

            if current_line == 1 then
                return "top"
            elseif current_line == total_lines then
                return "bot"
            else
                local percentage =
                    math.floor((current_line / total_lines) * 100)
                return percentage .. "%%"
            end
        end,
    })
end

---A provider that returns the current cursor position as "line:col"
---@return swiftline.Provider
function M.position()
    return Provider:new({
        get = function()
            local row = vim.fn.line(".")
            local col = vim.fn.virtcol(".")
            return string.format("%d:%d", row, col)
        end,
    })
end

return M
