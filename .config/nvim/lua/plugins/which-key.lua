local function regs()
    return {
        '"','0','1','2','3','4','5','6','7','8','9',
        'a','b','c','d','e','f','g','h','i','j',
        '/','.',':','%','#'
    }
end

local function expand_regs()
    local ret = {}

    for _, reg in ipairs(regs()) do
        local reg_val = vim.fn.getreg(reg)

        -- Skip iteration for numbered and named registers if they are empty
        if ((reg:match("%d") or reg:match("%l")) and reg_val == "") then
            goto continue
        end

        ret[#ret + 1] = {
            reg,
            function()
                vim.fn.setreg("+", reg_val)
                print("Copied \"" .. reg .. " content to clipboard")
            end,
            desc = vim.fn.substitute(reg_val, [[^\s\+]], "", ""),
            icon = { cat = "file", name = "bajo" },
        }

        ::continue::
    end
    return ret
end

require("which-key").add({
    { "<leader>f", desc = "fzf" },
    { "<leader>b", desc = "Buffers" },
    { "<leader>t", desc = "Tabs" },
    { "<leader>y", desc = "Copy" },
    { "<leader>y\"", desc = "Copy register's content", expand = function()
        return expand_regs()
    end
},
})

vim.keymap.set("n", "<leader>?", function()
    require("which-key").show({
        icon = "",
        global = true,
    })
end, { desc = "Global Keymaps (which-key)" })

