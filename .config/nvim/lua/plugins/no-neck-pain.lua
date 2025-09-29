local function get_hl(name)
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
    if not ok then
        return
    end
    for _, key in pairs({ "foreground", "background", "special" }) do
        if hl[key] then
            hl[key] = string.format("#%06x", hl[key])
        end
    end
    return hl
end

local function hex2rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local function rgb2hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

local function darken(hex, amount)
    local r, g, b = hex2rgb(hex)
    return rgb2hex(r * amount, g * amount, b * amount)
end

local function get_bg()
    local normal = get_hl("Normal")
    local backdrop = 0.95
    local background = normal and normal.background and darken(normal.background, backdrop)
    print(background)
    return background
end

--vim.api.nvim_create_autocmd("ColorScheme", { callback = set_bg })

require("no-neck-pain").setup({
    width = 120,
    autocmds = {
        enableOnVimEnter = false,
        reloadOnColorSchemeChange = false,
    },
    callbacks = {
--        postEnable = function(state)
--            for _, win in ipairs(vim.api.nvim_list_wins()) do
--                local buf = vim.api.nvim_win_get_buf(win)
--                local name = vim.api.nvim_buf_get_name(buf)
--                if name:match("[Scratch]") then
--                    vim.api.nvim_win_set_option(win, "winhl", "Normal:#ff0000")
--                end
--            end
--        end,
       -- postEnable = function (state)
       --     local bg = get_bg()
       --     local background_group_left =
       --     string.format("NoNeckPain_background_tab_%s_side_left", state.active_tab)
       --     local background_group_right =
       --     string.format("NoNeckPain_background_tab_%s_side_right", state.active_tab)
       --     vim.cmd(string.format("hi! %s guifg=%s guibg=%s", background_group_left, bg, bg))
       --     vim.cmd(string.format("hi! %s guifg=%s guibg=%s", background_group_right, bg, bg))
       -- end,
    },
    buffers = {
        wo = {
            fillchars = "eob: ",
        },
    }
})

--set_bg()
--for _, win in ipairs(vim.api.nvim_list_wins()) do
--  local buf = vim.api.nvim_win_get_buf(win)
--  local name = vim.api.nvim_buf_get_name(buf)
--  print(name)
--  if name:match("NoNeckPain") then
--    print("NNP win:", win, "buf:", buf, "name:", name)
--  end
--end
--
--for _, win in ipairs(vim.api.nvim_list_wins()) do
--  local cfg = vim.api.nvim_win_get_config(win)
--  print(cfg.relative)
--  if cfg.relative ~= "" then
--    print("floating win:", win, vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)))
--  end
--end

