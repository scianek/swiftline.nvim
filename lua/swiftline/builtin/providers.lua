---Built-in providers for swiftline
---@class swiftline.Providers
local M = {}

local Provider = require("swiftline.provider")

local mode_alias = {
    ["n"] = "NORMAL",
    ["no"] = "OP",
    ["nov"] = "OP",
    ["noV"] = "OP",
    ["no"] = "OP",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["v"] = "VISUAL",
    ["vs"] = "VISUAL",
    ["V"] = "LINES",
    ["Vs"] = "LINES",
    [""] = "BLOCK",
    ["s"] = "BLOCK",
    ["s"] = "SELECT",
    ["S"] = "SELECT",
    [""] = "BLOCK",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rv"] = "V-REPLACE",
    ["Rx"] = "REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "COMMAND",
    ["ce"] = "COMMAND",
    ["r"] = "ENTER",
    ["rm"] = "MORE",
    ["r?"] = "CONFIRM",
    ["!"] = "SHELL",
    ["t"] = "TERM",
    ["nt"] = "TERM",
    ["null"] = "NONE",
}

function M.mode()
    return Provider:new({
        get = function()
            local mode = vim.fn.mode(1)
            return mode_alias[mode] or mode
        end,
    })
end

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
    })
end

function M.git_branch()
    return Provider:new({
        get = function()
            if vim.b.gitsigns_head then
                return vim.b.gitsigns_head
            end
            if vim.b.git_branch_cache == nil then
                local branch =
                    vim.fn.system("git branch --show-current 2>/dev/null")
                if vim.v.shell_error == 0 and branch ~= "" then
                    vim.b.git_branch_cache = vim.trim(branch)
                else
                    vim.b.git_branch_cache = false
                end
            end

            return vim.b.git_branch_cache or nil
        end,
    })
end

function M.git_diff_added()
    return Provider:new({
        get = function()
            if
                vim.b.gitsigns_status_dict
                and vim.b.gitsigns_status_dict.added
                and vim.b.gitsigns_status_dict.added > 0
            then
                return vim.b.gitsigns_status_dict.added
            end
        end,
    })
end

function M.git_diff_changed()
    return Provider:new({
        get = function()
            if
                vim.b.gitsigns_status_dict
                and vim.b.gitsigns_status_dict.changed
                and vim.b.gitsigns_status_dict.changed > 0
            then
                return vim.b.gitsigns_status_dict.changed
            end
        end,
    })
end

function M.git_diff_removed()
    return Provider:new({
        get = function()
            if
                vim.b.gitsigns_status_dict
                and vim.b.gitsigns_status_dict.removed
                and vim.b.gitsigns_status_dict.removed > 0
            then
                return vim.b.gitsigns_status_dict.removed
            end
        end,
    })
end

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
    })
end

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

function M.position()
    return Provider:new({
        get = function()
            local row = vim.fn.line(".")
            local col = vim.fn.virtcol(".")
            return string.format("%d:%d", row, col)
        end,
    })
end

function M.fill()
    return Provider:new({
        get = function()
            return "%="
        end,
    })
end

function M.cwd()
    return Provider:new({
        get = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end,
    })
end

function M.diagnostics_errors()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.ERROR,
            })
            return count > 0 and tostring(count) or nil
        end,
    })
end

function M.diagnostics_warnings()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.WARN,
            })
            return count > 0 and tostring(count) or nil
        end,
    })
end

function M.diagnostics_hints()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.HINT,
            })
            return count > 0 and tostring(count) or nil
        end,
    })
end

function M.diagnostics_info()
    return Provider:new({
        get = function()
            local count = #vim.diagnostic.get(0, {
                severity = vim.diagnostic.severity.INFO,
            })
            return count > 0 and tostring(count) or nil
        end,
    })
end

function M.text(text)
    return Provider:new({
        get = function()
            return text
        end,
    })
end

return M
