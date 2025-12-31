# swiftline.nvim

A fast, flexible statusline plugin for Neovim with a focus on composability and minimal configuration.

## Features

- **Declarative builder** - Configure your statusline with clean, readable Lua tables
- **Smart defaults** - Works out of the box, customize only what you need
- **Progressive complexity** - Start simple, add features as you need them
- **Flexible styling** - Full control over colors, separators and visual appearance
- **Type-safe config** - Full LuaLS support with autocomplete and hover docs
- **Extensible API** - Create custom components that integrate seamlessly

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
    "scianek/swiftline.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Optional: for file icons
    },
    config = function()
        require("swiftline").setup({
            modules = {
                -- Your configuration here
            }
        })
    end
}
```

## Quick Start
```lua
local p = require("swiftline.builtin.providers")

require("swiftline").setup({
    modules = {
        { p.mode():prefix(" ") },
        { p.git_branch():prefix(" ") },
        { p.filename() },
        { p.fill() },
        { p.diagnostics_errors():prefix(" ") },
        { p.position() },
    },
})
```

This gives you a working statusline.

## Configuration

### Basic Structure
```lua
local p = require("swiftline.builtin.providers")

require("swiftline").setup({
    modules = {
        { p.mode(), style = { ... } },
        -- or just: p.mode()
    },
    default_style = {
        -- Default style for all modules
        fg = "#ECECEC",
        bg = "#161E2F",
        sep = " ",
    }
})
```

### Styling Modules
```lua
local p = require("swiftline.builtin.providers")
local s = require("swiftline.builtin.separators")

local my_style = {
    fg = "#060D1C",
    bg = "#91B1FE",
    bold = true,
    sep = {
        left = s.block.left,
        right = s.rounded.right,
    }
}

require("swiftline").setup({
    modules = {
        { p.mode(), style = my_style },
        -- Inline style
        { p.git_branch(), style = { fg = "#B3BEE0" } },
    }
})
```
## Built-in Providers

Access them by importing `swiftline.builtin.providers`

### Basic
- `mode()` - Current vim mode
- `filename()` - Current file with icon and modified indicator
- `position()` - Cursor position (line:column)
- `percentage()` - Scroll position (top/bot/%)
- `cwd()` - Current working directory name
- `fill()` - Alignment spacer
- `text(str)` - Static text

### Git
- `git_branch()` - Current git branch
- `git_diff_added()` - Added lines count
- `git_diff_changed()` - Changed lines count
- `git_diff_removed()` - Removed lines count

### LSP
- `lsp()` - Active LSP clients
- `diagnostics_errors()` - Error count
- `diagnostics_warnings()` - Warning count
- `diagnostics_info()` - Info count
- `diagnostics_hints()` - Hint count

### Provider Methods

All providers support chaining:
```lua
p.mode():prefix(" ")
p.git_branch():prefix(" "):suffix(" ")
p.diagnostics_errors():prefix(" ")
```

## Components

Components are groups of related providers with unified styling:
```lua
local c = require("swiftline.builtin.components")

modules = {
    c.diagnostics({
        colors = { 
            error = "#fc7ead",
            warn = "#fec2a4",
            info = "#92b2fe",
            hint = "#69ddf5"
        }
    }),
    
    c.git_diff({
        icons = { added = "+", changed = "~", removed = "-" },
        style = { fg = "#4b5ea2" }
    }),
}
```


## Built-in Separators
```lua
local s = require("swiftline.builtin.separators")

s.empty      -- ""
s.space      -- " "
s.block      -- "█"
s.rounded    -- "" / ""
s.slanted    -- "" / ""
```

Use them in your styles:
```lua
{ sep = s.rounded }
{ 
    sep = {
        left = s.block.left,
        right = s.slanted.right
    }
}
```

## Creating Custom Providers
```lua
local Provider = require("swiftline.provider")

local my_provider = Provider:new({
    get = function()
        return "Hello World"
    end,
    events = { "BufEnter" }  -- When to update (optional)
})
```

Providers without events are **live** (re-evaluated every render). Providers with events are **cached** (updated only when events fire).
