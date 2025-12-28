local M = {}

local p = require("swiftline.builtin.providers")
local Component = require("swiftline.component")

local function get_hl_color(hl_name)
    local hl = vim.api.nvim_get_hl(0, { name = hl_name })
    return hl.fg
end

---Merge options with precedence: defaults < common < per-item
---@param defaults table Default config for each item
---@param opts table User options
---@param keys string[] Keys to process (e.g., {"added", "changed", "removed"})
---@return table Merged config
local function merge_component_opts(defaults, opts, keys)
    opts = opts or {}
    local result = vim.deepcopy(defaults)

    -- Step 1: Apply common style to all items (if provided)
    if opts.style then
        for _, key in ipairs(keys) do
            result[key].style = opts.style
        end
    end

    -- Step 2: Apply common color to all items (if provided)
    if opts.color then
        for _, key in ipairs(keys) do
            result[key].color = opts.color
        end
    end

    -- Step 3: Apply colors shorthand (overrides common color for specific items)
    if opts.colors then
        for key, color in pairs(opts.colors) do
            if result[key] then
                result[key].color = color
            end
        end
    end

    -- Step 4: Apply icons shorthand
    if opts.icons then
        for key, icon in pairs(opts.icons) do
            if result[key] then
                result[key].icon = icon
            end
        end
    end

    -- Step 5: Apply per-item full spec (highest priority)
    for key, spec in pairs(opts) do
        if result[key] and type(spec) == "table" then
            if spec.icon then
                result[key].icon = spec.icon
            end
            if spec.color then
                result[key].color = spec.color
            end
            if spec.style then
                result[key].style = spec.style
            end
        end
    end

    return result
end

---Git diff component
---@param opts? { style?: table, color?: string|number, colors?: table, icons?: table, added?: table, changed?: table, removed?: table }
function M.git_diff(opts)
    local defaults = {
        added = {
            icon = " ",
            color = get_hl_color("GitSignsAdd") or get_hl_color("DiffAdd"),
        },
        changed = {
            icon = " ",
            color = get_hl_color("GitSignsChange")
                or get_hl_color("DiffChange"),
        },
        removed = {
            icon = " ",
            color = get_hl_color("GitSignsDelete")
                or get_hl_color("DiffDelete"),
        },
    }

    local config = merge_component_opts(
        defaults,
        opts or {},
        { "added", "changed", "removed" }
    )

    return Component:new({
        {
            p.git_diff_added():prefix(config.added.icon),
            style = config.added.style or { fg = config.added.color },
        },
        {
            p.git_diff_changed():prefix(config.changed.icon),
            style = config.changed.style or { fg = config.changed.color },
        },
        {
            p.git_diff_removed():prefix(config.removed.icon),
            style = config.removed.style or { fg = config.removed.color },
        },
    })
end

---Diagnostics component
---@param opts? { style?: table, color?: string|number, colors?: table, icons?: table, error?: table, warn?: table, info?: table, hint?: table }
function M.diagnostics(opts)
    local defaults = {
        error = { icon = " ", color = get_hl_color("DiagnosticError") },
        warn = { icon = " ", color = get_hl_color("DiagnosticWarn") },
        info = { icon = "󰋼 ", color = get_hl_color("DiagnosticInfo") },
        hint = { icon = "󰌵", color = get_hl_color("DiagnosticHint") },
    }

    local config = merge_component_opts(
        defaults,
        opts or {},
        { "error", "warn", "info", "hint" }
    )

    return Component:new({
        {
            p.diagnostics_errors():prefix(config.error.icon),
            style = config.error.style or { fg = config.error.color },
        },
        {
            p.diagnostics_warnings():prefix(config.warn.icon),
            style = config.warn.style or { fg = config.warn.color },
        },
        {
            p.diagnostics_info():prefix(config.info.icon),
            style = config.info.style or { fg = config.info.color },
        },
        {
            p.diagnostics_hints():prefix(config.hint.icon),
            style = config.hint.style or { fg = config.hint.color },
        },
    })
end

return M
