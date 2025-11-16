---@class swiftline.StyleConfig: vim.api.keyset.highlight
---User-facing style configuration that allows shorthand syntax.
---All fields are optional and will be filled with defaults during parsing.
---@field sep? string|swiftline.SeparatorConfig|{ left?: string|swiftline.SeparatorSideConfig, right?: string|swiftline.SeparatorSideConfig }

---@class swiftline.SeparatorConfig
---User-facing separator configuration that allows shorthand syntax.
---Can be specified as a string (applies to both sides) or as a table with left/right.
---@field [1]? string The separator character(s) when using array syntax
---@field left? string|swiftline.SeparatorSideConfig Left separator
---@field right? string|swiftline.SeparatorSideConfig Right separator

---@class swiftline.SeparatorSideConfig
---User-facing configuration for one side of a separator.
---Can be specified as just a string, or as a table with character(s) and style overrides.
---@field [1] string The separator character(s)
---@field style? vim.api.keyset.highlight Style overrides for this separator side

local M = {}

local DEFAULTS = {
    fg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).fg,
    bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg,
    sep = {
        left = "",
        right = "",
    },
}

---Supply default styles and expand shorthand separator definitions
---@param style_config swiftline.StyleConfig
---@param default_style? swiftline.StyleConfig
---@return swiftline.StyleSpec
function M.resolve_style(style_config, default_style)
    local defaults = vim.tbl_extend("force", DEFAULTS, default_style or {})
    local style = vim.tbl_extend("force", defaults, style_config or {})
    local default_sep_styles = {
        fg = style.bg,
        bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg,
    }
    if type(style.sep) == "string" then
        style.sep = { left = style.sep, right = style.sep }
    end
    if type(style.sep.left) == "string" then
        style.sep.left = { style.sep.left, style = {} }
    end
    if type(style.sep.right) == "string" then
        style.sep.right = { style.sep.right, style = {} }
    end
    style.sep.left.style =
        vim.tbl_extend("force", default_sep_styles, style.sep.left.style or {})
    style.sep.right.style =
        vim.tbl_extend("force", default_sep_styles, style.sep.right.style or {})
    return style
end

return M
