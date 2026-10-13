vim.g.mapleader = " "

-- allow movement of multiple lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down the selected text" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up the selected text" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left the selected text" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right the selected text" })

-- keep cursor on start of the line on movement
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in the middle while jumping up and down
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump up" })

-- keep search term in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- replace highlighted with current yank preserved
vim.keymap.set("x", "<leader>p", '"_dP')

-- yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selected to the system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to the system clipboard" })

-- multiline replace on highlighted
vim.keymap.set(
    "n",
    "<leader>ss",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gIc<Left><Left><Left><Left>]],
    { desc = "Multiline string replace on highlighted" }
)

-- other
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "Q", "<nop>")

-- remote sync
vim.keymap.set("n", "<leader>ru", "<cmd>RemoteSync<CR>", { desc = "RSync: Sync Remote" })
