---@class swiftline.ModuleSpec
---@field provider swiftline.ProviderSpec
---@field style swiftline.StyleSpec
---@field module_idx number

local STATUSLINE_HL_PREFIX = "SwiftlineModule"

local function format_hl(hl_name, text)
    return "%#" .. STATUSLINE_HL_PREFIX .. hl_name .. "#" .. text .. "%*"
end

local function set_hl(hl_name, val)
    vim.api.nvim_set_hl(0, STATUSLINE_HL_PREFIX .. hl_name, val)
end

---Renders a module by calling its provider and applying styles
---@param module swiftline.ModuleSpec
---@return string # Formatted statusline module string
local function render_module(module)
    local content = module.provider.get()
    if content == nil then
        return ""
    end

    local hl = vim.deepcopy(module.style)
    hl.sep = nil
    set_hl(module.module_idx, hl)

    local function format_sep(side, spec)
        local sep_char, sep_style = spec[1], spec.style
        if sep_char == "" or sep_char == " " then
            return sep_char
        end
        local hl_name = module.module_idx .. side .. "Sep"
        set_hl(hl_name, sep_style)
        return format_hl(hl_name, sep_char)
    end

    return format_sep("Left", module.style.sep.left)
        .. format_hl(module.module_idx, content)
        .. format_sep("Right", module.style.sep.right)
end

return { render_module = render_module }
