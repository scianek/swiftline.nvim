---Built-in providers for swiftline
---@class swiftline.Providers
local M = {}

-- Cursor position
M.position = require("swiftline.builtin.providers.cursor").position
M.percentage = require("swiftline.builtin.providers.cursor").percentage

-- Editor mode
M.mode = require("swiftline.builtin.providers.mode").mode

-- File information
M.filename = require("swiftline.builtin.providers.file").filename
M.cwd = require("swiftline.builtin.providers.file").cwd

-- Git
M.git_branch = require("swiftline.builtin.providers.git").git_branch
M.git_diff_added = require("swiftline.builtin.providers.git").git_diff_added
M.git_diff_changed = require("swiftline.builtin.providers.git").git_diff_changed
M.git_diff_removed = require("swiftline.builtin.providers.git").git_diff_removed

-- LSP
M.lsp = require("swiftline.builtin.providers.lsp").lsp

-- Diagnostics
M.diagnostics_errors = require("swiftline.builtin.providers.diagnostics").diagnostics_errors
M.diagnostics_warnings = require("swiftline.builtin.providers.diagnostics").diagnostics_warnings
M.diagnostics_info = require("swiftline.builtin.providers.diagnostics").diagnostics_info
M.diagnostics_hints = require("swiftline.builtin.providers.diagnostics").diagnostics_hints

-- Helpers
M.fill = require("swiftline.builtin.providers.helpers").fill
M.text = require("swiftline.builtin.providers.helpers").text

return M
