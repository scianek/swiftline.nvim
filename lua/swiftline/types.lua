---@class swiftline.SeparatorSpec
---Normalized separator specification with both sides fully defined.
---@field left swiftline.SeparatorSideSpec Left separator (fully normalized)
---@field right swiftline.SeparatorSideSpec Right separator (fully normalized)

---@class swiftline.SeparatorSideSpec
---Normalized specification for one side of a separator.
---Character(s) and style are guaranteed to be present.
---@field [1] string The separator character(s)
---@field style vim.api.keyset.highlight Style for this separator side (always present, may be empty table)
