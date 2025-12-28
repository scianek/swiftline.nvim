local M = {}

local Provider = require("swiftline.provider")

---A provider that returns the current filename with icon and modified status
---@return swiftline.Provider
function M.filename()
    return Provider:new({
        get = function()
            local filename = vim.fn.expand("%:t")
            if filename == "" then
                return "[No Name]"
            end

            local ok, devicons = pcall(require, "nvim-web-devicons")
            local icon = ""

            if ok then
                local i, h =
                    devicons.get_icon(filename, nil, { default = true })
                if i and h then
                    icon = "%#" .. h .. "#" .. i .. "%* "
                end
            end

            local content = icon .. filename
            if vim.bo.modified then
                content = content .. " ●"
            end
            return content
        end,
        events = { "BufEnter", "BufWritePost", "BufModifiedSet" },
    })
end

---A provider that returns the name of the current working directory
---@return swiftline.Provider
function M.cwd()
    return Provider:new({
        get = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end,
        events = { "DirChanged" },
    })
end

return M
