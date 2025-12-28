local M = {}

local Provider = require("swiftline.provider")

---A provider that returns the names of active LSP clients for the current buffer
---@return swiftline.Provider
function M.lsp()
    return Provider:new({
        get = function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
                return nil
            end

            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end

            return table.concat(names, " ")
        end,
        events = { "LspAttach", "LspDetach" },
    })
end

return M
