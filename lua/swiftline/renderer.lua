---@class swiftline.ModuleSpec
---@field provider swiftline.ProviderSpec
---@field style swiftline.StyleSpec
---@field module_idx number

local STATUSLINE_HL_PREFIX = "SwiftlineModule"

---Format text with a highlight group
---@param hl_name string|number
---@param text string
---@return string
local function format_hl(hl_name, text)
    return "%#" .. STATUSLINE_HL_PREFIX .. hl_name .. "#" .. text .. "%*"
end

---Set a highlight group with the module prefix
---@param hl_name string|number
---@param hl_spec vim.api.keyset.highlight
local function set_hl(hl_name, hl_spec)
    vim.api.nvim_set_hl(0, STATUSLINE_HL_PREFIX .. hl_name, hl_spec)
end

---Format a separator with its highlight
---@param module_idx number
---@param side string "Left" or "Right"
---@param spec swiftline.SeparatorSideSpec
---@return string
local function format_separator(module_idx, side, spec)
    local sep_char, sep_style = spec[1], spec.style
    if sep_char == "" or sep_char == " " then
        return sep_char
    end

    local hl_name = module_idx .. side .. "Sep"
    set_hl(hl_name, sep_style)
    return format_hl(hl_name, sep_char)
end

---Render content with custom highlight regions
---@param content string
---@param highlights swiftline.ProviderHighlight[]
---@param module_style swiftline.StyleSpec
---@param module_idx number
---@return string
local function render_with_highlights(
    content,
    highlights,
    module_style,
    module_idx
)
    local result = "%#" .. STATUSLINE_HL_PREFIX .. module_idx .. "#"
    local pos = 1

    for _, hl_region in ipairs(highlights) do
        if hl_region.start_pos > pos then
            result = result .. content:sub(pos, hl_region.start_pos - 1)
        end

        local merged_hl_name = STATUSLINE_HL_PREFIX
            .. module_idx
            .. "_hl_"
            .. hl_region.start_pos
        local merged_hl = vim.tbl_extend("force", module_style, hl_region.hl)
        merged_hl.sep = nil
        vim.api.nvim_set_hl(0, merged_hl_name, merged_hl)

        result = result .. "%#" .. merged_hl_name .. "#"
        result = result .. content:sub(hl_region.start_pos, hl_region.end_pos)
        result = result .. "%#" .. STATUSLINE_HL_PREFIX .. module_idx .. "#"

        pos = hl_region.end_pos + 1
    end

    if pos <= #content then
        result = result .. content:sub(pos)
    end

    return result .. "%*"
end

---Renders a module by calling its provider and applying styles
---@param module swiftline.ModuleSpec
---@return string Formatted statusline module string
local function render_module(module)
    local result = module.provider.get()
    if result == nil then
        return ""
    end

    local content, highlights
    if type(result) == "string" then
        content = result
        highlights = {}
    else
        content = result.content or ""
        highlights = result.highlights or {}
    end

    if content == "" then
        return ""
    end

    local module_hl = vim.deepcopy(module.style)
    module_hl.sep = nil
    set_hl(module.module_idx, module_hl)

    local formatted_content
    if #highlights > 0 then
        formatted_content = render_with_highlights(
            content,
            highlights,
            module_hl,
            module.module_idx
        )
    else
        formatted_content = format_hl(module.module_idx, content)
    end

    return format_separator(module.module_idx, "Left", module.style.sep.left)
        .. formatted_content
        .. format_separator(module.module_idx, "Right", module.style.sep.right)
end

return { render_module = render_module }
