require "nvchad.mappings"

local map = vim.keymap.set

local function tmux_or_window(command, fallback)
  return function()
    if vim.fn.exists(":" .. command) == 2 then
      vim.cmd(command)
    else
      vim.cmd("wincmd " .. fallback)
    end
  end
end

local function terminal_tmux_or_window(command, fallback)
  return function()
    vim.cmd.stopinsert()
    if vim.fn.exists(":" .. command) == 2 then
      vim.cmd(command)
    else
      vim.cmd("wincmd " .. fallback)
    end
  end
end

map("n", "<C-h>", tmux_or_window("TmuxNavigateLeft", "h"), { desc = "Tmux/window left", silent = true })
map("n", "<C-j>", tmux_or_window("TmuxNavigateDown", "j"), { desc = "Tmux/window down", silent = true })
map("n", "<C-k>", tmux_or_window("TmuxNavigateUp", "k"), { desc = "Tmux/window up", silent = true })
map("n", "<C-l>", tmux_or_window("TmuxNavigateRight", "l"), { desc = "Tmux/window right", silent = true })
map("n", "<C-\\>", tmux_or_window("TmuxNavigatePrevious", "p"), { desc = "Tmux/window previous", silent = true })

map("t", "<C-h>", terminal_tmux_or_window("TmuxNavigateLeft", "h"), { desc = "Tmux/window left", silent = true })
map("t", "<C-j>", terminal_tmux_or_window("TmuxNavigateDown", "j"), { desc = "Tmux/window down", silent = true })
map("t", "<C-k>", terminal_tmux_or_window("TmuxNavigateUp", "k"), { desc = "Tmux/window up", silent = true })
map("t", "<C-l>", terminal_tmux_or_window("TmuxNavigateRight", "l"), { desc = "Tmux/window right", silent = true })
map("t", "<C-\\>", terminal_tmux_or_window("TmuxNavigatePrevious", "p"), { desc = "Tmux/window previous", silent = true })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

map({ "n", "v" }, "H", "^", { desc = "Go to first non-blank column" })
map({ "n", "v" }, "L", "$", { desc = "Go to end of line" })
map("n", "k", "gk", { desc = "Move up by visual line" })
map("n", "j", "gj", { desc = "Move down by visual line" })
map("n", "gk", "k", { desc = "Move up by real line" })
map("n", "gj", "j", { desc = "Move down by real line" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("n", "<leader>P", '"0p', { desc = "Paste from yank register" })
map("v", "Y", '"+y', { desc = "Yank visual selection to system clipboard" })

map("n", "<F2>", "<cmd>set number! number?<CR>", { desc = "Toggle line numbers" })
map("n", "<F3>", "<cmd>set list! list?<CR>", { desc = "Toggle list chars" })
map("n", "<F4>", "<cmd>set wrap! wrap?<CR>", { desc = "Toggle line wrap" })
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })
map("n", "'", "`", { desc = "Jump to mark column" })
map("n", "`", "'", { desc = "Jump to mark line" })

map("c", "<C-a>", "<Home>", { desc = "Command start" })
map("c", "<C-e>", "<End>", { desc = "Command end" })

map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })

map("n", "s", "<Nop>", { desc = "Disable substitute prefix" })
map("n", "sk", "<cmd>set nosplitbelow<CR><cmd>split<CR><cmd>set splitbelow<CR>", { desc = "Split up" })
map("n", "sj", "<cmd>set splitbelow<CR><cmd>split<CR>", { desc = "Split down" })
map("n", "sh", "<cmd>set nosplitright<CR><cmd>vsplit<CR><cmd>set splitright<CR>", { desc = "Split left" })
map("n", "sl", "<cmd>set splitright<CR><cmd>vsplit<CR>", { desc = "Split right" })

map("n", "tt", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "tn", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "ti", "<cmd>tabnext<CR>", { desc = "Next tab" })

map("n", "<leader>/", "<cmd>set splitbelow<CR><cmd>split<CR><cmd>resize +10<CR><cmd>terminal<CR>", { desc = "Terminal split" })
map("n", "<leader>w", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>ve", "<cmd>edit ~/.config/nvim/init.lua<CR>", { desc = "Edit Neovim config" })
map("n", "<leader>vs", "<cmd>source ~/.config/nvim/init.lua<CR>", { desc = "Source Neovim config" })
