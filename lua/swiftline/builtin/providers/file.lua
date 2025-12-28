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
            if not ok then
                if vim.bo.modified then filename = filename .. " ●" end
                return filename
            end

            local icon, hl_name = devicons.get_icon(filename, nil, { default = true })
            if not icon then
                if vim.bo.modified then filename = filename .. " ●" end
                return filename
            end

            local devicon_hl = vim.api.nvim_get_hl(0, { name = hl_name })
            local content = icon .. " " .. filename
            if vim.bo.modified then
                content = content .. " ●"
            end

            return {
                content = content,
                highlights = {
                    {
                        start_pos = 1,
                        end_pos = #icon,
                        hl = { fg = devicon_hl.fg }
                    }
                }
            }
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
