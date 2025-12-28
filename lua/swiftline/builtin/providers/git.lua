local M = {}

local Provider = require("swiftline.provider")

---A provider that returns the current git branch name
---@return swiftline.Provider
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
        events = { "BufEnter", "DirChanged", "User GitSignsUpdate" },
    })
end

---A provider that returns the number of added lines in the current git diff
---@return swiftline.Provider
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
        events = { "User GitSignsUpdate" },
    })
end

---A provider that returns the number of changed lines in the current git diff
---@return swiftline.Provider
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
        events = { "User GitSignsUpdate" },
    })
end

---A provider that returns the number of removed lines in the current git diff
---@return swiftline.Provider
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
        events = { "User GitSignsUpdate" },
    })
end

return M
