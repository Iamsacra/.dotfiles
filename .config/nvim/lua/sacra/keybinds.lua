local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map("i", "<C-E>", "<ESC>A")
map("i", "<C-A>", "<ESC>I")


