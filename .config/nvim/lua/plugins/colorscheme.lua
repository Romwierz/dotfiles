-- Use `:Inspect` and `:FzfLua highlights` to check/browse highlight groups

local frappe = require("catppuccin.palettes").get_palette "frappe"
local latte = require("catppuccin.palettes").get_palette "latte"
require("catppuccin").setup({
    flavour = "frappe",
    transparent_background = false,
    styles = {
        sidebars = "transparent",
        floats = "transparent",
        conditionals = {},
    },
    highlight_overrides = {
        frappe = function(frappe)
            return {
                -- TODO: link some of these groups to other groups
                Comment = { fg = frappe.surface2 },
                Function = { fg = frappe.text },
                Operator = { fg = frappe.text },
                ["@variable.parameter"] = { fg = frappe.text },
                ["@function.builtin"] = { fg = frappe.text },
                ["@string.escape"] = { link = "@string" },
                Type = { fg = frappe.mauve },
                PreProc = { fg = frappe.mauve },
                ["@function.macro"] = { fg = frappe.text },
                ["@keyword.import.c"] = { fg = frappe.mauve },
                ["@keyword.import.cpp"] = { fg = frappe.mauve },
                Label = { fg = frappe.peach, style = { "bold" } },
                ["@markup.strong"] = { fg = frappe.mauve, style = { "bold" } },
                ["@markup.raw"] = { fg = frappe.overlay1, style = { "italic" } },
                ["@markup.list"] = { fg = frappe.text },
            }
        end,
        latte = function(latte)
            return {
                -- TODO: link some of these groups to other groups
                Comment = { fg = latte.overlay2 },
                Function = { fg = latte.text },
                Operator = { fg = latte.text },
                ["@variable.parameter"] = { fg = latte.text },
                ["@function.builtin"] = { fg = latte.text },
                ["@string.escape"] = { link = "@string" },
                Type = { fg = latte.mauve },
                PreProc = { fg = latte.mauve },
                ["@function.macro"] = { fg = latte.text },
                ["@keyword.import.c"] = { fg = latte.mauve },
                ["@keyword.import.cpp"] = { fg = latte.mauve },
                Label = { fg = latte.peach, style = { "bold" } },
            }
        end
    },
    color_overrides = {
        frappe = {
            mauve = "#e17ff0",
        },
        latte = {
            mauve = "#0000ff",
            green = "#8a0404",
            peach = "#21871c",
            text = "#000000",
            base = "#ffffff",
            mantle = "#f3f3f3",
        },
    }
})

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {
      String = { fg = "#928374", bg = "NONE", italic = true },
      ["@string"] = { fg = "#928374" },
  },
  dim_inactive = false,
  transparent_mode = false,
})

local function link(from, to)
    vim.api.nvim_set_hl(0, from, { link = to })
end

