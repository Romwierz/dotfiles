local M = {}

_G.get_hostname = function()
    local f = io.popen ("/bin/hostname")
    local hostname = f:read("*a") or ""
    f:close()
    hostname =string.gsub(hostname, "\n$", "")
    return hostname
end

function M.put_text(text)
    if vim.fn.mode():sub(1,1) == "i" then
        vim.api.nvim_feedkeys(text, "n", true)
    else
        vim.api.nvim_put({ text }, "c", true, true)
    end
end

return M
